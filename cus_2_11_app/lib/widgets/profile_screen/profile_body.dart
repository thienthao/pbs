import 'package:cus_2_11_app/screens/profile_screens/profile_album_screen.dart';
import 'package:cus_2_11_app/screens/profile_screens/profile_detail_screen.dart';
import 'package:cus_2_11_app/widgets/profile_screen/profile_body_info.dart';
import 'package:cus_2_11_app/widgets/profile_screen/profile_body_menu_item.dart';
import 'package:flutter/material.dart';

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
                press: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
