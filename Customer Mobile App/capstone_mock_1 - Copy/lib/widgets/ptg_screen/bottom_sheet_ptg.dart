import 'package:capstone_mock_1/blocs/booking_blocs/bookings.dart';
import 'package:capstone_mock_1/models/booking_bloc_model.dart';
import 'package:capstone_mock_1/models/package_bloc_model.dart';
import 'package:capstone_mock_1/models/photographer_bloc_model.dart';
import 'package:capstone_mock_1/screens/date_picker_screen.dart';
import 'package:capstone_mock_1/screens/map_picker_screen.dart';
import 'package:capstone_mock_1/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';

import 'drop_menu_book.dart';

class BottomSheetShow extends StatefulWidget {
  final PackageBlocModel selectedPackage;
  final Photographer photographerName;
  final List<PackageBlocModel> blocPackages;
  const BottomSheetShow(
      {this.photographerName, this.blocPackages, this.selectedPackage});

  @override
  _BottomSheetShowState createState() => _BottomSheetShowState();
}

class _BottomSheetShowState extends State<BottomSheetShow> {
  String selectedItem = '';
  dynamic result;
  String timeResult = 'Hãy chọn thời gian chụp';
  String timeReturnResult = 'Hãy chọn thời gian nhận';
  String locationResult = 'Hãy chọn nơi bạn muốn chụp ảnh';

  String startDate = '';
  String endDate = '';
  String location = '';
  double latitude;
  double longitude;

  PackageBlocModel packageResult;
  // LocationData currentLocation;

//  getUserLocation() async {
//     //call this async method from whereever you need
//     LocationData myLocation;
//     String error;
//     Location location = new Location();
//     try {
//       myLocation = await location.getLocation();
//     } on PlatformException catch (e) {
//       if (e.code == 'PERMISSION_DENIED') {
//         error = 'please grant permission';
//         print(error);
//       }
//       if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//         error = 'permission denied- please enable it from app settings';
//         print(error);
//       }
//       myLocation = null;
//     }
//     final coordinates =
//         new Coordinates(myLocation.latitude, myLocation.longitude);
//     var addresses =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     print(
//         ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
//     locationResult = '${first.addressLine} ${first.coordinates}';
//     return locationResult;
//   }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packageResult = widget.selectedPackage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            width: MediaQuery.of(context).size.width * 0.15,
            margin: EdgeInsets.only(top: 10.0),
            height: 3.0,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: 15.0, top: 20.0),
            child: Text(
              'Đặt lịch với ${widget.photographerName.fullname}',
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: const EdgeInsets.only(left: 15.0, right: 310.0),
          height: 3.0,
        ),
        SizedBox(height: 20.0),
        Container(
          child: Text(
            'Thông tin chi tiết',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.w600,
              wordSpacing: -1,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 25.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05, right: 15),
              child: Icon(
                Icons.person,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'Photographer:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${widget.photographerName.fullname}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05, right: 15),
              child: Icon(
                Icons.timer,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 28.0,
              ),
              child: Text(
                'Thời gian chụp:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: GestureDetector(
                child: Container(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        timeResult,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  final pageResult =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DatePicker(
                                onSelecParam: (DateTime result) {
                                  startDate = result.toString();
                                },
                              )));
                  setState(() {
                    if (pageResult != null) {
                      timeResult = pageResult;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.pink,
                size: 20.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05, right: 15),
              child: Icon(
                Icons.timer,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 20.0,
              ),
              child: Text(
                'Thời gian nhận:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: GestureDetector(
                child: Container(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        timeReturnResult,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  final pageResult =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DatePicker(
                                onSelecParam: (DateTime result) {
                                  endDate = result.toString();
                                },
                              )));
                  setState(() {
                    if (pageResult != null) {
                      timeReturnResult = pageResult;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.pink,
                size: 20.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05, right: 15),
              child: Icon(
                Icons.location_on,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 40.0,
              ),
              child: Text(
                'Địa điểm:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: GestureDetector(
                child: Container(
                  width: 200,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      locationResult,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                onTap: () async {
                  final pageResult = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MapPicker()));
                  setState(() {
                    if (pageResult != null) {
                      locationResult = pageResult;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.pink,
                size: 20.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05, right: 15),
              child: Icon(
                Icons.loyalty,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              'Gói dịch vụ:',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.08, right: 15),
          child: DropMenu(
            blocPackages: widget.blocPackages,
            selectedPackage: widget.selectedPackage,
            onSelectParam: (PackageBlocModel package) {
              packageResult = package;
            },
          ),
        ),
        SizedBox(height: 30.0),
        RaisedButton(
          onPressed: () {
            var startDateTemp =
                DateFormat("yyyy-MM-dd").format(DateTime.parse(startDate));
            var endDateTemp =
                DateFormat("yyyy-MM-dd").format(DateTime.parse(endDate));
            if (timeResult == 'Hãy chọn thời gian chụp') {
              validateNotice('Mời bạn chọn thời gian chụp');
            } else if (timeReturnResult == 'Hãy chọn thời gian nhận') {
              validateNotice('Mời bạn chọn thời gian nhận ảnh');
            } else if (locationResult == 'Hãy chọn nơi bạn muốn chụp ảnh') {
              validateNotice('Mời bạn chọn nơi chụp ảnh');
            } else if (DateTime.parse(startDateTemp)
                        .compareTo(DateTime.parse(endDateTemp)) +
                    1 >
                1) {
              validateNotice(
                  'Thời gian nhận ảnh phải sau thời gian chụp ít nhất 1 ngày');
            } else {
              print(
                  '${widget.photographerName} $timeResult, $timeResult, $timeReturnResult, $locationResult, ${packageResult.serviceDtos[0].name}');
              BookingBlocModel booking = BookingBlocModel(
                  startDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                      .format(DateTime.parse(startDate)),
                  endDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                      .format(DateTime.parse(endDate)),
                  serviceName: packageResult.name,
                  price: packageResult.price,
                  location: locationResult,
                  photographer: Photographer(id: widget.photographerName.id),
                  package: packageResult);
              BlocProvider.of<BookingBloc>(context)
                  .add(BookingEventCreate(booking: booking));
              selectItem('Done');
            }
          },
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            'Đặt dịch vụ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void selectItem(String name) async {
    setState(() {
      selectedItem = name;
    });
    Center(
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, bookingState) {
          if (bookingState is BookingStateCreatedSuccess) {
            print(bookingState.isSuccess);
            if (!bookingState.isSuccess) {
              return Text(
                'Đà Lạt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              );
            } else {
              print('success');
              StatusAlert.show(
                context,
                duration: Duration(seconds: 2),
                title: 'Gửi yêu cầu thành công ',
                configuration: IconConfiguration(
                  icon: Icons.done,
                ),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          }

          if (bookingState is BookingStateLoading) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Loading(),
            );
          }

          if (bookingState is BookingStateFailure) {
            StatusAlert.show(
              context,
              duration: Duration(seconds: 2),
              title: 'Gửi yêu cầu thất bại',
              configuration: IconConfiguration(
                icon: Icons.error_outline_outlined,
              ),
            );
          }
          return Text('Gửi yêu cầu thành công');
        },
      ),
    );
    Navigator.pop(context);
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Gửi yêu cầu thành công ',
      configuration: IconConfiguration(
        icon: Icons.done,
      ),
    );
  }

  void validateNotice(String name) async {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: name,
      titleOptions:
          StatusAlertTextConfiguration(style: TextStyle(fontSize: 18)),
      configuration: IconConfiguration(
        icon: Icons.error_outline_outlined,
      ),
    );
  }
}
