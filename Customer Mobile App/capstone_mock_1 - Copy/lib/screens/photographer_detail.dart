import 'dart:async';
import 'dart:ui';
import 'package:capstone_mock_1/blocs/photographer_blocs/photographer.dart';
import 'package:capstone_mock_1/models/album_model.dart';
import 'package:capstone_mock_1/models/photographer_model.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/album_of_ptg_carousel.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/bottom_sheet_ptg.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/calendar_show_ptg.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/comment_show_ptg.dart';
import 'package:capstone_mock_1/widgets/ptg_screen/service_show_ptg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'album_detail_screen.dart';

class CustomerPhotographerDetail extends StatefulWidget {
  final int id;

  const CustomerPhotographerDetail({this.id});

  @override
  _CustomerPhotographerDetailState createState() =>
      _CustomerPhotographerDetailState();
}

class _CustomerPhotographerDetailState
    extends State<CustomerPhotographerDetail> {
  Completer<void> _completer;
  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocBuilder<PhotographerBloc, PhotographerState>(
          builder: (context, photographerState) {
            if (photographerState is PhotographerIDStateSuccess) {
              print(photographerState.photographer);
              if (photographerState.photographer == null) {
                return Text(
                  'Đà Lạt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                );
              } else {
                return Container(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            transform:
                                Matrix4.translationValues(0.0, -50.0, 0.0),
                            child: Hero(
                              tag: photographerState.photographer.fullname,
                              child: Container(
                                child: Image(
                                  image: AssetImage(
                                      photographerState.photographer.avatar),
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
                                      photographerState.photographer.avatar),
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
                                      text:
                                          '${photographerState.photographer.ratingCount}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: ' đánh giá ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      text: '    |   ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                  TextSpan(
                                    text: ' ★ ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  TextSpan(
                                      text:
                                          '${photographerState.photographer.ratingCount}',
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
                        child:
                            Text('${photographerState.photographer.fullname}',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600,
                                )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text:
                                    '${photographerState.photographer.description}',
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
                            //           text: '${photographerState.photographer.email}',
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
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 70.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Tiếp tục',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            }

            if (photographerState is PhotographerStateLoading) {
              return Padding(
                padding: const EdgeInsets.all(50.0),
                child: CircularProgressIndicator(),
              );
            }

            if (photographerState is PhotographerStateFailure) {
              return Text(
                'Something went wrong',
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              );
            }
            final photographer = (photographerState as PhotographerState).props;
            return RefreshIndicator(
                child: Container(
                  child: Text('Cunt'),
                ),
                onRefresh: () {
                  BlocProvider.of<PhotographerBloc>(context).add(
                      PhotographerEventRefresh(photographer: photographer[0]));
                  return _completer.future;
                });
          },
        ),
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
}
