import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key key,
    this.iconSrc,
    this.title,
    this.press,
  }) : super(key: key);
  final String iconSrc, title;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                iconSrc,
                color: Colors.black87,
                height: 15,
                width: 15,
              ),
              SizedBox(width: 20.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0, //16
                  color: Color(0xFF7286A5),
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 15.0,
                color: Color(0xFF7286A5),
              )
            ],
          ),
        ),
      ),
    );
  }
}
