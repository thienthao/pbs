import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AlbumOfPhotographerLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = [
      Container(
        height: 1000,
        color: Colors.white,
      ),
      Container(
        height: 1000,
        color: Colors.white,
      )
    ];
    return Shimmer.fromColors(
      period: Duration(milliseconds: 800),
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[100],
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 0.9,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
