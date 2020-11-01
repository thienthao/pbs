import 'package:customer_app_1_11/models/category_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 

class IconCarousel extends StatefulWidget {
  List<CategoryBlocModel> bloc_categories;

  IconCarousel({this.bloc_categories});

  @override
  _IconCarouselState createState() => _IconCarouselState();
}

class _IconCarouselState extends State<IconCarousel> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Phong cách bạn muốn là gì?',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  wordSpacing: -1,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: const EdgeInsets.only(left: 21.0, right: 300.0),
          height: 3.0,
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.only(left: 7.0),
          child: Container(
            height: 100.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.bloc_categories.length,
              itemBuilder: (BuildContext context, int index) {
                CategoryBlocModel category = widget.bloc_categories[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 2.0),
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          gradient: selected == index
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).accentColor,
                                  ], // whitish to gray
                                )
                              : LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey[500],
                                    Colors.grey[300],
                                  ], // whitish to gray
                                ),
                          // color: selected == index
                          //     ? Theme.of(context).accentColor
                          //     : Colors.grey[200],
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: SvgPicture.network(
                            category.iconLink,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(category.category),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
