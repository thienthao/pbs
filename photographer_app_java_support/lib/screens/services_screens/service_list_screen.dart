import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/authen_export.dart';
import 'package:photographer_app_java_support/blocs/category_blocs/category_bloc.dart';
import 'package:photographer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/category_respository.dart';
import 'package:photographer_app_java_support/respositories/package_repository.dart';
import 'package:photographer_app_java_support/screens/services_screens/service_new_screen.dart';
import 'package:photographer_app_java_support/widgets/shared/package_list_screen_loading.dart';
import 'package:photographer_app_java_support/widgets/shared/pop_up.dart';

import 'service_edit_screen.dart';

class ListService extends StatefulWidget {
  @override
  _ListServiceState createState() => _ListServiceState();
}

class _ListServiceState extends State<ListService> {
  PackageRepository _packageRepository =
      PackageRepository(httpClient: http.Client());
  CategoryRepository _categoryRepository =
      CategoryRepository(httpClient: http.Client());

  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");

  Completer<void> _completer;

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
    BlocProvider.of<PackageBloc>(context)
        .add(PackageEventDelete(package: _package));
  }

  _loadPackages() async {
    BlocProvider.of<PackageBloc>(context)
        .add(PackageByPhotographerIdEventFetch(id: globalPtgId));
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
                builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => PackageBloc(
                              packageRepository: _packageRepository),
                        ),
                        BlocProvider(
                          create: (context) => CategoryBloc(
                              categoryRepository: _categoryRepository),
                        ),
                      ],
                      child: NewService(
                        isAdded: (bool isAdded) {
                          if (isAdded) {
                            _loadPackages();
                          }
                        },
                      ),
                    )),
          );
        },
        child: Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<PackageBloc, PackageState>(
        listener: (context, packageState) {
          if (packageState is PackageStateDeletedSuccess) {
            Navigator.pop(context);
            _showSuccessAlert();
            popUp(context, 'Xoá gói dịch vụ', 'Xóa gói dịch vụ thành công!!!!');
            _loadPackages();
          }
          if (packageState is PackageStateDeletedInProgress) {
            _showLoadingAlert();
          }
          if (packageState is PackageStateDeletedFailure) {
            Navigator.pop(context);
            _showFailDialog();
            popUp(
                context,
                '${packageState.error.replaceAll('Exception: ', '')}',
                'Gói dịch vụ hiện đang được sử dụng. Bạn không thể xóa!!!!');
            _loadPackages();
          }
          if (packageState is PackageStateFailure) {
            String error = packageState.error.replaceAll('Exception: ', '');

            if (error.toUpperCase() == 'UNAUTHORIZED') {
              _showUnauthorizedDialog();
            }
          }
        },
        builder: (context, packageState) {
          if (packageState is PackageStateSuccess) {
            if (packageState.packages.isEmpty) {
              return Text(
                'Hiện tại bạn chưa có gói dịch vụ nào',
                style: TextStyle(
                  color: Colors.black,
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
                                                  fontSize: 17.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
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
                                          package.price == null
                                              ? '... đồng'
                                              : '${oCcy.format(package.price)} đồng',
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
                                              builder: (_) => MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                            PackageBloc(
                                                                packageRepository:
                                                                    _packageRepository),
                                                      ),
                                                      BlocProvider(
                                                        create: (context) =>
                                                            CategoryBloc(
                                                                categoryRepository:
                                                                    _categoryRepository),
                                                      ),
                                                    ],
                                                    child: EditService(
                                                      isUpdated:
                                                          (bool isUpdated) {
                                                        if (isUpdated) {
                                                          _loadPackages();
                                                        }
                                                      },
                                                      package: package,
                                                    ),
                                                  )),
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

          if (packageState is PackageStateLoading) {
            return PackageListScreenLoadingWidget();
          }

          if (packageState is PackageStateFailure) {
            return Center(
              child: InkWell(
                onTap: () {
                  _loadPackages();
                },
                child: Text(
                  'Đã xảy ra lỗi trong lúc tải dữ liệu \n Ấn để thử lại',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[300], fontSize: 16),
                ),
              ),
            );
          }
          return Text('');
        },
      ),
    );
  }

  Future<void> _showSuccessAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/done_booking.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Hoàn thành',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Xóa dịch vụ thành công!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                });
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }

  Future<void> _showLoadingAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) {
          return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Material(
                type: MaterialType.card,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
                child: Image.asset(
                  'assets/images/loading_2.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

  Future<void> _showFailDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/fail.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Thất bại',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Đã có lỗi xảy ra trong lúc gửi yêu cầu.',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }

  Future<void> _showUnauthorizedDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/fail.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Thông báo',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Tài khoản không có quyền truy cập nội dung này!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
