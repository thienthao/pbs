import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/blocs/album_blocs/album.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/login_bloc.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/user_repository.dart';
import 'package:photographer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/album_respository.dart';
import 'package:photographer_app_java_support/respositories/photographer_respository.dart';
import 'package:photographer_app_java_support/screens/profile_screens/profile_album_screen.dart';
import 'package:photographer_app_java_support/screens/profile_screens/profile_detail_screen.dart';
import 'package:photographer_app_java_support/widgets/profile_screen/profile_body_info.dart';
import 'package:photographer_app_java_support/widgets/profile_screen/profile_body_info_loading.dart';
import 'package:photographer_app_java_support/widgets/profile_screen/profile_body_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userRepository = UserRepository();
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
                    BlocProvider(
                      create: (context) {
                        return LoginBloc(
                          authenticationBloc:
                              BlocProvider.of<AuthenticationBloc>(context),
                          userRepository: userRepository,
                        );
                      },
                      child: ProfileMenuItem(
                        iconSrc: "assets/icons/logout.svg",
                        title: "Đăng xuất",
                        press: () {
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(LoggedOut());
                        },
                      ),
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
        return Center(
          child: InkWell(
            onTap: () {
              BlocProvider.of<PhotographerBloc>(context)
                  .add(PhotographerbyIdEventFetch(id: 168));
            },
            child: Text(
              'Đã xảy ra lỗi trong lúc tải dữ liệu \n Ấn để thử lại',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[300], fontSize: 16),
            ),
          ),
        );
      }
      return Text('');
    });
  }
}
