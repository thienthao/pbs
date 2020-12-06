import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

// ignore: must_be_immutable
class ServiceShow extends StatefulWidget {
  final List<PackageBlocModel> blocPackages;
  Function(PackageBlocModel) onSelectParam;

  ServiceShow({this.blocPackages, this.onSelectParam});

  @override
  _ServiceShowState createState() => _ServiceShowState();
}

class _ServiceShowState extends State<ServiceShow> {
  PackageBlocModel _packageRadio = new PackageBlocModel();

  intl.NumberFormat oCcy = intl.NumberFormat("#,##0", "vi_VN");
  int numberOfMultiDaysPackage = 0;

  @override
  void initState() {
    super.initState();
    _packageRadio = widget.blocPackages[0];
    widget.onSelectParam(_packageRadio);
  }

  Widget _buildSingleDayPackages() {
    return Column(
      children: [
        ExpandChild(
          expandArrowStyle: ExpandArrowStyle.both,
          collapsedHint: "Gói chụp trong ngày",
          expandedHint: "Gói chụp trong ngày",
          hintTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          child: Column(
            children:
                widget.blocPackages.asMap().entries.map((MapEntry mapEntry) {
              if (!widget.blocPackages[mapEntry.key].supportMultiDays) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 2.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                  activeColor: Color(0xFFF77474),
                                  value: widget.blocPackages[mapEntry.key],
                                  groupValue: _packageRadio,
                                  onChanged: (value) {
                                    setState(() {
                                      _packageRadio = value;
                                      widget.onSelectParam(_packageRadio);
                                    });
                                  }),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.blocPackages[mapEntry.key].name}',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Thời gian chụp:',
                                          style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(width: 10.0),
                                        Flexible(
                                          child: Text(
                                            // '${widget.blocPackages[mapEntry.key].name}  buổi',
                                            '6 giờ',
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3.0),
                                    Row(
                                      children: [
                                        Text(
                                          'Giá thành:',
                                          style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          '${oCcy.format(widget.blocPackages[mapEntry.key].price)} đồng',
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 40.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Column(
                          children: widget
                              .blocPackages[mapEntry.key].serviceDtos
                              .asMap()
                              .entries
                              .map((MapEntry map) {
                            return Padding(
                              padding: const EdgeInsets.all(
                                10.0,
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
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.blocPackages[mapEntry.key]
                                          .serviceDtos[map.key].name,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RichText(
                            text: TextSpan(
                              text: '',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Quicksand'),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Mô tả: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                TextSpan(
                                  text:
                                      '${widget.blocPackages[mapEntry.key].description}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                numberOfMultiDaysPackage++;
                return SizedBox();
              }
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiDaysPackages() {
    return numberOfMultiDaysPackage == 0
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Text(
              'Hiện tại photographer này chưa hỗ trợ gói chụp nhiều ngày',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )),
          )
        : Column(
            children: [
              ExpandChild(
                expandArrowStyle: ExpandArrowStyle.both,
                collapsedHint: "Gói chụp nhiều ngày",
                expandedHint: "Gói chụp nhiều ngày",
                hintTextStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                child: Column(
                  children: widget.blocPackages
                      .asMap()
                      .entries
                      .map((MapEntry mapEntry) {
                    if (widget.blocPackages[mapEntry.key].supportMultiDays) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 2.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 20.0),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Radio(
                                        activeColor: Color(0xFFF77474),
                                        value:
                                            widget.blocPackages[mapEntry.key],
                                        groupValue: _packageRadio,
                                        onChanged: (value) {
                                          setState(() {
                                            _packageRadio = value;
                                            widget.onSelectParam(_packageRadio);
                                          });
                                        }),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.blocPackages[mapEntry.key].name}',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Giá thành:',
                                                style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(width: 10.0),
                                              Text(
                                                '${oCcy.format(widget.blocPackages[mapEntry.key].price)} đồng',
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 40.0,
                                indent: 20.0,
                                endIndent: 20.0,
                              ),
                              Column(
                                children: widget
                                    .blocPackages[mapEntry.key].serviceDtos
                                    .asMap()
                                    .entries
                                    .map((MapEntry map) {
                                  return Padding(
                                    padding: const EdgeInsets.all(
                                      10.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.done,
                                          color: Color(0xFFF77474),
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.blocPackages[mapEntry.key]
                                                .serviceDtos[map.key].name,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: RichText(
                                  text: TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Quicksand'),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Mô tả: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      TextSpan(
                                        text:
                                            '${widget.blocPackages[mapEntry.key].description}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }).toList(),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: [
            _buildSingleDayPackages(),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            _buildMultiDaysPackages(),
          ],
        ),
      ],
    );
  }
}
