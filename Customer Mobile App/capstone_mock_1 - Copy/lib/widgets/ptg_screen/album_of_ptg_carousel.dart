
import 'package:capstone_mock_1/models/album_model.dart';
import 'package:capstone_mock_1/screens/album_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart'; 

class AlbumOfPhotographerCarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = albums
        .map((item) => Container(
      height: 1000,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              // MaterialPageRoute(
              //   builder: (_) => ImageFullScreen(image: item.imageUrl),
              // ),
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation,
                      Widget child) {
                    animation = CurvedAnimation(
                        parent: animation, curve: Curves.easeInOutBack);
                    return ScaleTransition(
                        scale: animation,
                        child: child,
                        alignment: Alignment.center);
                  },
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation) {
                    return ImageFullScreen(album: item);
                  }));
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 5.0, vertical: 0.0),
                child: Center(
                  child: Hero(
                    tag: item.imageUrl,
                    child: Image(
                      image: AssetImage(item.imageUrl),
                      height: 460.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15.0,
              right: 15.0,
              top: 20.0,
              child: Container(
                width: 250.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: <Widget>[
                            Text(
                              item.location,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(1, 3),
                                        blurRadius: 6)
                                  ]),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            Text(
                              '${item.dateCreated}  ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(1, 3),
                                        blurRadius: 6)
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 15.0,
              right: 15.0,
              bottom: 20.0,
              child: Container(
                width: 250.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          item.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w400,
                              shadows: [
                                Shadow(
                                    offset: Offset(1, 3), blurRadius: 6)
                              ]),
                        ),
                        Wrap(
                          children: [
                            Text(
                              '${item.ratingNum}  ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(1, 3),
                                        blurRadius: 6)
                                  ]),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                              Icons.favorite,
                              size: 18.0,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                    Text(
                      item.categories,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w200,
                          shadows: [
                            Shadow(offset: Offset(1, 3), blurRadius: 6)
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ))
        .toList();
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 0.9,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            ),
          ],
        ));
  }
}
