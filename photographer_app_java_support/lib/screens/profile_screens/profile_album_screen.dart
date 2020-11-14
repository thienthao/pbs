import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/blocs/album_blocs/album.dart';
import 'package:photographer_app_java_support/respositories/album_respository.dart';
import 'package:photographer_app_java_support/screens/profile_screens/album_add_screen.dart';
import 'package:photographer_app_java_support/screens/profile_screens/album_update_screen.dart';
import 'package:photographer_app_java_support/widgets/shared/loading_line.dart';
import 'package:http/http.dart' as http;

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());

  _loadAlbums() {
    BlocProvider.of<AlbumBloc>(context).add(AlbumEventFetchByPhotographerId(id: 168));
  }

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Album của tôi'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (BuildContext context) =>
                            AlbumBloc(albumRepository: _albumRepository),
                        child: AddAlbum())),
              );
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
                width: 320.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF1E4F2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'Thêm Album',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: BlocBuilder<AlbumBloc, AlbumState>(
                builder: (context, albumState) {
                  if (albumState is AlbumStateSuccess) {
                    if (albumState.albums != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              List.generate(albumState.albums.length, (index) {
                            return Column(
                              children: [
                                Container(
                                  color: Theme.of(context).accentColor,
                                  height: 1.0,
                                  width: (size.width - 3.0) / 3.0,
                                ),
                                SizedBox(height: 4.0),
                                Container(
                                  color: Theme.of(context).accentColor,
                                  height: 1.0,
                                  width: (size.width - 2.8) / 2.8,
                                ),
                                SizedBox(height: 4.0),
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 1000),
                                          transitionsBuilder: (BuildContext
                                                  context,
                                              Animation<double> animation,
                                              Animation<double> secAnimation,
                                              Widget child) {
                                            animation = CurvedAnimation(
                                                parent: animation,
                                                curve: Curves
                                                    .fastLinearToSlowEaseIn);
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(1, 0),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: child,
                                            );
                                          },
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double> secAnimation) {
                                            return UpdateAlbum(
                                              album: albumState.albums[index],
                                            );
                                          })),
                                  child: Hero(
                                    tag: albumState.albums[index],
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .accentColor)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: Image(
                                          image: NetworkImage(albumState
                                              .albums[index].thumbnail),
                                          width: (size.width - 2.5) / 2.5,
                                          height: (size.width - 2.5) / 2.5,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      );
                    }
                  }
                  if (albumState is AlbumStateLoading) {
                    return LoadingLine();
                  }

                  if (albumState is AlbumStateFailure) {
                    return Text(
                      'Đã xảy ra lỗi trong lúc tải dữ liệu',
                      style: TextStyle(color: Colors.red[300], fontSize: 16),
                    );
                  }
                  return Text('');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
