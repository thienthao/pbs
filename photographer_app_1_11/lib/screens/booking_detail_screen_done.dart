import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_1_11/models/service_model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BookingDetailScreenDone extends StatefulWidget {
  @override
  _BookingDetailScreenDoneState createState() =>
      _BookingDetailScreenDoneState();
}

class _BookingDetailScreenDoneState extends State<BookingDetailScreenDone> {
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Thông tin chi tiết',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Trạng thái, thời gian & địa điểm',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                wordSpacing: -1,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-1.0, 2.0),
                    blurRadius: 6.0)
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Quicksand'),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Trạng thái:   ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'Hoàn thành',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightGreen[400])),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Quicksand'),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Thời gian chụp ảnh:   ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '12:00, Ngày 10/10/2020',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Quicksand'),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Thời gian tác nghiệp dự kiến:   ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '1 buổi',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Quicksand'),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Thời gian trả ảnh:   ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '16:00, Ngày 15/10/2020',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Quicksand'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Địa điểm:  ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          'Quảng Trường Lâm Viên, Thành Phố Đà Lạt, Tỉnh Lâm Đồng',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.location_pin,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
///////////////////////////////////////////////////////////////////////// Khách
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Thông tin khách hàng',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                wordSpacing: -1,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-1.0, 2.0),
                    blurRadius: 6.0)
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/girl.jpg',
                              ),
                              radius: 30,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Tú Uyên',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(Icons.phone_android_outlined),
                                onPressed: null),
                            IconButton(
                                icon: Icon(Icons.comment_outlined),
                                onPressed: null),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
///////////////////////////////////////////////////////////////////////// Service Package
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Thông tin gói dịch vụ',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                wordSpacing: -1,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-1.0, 2.0),
                    blurRadius: 6.0)
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.zero,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Quicksand',
                              fontSize: 14.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Tên gói:  ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: services[0].name,
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Bao gồm các dịch vụ:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Column(
                        children: services[2]
                            .tasks
                            .asMap()
                            .entries
                            .map((MapEntry mapEntry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.done,
                                  color: Color(0xFFF77474),
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(
                                    services[2].tasks[mapEntry.key],
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      Divider(
                        height: 40.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng cộng:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '${oCcy.format(services[1].price)} đồng',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Nhận xét của khách hàng',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                wordSpacing: -1,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-1.0, 2.0),
                    blurRadius: 6.0)
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/girl.jpg'),
                      radius: 28,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      width: MediaQuery.of(context).size.width * 0.68,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SmoothStarRating(
                                  allowHalfRating: false,
                                  onRated: (v) {
                                    print('You have rate $v stars');
                                  },
                                  starCount: 5,
                                  rating: 4.0,
                                  size: 15.0,
                                  isReadOnly: true,
                                  defaultIconData: Icons.star_border,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0.0),
                              Text(
                                '18/10/2020',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: '',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Quicksand'),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'bởi: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'Tú Uyên',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Quicksand'),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Địa điểm: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'Hồ Chí Minh',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black54, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Bình luận: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'Anh nhiệt tình, có góc nghệ thuật đẹp, em sẽ đặt nữa nếu có nhu cầu ^^',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
