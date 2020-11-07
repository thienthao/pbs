import 'package:cus_2_11_app/models/package_bloc_model.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _packageRadio = widget.blocPackages[0];
    widget.onSelectParam(_packageRadio);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children:
              widget.blocPackages.asMap().entries.map((MapEntry mapEntry) {
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
                                  print(_packageRadio.price);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      children: widget.blocPackages[mapEntry.key].serviceDtos
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
                              color: Colors.black54, fontFamily: 'Quicksand'),
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
                              style: TextStyle(fontWeight: FontWeight.normal),
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
          }).toList(),
        ),
      ],
    );
  }
}
