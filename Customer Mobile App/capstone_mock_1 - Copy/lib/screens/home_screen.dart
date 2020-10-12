import 'dart:async';

import 'package:capstone_mock_1/blocs/album_blocs/album.dart';
import 'package:capstone_mock_1/blocs/category_blocs/category.dart';
import 'package:capstone_mock_1/blocs/photographer_blocs/photographer.dart';
import 'package:capstone_mock_1/widgets/home_screen/album_bloc_carousel.dart';
import 'package:capstone_mock_1/widgets/home_screen/icon_carousel.dart';
import 'package:capstone_mock_1/widgets/home_screen/photograph_carousel.dart';
import 'package:capstone_mock_1/widgets/home_screen/sliver_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                onPressed: () {},
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
                        final currentState =
                            categoryState as CategoryStateSuccess;
                        if (currentState.categories.isEmpty) {
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
                              bloc_categories: currentState.categories,
                            ),
                          );
                        }
                      }

                      if (categoryState is CategoryStateLoading) {
                        return Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (categoryState is CategoryStateFailure) {
                        return Text(
                          'Something went wrong',
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
                        final currentState =
                            photographerState as PhotographerStateSuccess;
                        if (currentState.photographers.isEmpty) {
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
                              bloc_photographers: currentState.photographers,
                            ),
                          );
                        }
                      }

                      if (photographerState is PhotographerStateLoading) {
                        return Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (photographerState is PhotographerStateFailure) {
                        return Text(
                          'Something went wrong',
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
                              bloc_photographers: photographers,
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
                        final currentState = albumState as AlbumStateSuccess;
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
                              bloc_albums: currentState.albums,
                            ),
                          );
                        }
                      }

                      if (albumState is AlbumStateLoading) {
                        return Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (albumState is AlbumStateFailure) {
                        return Text(
                          'Something went wrong',
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        );
                      }
                      final albums = (albumState as AlbumStateSuccess).albums;
                      return RefreshIndicator(
                          child: Container(
                            child: AlbumCarousel(
                              bloc_albums: albums,
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
