import 'dart:async';

import 'package:customer_app_1_11/blocs/album_blocs/album.dart';
import 'package:customer_app_1_11/blocs/category_blocs/categories.dart';
import 'package:customer_app_1_11/blocs/photographer_blocs/photographers.dart';
import 'package:customer_app_1_11/shared/loading.dart';
import 'package:customer_app_1_11/widgets/home_screen/album_bloc_carousel.dart';
import 'package:customer_app_1_11/widgets/home_screen/icon_carousel.dart';
import 'package:customer_app_1_11/widgets/home_screen/photograph_carousel.dart';
import 'package:customer_app_1_11/widgets/home_screen/sliver_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  Completer<void> _completer;

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    _loadAlbum();
  }

  _loadAlbum() async {
    context.bloc<AlbumBloc>().add(AlbumEventFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            expandedHeight: 200,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _loadAlbum();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SliverItems(),
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
                              bloc_categories: categoryState.categories,
                            ),
                          );
                        }
                      }

                      if (categoryState is CategoryStateLoading) {
                        return Shimmer.fromColors(
                          period: Duration(milliseconds: 800),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[500],
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 220,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.grey[400],
                                            Colors.grey[300],
                                          ], // whitish to gray
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(1.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                margin: const EdgeInsets.only(
                                    left: 21.0, right: 300.0),
                                height: 3.0,
                              ),
                              SizedBox(height: 20.0),
                              Padding(
                                padding: EdgeInsets.only(left: 7.0),
                                child: Container(
                                  height: 100.0,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 20.0, right: 2.0),
                                            height: 60.0,
                                            width: 60.0,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.grey[500],
                                                  Colors.grey[300],
                                                ], // whitish to gray
                                              ),
                                              // color: selected == index
                                              //     ? Theme.of(context).accentColor
                                              //     : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          SizedBox(height: 2.0),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 20.0,
                                              top: 5,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Colors.grey[400],
                                                    Colors.grey[300],
                                                  ], // whitish to gray
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                              ),
                                              width: 50,
                                              height: 13,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
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
                              bloc_categories: categories,
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
                        if (photographerState.photographers.isEmpty) {
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
                            child: PhotographCarousel(
                              blocPhotographers:
                                  photographerState.photographers,
                            ),
                          );
                        }
                      }

                      if (photographerState is PhotographerStateLoading) {
                        return Shimmer.fromColors(
                          period: Duration(milliseconds: 800),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[500],
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.grey[400],
                                            Colors.grey[300],
                                          ], // whitish to gray
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(1.0),
                                      ),
                                      width: 220,
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                margin: const EdgeInsets.only(
                                    left: 21.0, right: 300.0),
                                height: 3.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 7.0),
                                child: Container(
                                  height: 240.0,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 3,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.all(10.0),
                                        width: 240.0,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black26,
                                                        offset:
                                                            Offset(0.0, 2.0),
                                                        blurRadius: 6.0)
                                                  ]),
                                              child: Stack(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Colors.grey[400],
                                                            Colors.grey[300],
                                                          ], // whitish to gray
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 15.0,
                                                    bottom: 15.0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[400],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        1.0),
                                                          ),
                                                          width: 100,
                                                          height: 24,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[400],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            1.0),
                                                              ),
                                                              width: 35,
                                                              height: 15,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (photographerState is PhotographerStateFailure) {
                        return Text(
                          'Đã xảy ra lỗi khi tải dữ liệu',
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        );
                      }
                      final photographers =
                          (photographerState as PhotographerStateSuccess)
                              .photographers;
                      return RefreshIndicator(
                          child: Container(
                            child: PhotographCarousel(
                              blocPhotographers: photographers,
                            ),
                          ),
                          onRefresh: () {
                            BlocProvider.of<PhotographerBloc>(context).add(
                                PhotographerEventRequested(
                                    photographer: photographers[0]));
                            return _completer.future;
                          });
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
                            child: AlbumCarousel(
                              blocAlbums: currentState.albums,
                            ),
                          );
                        }
                      }

                      if (albumState is AlbumStateLoading) {
                        return Shimmer.fromColors(
                          period: Duration(milliseconds: 800),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[500],
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.grey[400],
                                            Colors.grey[300],
                                          ], // whitish to gray
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(1.0),
                                      ),
                                      width: 220,
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                margin: const EdgeInsets.only(
                                    left: 21.0, right: 300.0),
                                height: 3.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 7.0),
                                child: Container(
                                  height: 400.0,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 3,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.all(10.0),
                                        width: 240.0,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black26,
                                                        offset:
                                                            Offset(0.0, 2.0),
                                                        blurRadius: 6.0)
                                                  ]),
                                              child: Stack(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Colors.grey[400],
                                                            Colors.grey[300],
                                                          ], // whitish to gray
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 15.0,
                                                    bottom: 15.0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[400],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        1.0),
                                                          ),
                                                          width: 100,
                                                          height: 24,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[400],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            1.0),
                                                              ),
                                                              width: 35,
                                                              height: 15,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
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
                SizedBox(height: 100.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
