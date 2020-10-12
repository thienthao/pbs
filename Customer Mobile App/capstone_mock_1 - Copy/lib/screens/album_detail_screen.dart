import 'package:capstone_mock_1/models/album_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:intl/intl.dart';

class ImageFullScreen extends StatefulWidget {
  final Album album;

  const ImageFullScreen({this.album});

  @override
  _ImageFullScreenState createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  CardController controller;
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '${widget.album.title}',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
                child: Row(
                  children: [
                    SizedBox(width: 10.0),
                    CircleAvatar(
                      backgroundImage: AssetImage(widget.album.avatarUrl),
                    ),
                    SizedBox(width: 5.0),
                    Text(widget.album.ptgname),
                  ],
                ),
              ),
              Hero(
                tag: widget.album.imageUrl,
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: new TinderSwapCard(
                      swipeUp: true,
                      swipeDown: true,
                      orientation: AmassOrientation.BOTTOM,
                      totalNum: widget.album.images.length,
                      stackNum: 3,
                      swipeEdge: 1.0,
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.9,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      minHeight: MediaQuery.of(context).size.height * 0.8,
                      cardBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Card(
                          elevation: 2,
                          child: Image.asset(
                            '${widget.album.images[index]}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      cardController: controller = CardController(),
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        /// Get swiping card's alignment
                        if (align.x < 0) {
                          //Card is LEFT swiping
                        } else if (align.x > 0) {
                          //Card is RIGHT swiping
                        }
                      },
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) {
                        /// Get orientation & index of swiped card!
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 40.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Wrap(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 28,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.chat_bubble_outline_outlined,
                      size: 28,
                    ),SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.share,
                      size: 28,
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                      text:
                          '${oCcy.format(widget.album.ratingNum)} lượt yêu thích ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[]),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.lens,
                      size: 5.0,
                    ),
                    SizedBox(width: 5.0),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.black54, fontFamily: 'Quicksand'),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Ngày chụp: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '${widget.album.dateCreated}',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.lens,
                      size: 5.0,
                    ),
                    SizedBox(width: 5.0),
                    RichText(
                      text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Thể loại: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '${widget.album.categories}',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.lens,
                      size: 5.0,
                    ),
                    SizedBox(width: 5.0),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.black54, fontFamily: 'Quicksand'),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Địa điểm: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '${widget.album.location}',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black54, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Mô tả: ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      TextSpan(
                        text: '${widget.album.description}',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
