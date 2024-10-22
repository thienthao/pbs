import 'dart:math' as math;

import 'package:customer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/comment_bloc_model.dart';
import 'package:customer_app_java_support/screens/rating_screen/backgroundColorTween.dart';
import 'package:customer_app_java_support/screens/rating_screen/flare_controller.dart';
import 'package:customer_app_java_support/screens/rating_screen/slider_painter.dart';
import 'package:customer_app_java_support/shared/pop_up.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

enum SlideState { Worst, Bad, OK, Good, Excellent }

class RatingScreen extends StatefulWidget {
  final int bookingId;
  final Function(bool) onRatingSuccess;
  const RatingScreen({this.bookingId, this.onRatingSuccess});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _commentTextController = TextEditingController();
  FlareRateController _flareRateController;
  AnimationController _controller;
  double sliderWidth = 340;
  double sliderHeight = 50;
  double _dragPercent = 0.0;
  double rating = 1.0;

  _postComment() async {
    CommentBlocModel _comment = CommentBlocModel(
        bookingId: widget.bookingId,
        cusId: globalCusId,
        rating: rating,
        comment: _commentTextController.text,
        createdAt: DateFormat("yyyy-MM-dd'T'HH:mm").format(DateTime.now()));
    print('${_comment.bookingId} ${_comment.cusId} '
        ' ${_comment.rating} '
        ' ${_comment.comment} '
        ' ${_comment.createdAt}');
    BlocProvider.of<CommentBloc>(context)
        .add(CommentEventPost(comment: _comment));
  }

  SlideState slideState = SlideState.Worst;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Ý kiến của bạn',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Bạn không thể bỏ trống trường này.';
                      }
                      return null;
                    },
                    controller: _commentTextController,
                    cursorColor: Color(0xFFF77474),
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nhập ý kiến của bạn...'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Hủy bỏ'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            FlatButton(
              child: Text('Xác nhận'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateDragPosition(Offset offset) {
    setState(() {
      _dragPercent = (offset.dx / sliderWidth).clamp(0.0, 1.0);
      _flareRateController.updatePercent(_dragPercent);

      if (_dragPercent >= 0 && _dragPercent < .2) {
        slideState = SlideState.Worst;
        rating = 1.0;
        _controller.forward(from: 0.0);
      } else if (_dragPercent >= .2 && _dragPercent < .4) {
        slideState = SlideState.Bad;
        rating = 2.0;
        _controller.stop();
      } else if (_dragPercent >= .4 && _dragPercent < .6) {
        slideState = SlideState.OK;
        rating = 3.0;
      } else if (_dragPercent >= .6 && _dragPercent < .8) {
        slideState = SlideState.Good;
        rating = 4.0;
      } else if (_dragPercent >= .8) {
        slideState = SlideState.Excellent;
        rating = 5.0;
      }
      print(slideState);
    });
  }

  Widget displayTitle() {
    switch (slideState) {
      case SlideState.Worst:
        return Text(
          '★',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
          key: Key('Kém'),
        );
      case SlideState.Bad:
        return Text(
          '★★',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
          key: Key('Tệ'),
        );
      case SlideState.OK:
        return Text(
          '★★★',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
          key: Key('Bình thường'),
        );
      case SlideState.Good:
        return Text(
          '★★★★',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
          key: Key('Tốt'),
        );
      case SlideState.Excellent:
        return Text(
          '★★★★★',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
          key: Key('Tuyệt vời'),
        );
      default:
        return Text('');
    }
  }

  void _onDragStart(BuildContext context, DragStartDetails details) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.localToGlobal(details.globalPosition);
    updateDragPosition(localOffset);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails details) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.localToGlobal(details.globalPosition);
    updateDragPosition(localOffset);
  }

  @override
  void initState() {
    super.initState();
    _flareRateController = FlareRateController();
    _flareRateController.updatePercent(_dragPercent);
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750))
          ..addListener(() {
            setState(() {});
          });
  }

  _shake() {
    double offset = math.sin(_controller.value * math.pi * 60.0);
    return vector.Vector3(offset * 2, offset * 2, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentStateLoading) {
          popNotice(context);
        }

        if (state is CommentStateFailure) {
          removeNotice(context);
          popUp(context, 'Bình luận',
              'Bình luận thất bại, bình luận của bạn sẽ không được hiển thị');
        }
        if (state is CommentStatePostedSuccess) {
          widget.onRatingSuccess(true);
          removeNotice(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
          popUp(context, 'Bình luận', 'Bình luận thành công!!');
        }
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        color: backgroundTween.evaluate(AlwaysStoppedAnimation(_dragPercent)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              _buildAppBar(),
              _buildHeaderText(),
              SizedBox(
                height: 50.h,
              ),
              _buildTitle(),
              SizedBox(
                height: 50.h,
              ),
              _buildFlareActor(),
              SizedBox(
                height: 50.h,
              ),
              _buildSlider(),
              SizedBox(
                height: 5.h,
              ),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() => Padding(
        padding: EdgeInsets.fromLTRB(40.w, 120.h, 80.w, 10.h),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, size: 85.h),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

  _buildHeaderText() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 120.w),
        child: Text(
          'Dịch vụ của bạn thế nào?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
        ),
      );

  _buildTitle() => AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (child, anim) {
        var slideAnim = Tween<Offset>(begin: Offset(-2, 0), end: Offset(0, 0))
            .animate(anim);
        return ClipRect(
          child: SlideTransition(
            position: slideAnim,
            child: child,
          ),
        );
      },
      child: displayTitle());

  _buildFlareActor() => Transform(
        transform: Matrix4.translation(_shake()),
        child: SizedBox(
          width: 1100.w,
          height: 500.h,
          child: FlareActor(
            'assets/rate.flr',
            artboard: 'Artboard',
            controller: _flareRateController,
          ),
        ),
      );

  _buildSlider() => GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) =>
            _onDragStart(context, details),
        onHorizontalDragUpdate: (DragUpdateDetails details) =>
            _onDragUpdate(context, details),
        child: Container(
          width: sliderWidth,
          height: sliderHeight,
          child: CustomPaint(
            painter: SliderPainter(progress: _dragPercent),
          ),
        ),
      );

  _buildBottom() => Column(
        children: [
          GestureDetector(
            onTap: () {
              _showMyDialog();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
              child: TextField(
                maxLines: 2,
                enabled: false,
                controller: _commentTextController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Viết bình luận của bạn...',
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40.h),
          ButtonTheme(
            minWidth: 920.0.w,
            height: 160.0.h,
            child: RaisedButton(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(12.0),
              ),
              child: Text(
                'Hoàn thành',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.sp,
                ),
              ),
              onPressed: () {
                _postComment();
              },
            ),
          ),
        ],
      );
}
