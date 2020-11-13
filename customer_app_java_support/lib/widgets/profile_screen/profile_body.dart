import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/screens/profile_screens/profile_album_screen.dart';
import 'package:customer_app_java_support/screens/profile_screens/profile_detail_screen.dart';
import 'package:customer_app_java_support/widgets/profile_screen/profile_body_info.dart';
import 'package:customer_app_java_support/widgets/profile_screen/profile_body_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Info(),
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
                    MaterialPageRoute(builder: (context) => Detail()),
                  );
                },
              ),
              ProfileMenuItem(
                iconSrc: "assets/icons/folder.svg",
                title: "Album của tôi",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlbumList()),
                  );
                },
              ),
              ProfileMenuItem(
                iconSrc: "assets/icons/logout.svg",
                title: "Đăng xuất",
                press: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
