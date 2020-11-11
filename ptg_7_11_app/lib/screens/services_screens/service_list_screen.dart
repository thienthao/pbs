import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ptg_7_11_app/blocs/package_blocs/packages.dart';
import 'package:ptg_7_11_app/models/package_bloc_model.dart';
import 'package:ptg_7_11_app/models/service_model.dart';
import 'package:ptg_7_11_app/respositories/package_repository.dart';
import 'file:///E:/Studies/flutter_study/ptg_7_11_app/lib/screens/services_screens/service_new_screen.dart';
import 'package:shimmer/shimmer.dart';

import 'service_edit_screen.dart';
import 'package:http/http.dart' as http;

class ListService extends StatefulWidget {
  @override
  _ListServiceState createState() => _ListServiceState();
}

class _ListServiceState extends State<ListService> {
  PackageRepository _packageRepository =
      PackageRepository(httpClient: http.Client());

  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");

  Completer<void> _completer;

  TextEditingController _acceptTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    _loadPackages();
  }

  Future<void> _deletePackageDialog(PackageBlocModel _packageObj) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Xóa gói dịch vụ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('Bạn có thực sự muốn xóa?',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Hủy bỏ'),
              onPressed: () {
                Navigator.pop(context);
                // selectItem('Done');
              },
            ),
            FlatButton(
              child: Text('Xác nhận'),
              onPressed: () {
                _deletePackages(_packageObj);
                Navigator.pop(context);
                // selectItem('Done');
              },
            ),
          ],
        );
      },
    );
  }

  _deletePackages(PackageBlocModel _package) async {
    context.bloc<PackageBloc>().add(PackageEventDelete(package: _package));
  }

  _loadPackages() async {
    context.bloc<PackageBloc>().add(PackageByPhotographerIdEventFetch(id: 168));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Dịch vụ của tôi",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            letterSpacing: -1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) =>
                        PackageBloc(packageRepository: _packageRepository),
                    child: NewService())),
          );
        },
        child: Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: BlocBuilder<PackageBloc, PackageState>(
          builder: (context, packageState) {
            if (packageState is PackageStateSuccess) {
              if (packageState.packages.isEmpty) {
                return Text(
                  'Đà Lạt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () {
                    _loadPackages();
                    return _completer.future;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: packageState.packages.length,
                    itemBuilder: (BuildContext context, int index) {
                      PackageBlocModel package = packageState.packages[index];
                      return Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(-1.0, 2.0),
                                    blurRadius: 6.0)
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    fontSize: 17.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: package.name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Bao gồm các dịch vụ:',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Column(
                                        children: package.serviceDtos
                                            .asMap()
                                            .entries
                                            .map((MapEntry mapEntry) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,
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
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    package
                                                            .serviceDtos[
                                                                mapEntry.key]
                                                            .name ??
                                                        '',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Tổng cộng:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            '${oCcy.format(package.price)} đồng',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 180,
                                      height: 70,
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => BlocProvider(
                                                create: (context) =>
                                                    PackageBloc(
                                                        packageRepository:
                                                            _packageRepository),
                                                child: EditService(
                                                  package: package,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Chỉnh sửa",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FlatButton(
                                        onPressed: () {
                                          _deletePackageDialog(package);
                                        },
                                        child: Text(
                                          "Xóa",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            }

            if (packageState is PackageStateDeletedSuccess) {
              _loadPackages();
            }

            if (packageState is PackageStateLoading) {
              return Shimmer.fromColors(
                period: Duration(milliseconds: 1100),
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[400],
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  width: double.infinity,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: 360.0,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 6.0)
                                  ]),
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.grey[400],
                                            Colors.grey[300],
                                          ], // whitish to gray
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(1.0),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 15.0,
                                    bottom: 15.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(1.0),
                                          ),
                                          width: 100,
                                          height: 24,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                              ),
                                              width: 35,
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            if (packageState is PackageStateFailure) {
              return Text(
                'Đã xảy ra lỗi khi tải dữ liệu',
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              );
            }
            return Text('');
          },
        ),
      ),
    );
  }
}