import 'dart:async';

import 'package:capstone_mock_1/blocs/album_blocs/album_bloc.dart';
import 'package:capstone_mock_1/blocs/album_blocs/album_event.dart';
import 'package:capstone_mock_1/blocs/album_blocs/album_state.dart';
import 'package:capstone_mock_1/widgets/home_screen/album_bloc_carousel.dart';
import 'package:capstone_mock_1/widgets/home_screen/icon_carousel.dart';
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
        body: ListView(
      children: [
        SizedBox(height: 20.0),
        IconCarousel(),
        SizedBox(height: 20.0),
        // PhotographCarousel(),
        SizedBox(height: 20.0),
        Center(
          child: BlocBuilder<AlbumBloc, AlbumState>(
            builder: (context, albumState) {
              print('albumState $albumState');
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
                return Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    CircularProgressIndicator(),
                  ],
                );
              }

              if (albumState is AlbumStateFailure) {
                return Text(
                  'Something went wrong',
                  style: TextStyle(color: Colors.red[300], fontSize: 16),
                );
              }
              final albums = (albumState as AlbumStateSuccess).albums;
              return RefreshIndicator(
                  child: Container(
                    child: Text('Hi'),
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
    ));
  }
}
