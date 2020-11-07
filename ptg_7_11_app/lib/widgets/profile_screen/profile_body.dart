import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg_7_11_app/blocs/album_blocs/album.dart';
import 'package:ptg_7_11_app/blocs/photographer_blocs/photographers.dart';
import 'package:ptg_7_11_app/models/photographer_bloc_model.dart';
import 'package:ptg_7_11_app/respositories/album_respository.dart';
import 'package:ptg_7_11_app/respositories/photographer_respository.dart';
import 'package:ptg_7_11_app/screens/profile_screens/profile_album_screen.dart';
import 'package:ptg_7_11_app/screens/profile_screens/profile_detail_screen.dart';
import 'package:ptg_7_11_app/widgets/profile_screen/profile_body_info.dart';
import 'package:ptg_7_11_app/widgets/profile_screen/profile_body_info_loading.dart';
import 'package:ptg_7_11_app/widgets/profile_screen/profile_body_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Photographer _photographer;
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotographerBloc, PhotographerState>(
        builder: (context, photographerState) {
      if (photographerState is PhotographerIDStateSuccess) {
        _photographer = photographerState.photographer;
        if (photographerState.photographer != null) {
          return Column(
            children: [
              Info(
                photographer: photographerState.photographer,
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    ProfileMenuItem(
                      iconSrc: "assets/icons/avatar.svg",
                      title: "Thông tin của tôi",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (BuildContext context) =>
                                        PhotographerBloc(
                                            photographerRepository:
                                                _photographerRepository),
                                    child: Detail(
                                      photographer: _photographer,
                                    ),
                                  )),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      iconSrc: "assets/icons/folder.svg",
                      title: "Album của tôi",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (BuildContext context) => AlbumBloc(
                                      albumRepository: _albumRepository),
                                  child: AlbumList())),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      iconSrc: "assets/icons/logout.svg",
                      title: "Đăng xuất",
                      press: () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }
      if (photographerState is PhotographerStateLoading) {
        return Column(
          children: [
            InfoLoading(),
          ],
        );
      }

      if (photographerState is PhotographerStateFailure) {
        return Text(
          'Đã xảy ra lỗi trong lúc tải dữ liệu',
          style: TextStyle(color: Colors.red[300], fontSize: 16),
        );
      }
      return Text('');
    });
  }
}
