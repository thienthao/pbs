import 'dart:async';
import 'package:customer_app_java_support/blocs/album_blocs/album.dart';
import 'package:customer_app_java_support/blocs/category_blocs/categories.dart';
import 'package:customer_app_java_support/blocs/photographer_alg_blocs/photographers_alg.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
import 'package:customer_app_java_support/screens/home_screens/search_ptg_service.dart';
import 'package:customer_app_java_support/shared/home_screen_album_carousel_loading.dart';
import 'package:customer_app_java_support/shared/home_screen_category_loading.dart';
import 'package:customer_app_java_support/shared/home_screen_ptg_carousel_loading.dart';
import 'package:customer_app_java_support/widgets/home_screen/album_bloc_carousel.dart';
import 'package:customer_app_java_support/widgets/home_screen/icon_carousel.dart';
import 'package:customer_app_java_support/widgets/home_screen/photograph_carousel.dart';
import 'package:customer_app_java_support/widgets/home_screen/photograph_carousel_byfactor_alg.dart';
import 'package:customer_app_java_support/widgets/home_screen/sliver_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  String ptgServiceResult = '';
  String city = '';
  LatLng selectedLatlng = LatLng(0.0, 0.0);
  int selectedCategory = 1;
  @override
  void dispose() {
    super.dispose();
  }

  Completer<void> _completer;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _completer = Completer<void>();

    _loadAlbums(1);
    _loadPhotographers(1, selectedLatlng, city);

    Timer(Duration(seconds: 5), () {
      BlocProvider.of<PhotographerAlgBloc>(context)
          .add(PhotographerAlgEventFetchByFactorAlg());
    });
  }

  _loadAlbums(_categoryId) async {
    BlocProvider.of<AlbumBloc>(context)
        .add(AlbumEventFetch(categoryId: _categoryId));
  }

  _loadPhotographers(int _categoryId, LatLng _latLng, String _city) async {
    BlocProvider.of<PhotographerBloc>(context).add(PhotographerEventFetch(
        categoryId: _categoryId, latLng: _latLng, city: _city));
  }

  _filteredByCategoryId(_categoryId, _latLng, _city) async {
    _loadAlbums(
      _categoryId,
    );
    _loadPhotographers(_categoryId, _latLng, _city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 220,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return BlocProvider(
                          create: (context) => PhotographerBloc(
                              photographerRepository: _photographerRepository),
                          child: SearchPtgService(),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SliverItems(
                onChangeLocation: (Map result) {
                  double _lat = result['lat'];
                  double _long = result['long'];
                  city = result['name'];
                  selectedLatlng = LatLng(_lat, _long);
                  _filteredByCategoryId(selectedCategory, selectedLatlng, city);
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                SizedBox(height: 20.0),
                Center(
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, categoryState) {
                      if (categoryState is CategoryStateSuccess) {
                        if (categoryState.categories.isEmpty) {
                          return Text(
                            'Đà Lạt',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        } else {
                          return Container(
                            child: IconCarousel(
                              blocCategories: categoryState.categories,
                              onSelectedCategory: (int _selectedCategory) {
                                setState(() {
                                  selectedCategory = _selectedCategory;
                                  _filteredByCategoryId(
                                      selectedCategory, selectedLatlng, city);
                                });
                              },
                            ),
                          );
                        }
                      }

                      if (categoryState is CategoryStateLoading) {
                        return HomeScreenCategoryLoadingWidget();
                      }

                      if (categoryState is CategoryStateFailure) {
                        return Text(
                          'Đã xảy ra lỗi khi tải dữ liệu',
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        );
                      }
                      final categories =
                          (categoryState as CategoryStateSuccess).categories;
                      return RefreshIndicator(
                          child: Container(
                            child: IconCarousel(
                              blocCategories: categories,
                            ),
                          ),
                          onRefresh: () {
                            BlocProvider.of<CategoryBloc>(context).add(
                                CategoryEventRequested(
                                    category: categories[0]));
                            return _completer.future;
                          });
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: BlocBuilder<PhotographerBloc, PhotographerState>(
                    builder: (context, photographerState) {
                      if (photographerState is PhotographerStateSuccess) {
                        if (photographerState.photographers.length == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Text(
                              'Hiện tại chưa có Photographer nào phù hợp với ý của bạn',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            child: PhotographCarousel(
                              blocPhotographers:
                                  photographerState.photographers,
                            ),
                          );
                        }
                      }

                      if (photographerState is PhotographerStateLoading) {
                        return HomeScreenPtgCarouselLoadingWidget();
                      }

                      if (photographerState is PhotographerStateFailure) {
                        return Text(
                          'Đã xảy ra lỗi khi tải dữ liệu',
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: BlocBuilder<PhotographerAlgBloc, PhotographerAlgState>(
                    builder: (context, photographerState) {
                      if (photographerState is PhotographerAlgStateSuccess) {
                        if (photographerState.photographers.length == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Text(
                              'Hiện tại chưa có Photographer nào theo ý của bạn',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        } else {
                          return AnimatedSwitcher(
                            key: ValueKey<int>(_count),
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                  child: child, opacity: animation);
                            },
                            child: Container(
                              child: PhotographCarouselByFactorAlg(
                                blocPhotographers:
                                    photographerState.photographers,
                              ),
                            ),
                          );
                        }
                      }

                      if (photographerState is PhotographerAlgStateLoading) {
                        _count++;
                        return HomeScreenPtgCarouselLoadingWidget();
                      }

                      if (photographerState is PhotographerAlgStateFailure) {
                        return Text(
                          'Đã xảy ra lỗi khi tải dữ liệu',
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: BlocBuilder<AlbumBloc, AlbumState>(
                    builder: (context, albumState) {
                      if (albumState is AlbumStateSuccess) {
                        final currentState = albumState;
                        if (currentState.albums.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Text(
                              'Hiện tại chưa có Album nào theo thể loại này',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            child: AlbumCarousel(
                              blocAlbums: currentState.albums,
                            ),
                          );
                        }
                      }

                      if (albumState is AlbumStateLoading) {
                        return HomeScreenAlbumCarouselLoadingWidget();
                      }

                      if (albumState is AlbumStateFailure) {
                        return Text(
                          'Đã xảy ra lỗi khi tải dữ liệu',
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        );
                      }
                      final albums = (albumState as AlbumStateSuccess).albums;
                      return RefreshIndicator(
                          child: Container(
                            child: AlbumCarousel(
                              blocAlbums: albums,
                            ),
                          ),
                          onRefresh: () {
                            BlocProvider.of<AlbumBloc>(context)
                                .add(AlbumEventRefresh(album: albums[0]));
                            return _completer.future;
                          });
                    },
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
