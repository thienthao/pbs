import 'dart:ui';
import 'package:capstone_mock_1/models/album_model.dart';
import 'package:capstone_mock_1/models/photographer_model.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/album_of_ptg_carousel.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/bottom_sheet_ptg.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/calendar_show_ptg.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/comment_show_ptg.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/service_show_ptg.dart';
import 'package:flutter/material.dart';
import 'album_detail_screen.dart';

class CustomerPhotographerDetail extends StatefulWidget { 
  final Photographer photographer;

  const CustomerPhotographerDetail({this.photographer});

  @override
  _CustomerPhotographerDetailState createState() =>
      _CustomerPhotographerDetailState();
}

class _CustomerPhotographerDetailState
    extends State<CustomerPhotographerDetail> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                child: Hero(
                  tag: widget.photographer.ptgname,
                  child: Container(
                    child: Image(
                      image: AssetImage(widget.photographer.coverUrl),
                      height: 220.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.only(left: 30.0),
                    onPressed: () => Navigator.pop(context),
                    icon: RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.expand_more,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                    iconSize: 30.0,
                    color: Colors.white,
                  ),
                ],
              ),
              Positioned.fill(
                left: 30.0,
                right: 30.0,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        widget.photographer.avatarUrl,
                      ),
                      radius: 55,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 160.0,
                child: RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${widget.photographer.bookingNumber}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' đánh giá ',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      TextSpan(
                          text: '    |   ',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      TextSpan(
                        text: ' ★ ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.amber,
                        ),
                      ),
                      TextSpan(
                          text: '${widget.photographer.rating}',
                          style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 2.0, 0.0, 0.0),
            child: Text('${widget.photographer.ptgname}',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: '${widget.photographer.description}',
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10.0),
                //   child: RichText(
                //     text: TextSpan(
                //       text: '',
                //       style: TextStyle(
                //           color: Colors.black54, fontFamily: 'Quicksand'),
                //       children: <TextSpan>[
                //         TextSpan(
                //             text: 'Liên hệ:   ',
                //             style: TextStyle(
                //                 color: Colors.black,
                //                 fontWeight: FontWeight.bold)),
                //         TextSpan(
                //           text: '${widget.photographer.email}',
                //           style: TextStyle(fontWeight: FontWeight.normal),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text(
              'Album',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          AlbumOfPhotographerCarouselWidget(),
          SizedBox(height: 20.0),
          CommentShow(),
          CalendarView(),
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
            child: Text(
              'Các gói dịch vụ',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          ServiceShow(),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: RaisedButton(
              onPressed: () => onPressedButton(),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 70.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                'Tiếp tục',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onPressedButton() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          color: Color(0xFF737373),
          child: Container(
            child: BottomSheetShow(),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
          ),
        );
      },
    );
  }

  _albumSelector(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 0.9);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 440.0,
            width: Curves.easeInOut.transform(value) * 280.0,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
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
                    return ImageFullScreen(album: albums[index]);
                  }));
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                child: Center(
                  child: Hero(
                    tag: albums[index].imageUrl,
                    child: Image(
                      image: AssetImage(albums[index].imageUrl),
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
                              albums[index].location,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(offset: Offset(1, 3), blurRadius: 6)
                                  ]),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            Text(
                              '${albums[index].dateCreated}  ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(offset: Offset(1, 3), blurRadius: 6)
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
                          albums[index].title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w400,
                              shadows: [
                                Shadow(offset: Offset(1, 3), blurRadius: 6)
                              ]),
                        ),
                        Wrap(
                          children: [
                            Text(
                              '${albums[index].ratingNum}  ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(offset: Offset(1, 3), blurRadius: 6)
                                  ]),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                              Icons.favorite,
                              size: 18.0,
                              color: Colors.pinkAccent,
                            )
                          ],
                        ),
                      ],
                    ),
                    Text(
                      albums[index].categories,
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
    );
  }
}
