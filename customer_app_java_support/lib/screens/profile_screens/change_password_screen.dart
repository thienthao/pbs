import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'package:customer_app_java_support/blocs/customer_blocs/customers.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String username;
  ChangePasswordScreen({
    this.username,
  });
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordTxtController = TextEditingController();
  TextEditingController newPasswordTxtController = TextEditingController();
  TextEditingController reNewPasswordTxtController = TextEditingController();

  final oldPasswordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final reNewPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  _unFocus() {
    oldPasswordFocusNode.unfocus();
    newPasswordFocusNode.unfocus();
    reNewPasswordFocusNode.unfocus();
  }

  String _checkEmpty(String value) {
    if (value.isEmpty) {
      return 'Không thể bỏ trống trường này!';
    }
    return null;
  }

  String checkPassword(String password) {
    RegExp regExp = new RegExp(
        '^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@\$!%*#?&])[A-Za-z\\d@\$!%*#?&]{8,}\$');
    if (password.isEmpty) {
      return 'Vui lòng không để trống trường này.';
    } else if (!regExp.hasMatch(password)) {
      return 'Mật khẩu phải có tối thiểu 8 kí tự, 1 chữ cái, 1 số và 1 kí tự đặt biệt.';
    }
    return null;
  }

  String checkRePassword(String repassword) {
    if (repassword.isEmpty) {
      return 'Vui lòng không để trống trường này.';
    } else if (repassword.trim().toUpperCase() !=
        newPasswordTxtController.text.trim().toUpperCase()) {
      return 'Mật khẩu không khớp.';
    }
    return null;
  }

  _changePassword() async {
    _unFocus();
    BlocProvider.of<CustomerBloc>(context).add(CustomerEventChangePassword(
        username: widget.username,
        oldPassword: oldPasswordTxtController.text,
        newPassword: newPasswordTxtController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.blue,
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _changePassword();
              }
            },
          ),
        ],
        title: Text('Đổi mật khẩu'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                  child: BlocListener<CustomerBloc, CustomerState>(
                listener: (context, state) {
                  if (state is CustomerStateChangedPasswordSuccess) {
                    Navigator.pop(context);
                    _showSuccessAlert();
                  }
                  if (state is CustomerStateLoading) {
                    _showLoadingAlert();
                  }

                  if (state is CustomerStateChangePasswordFailure) {
                    print(state.error);
                    Navigator.pop(context);
                    String message = '';
                    String oldPassword = '';
                    String newPassword = '';
                    var error = [];
                    error = state.error
                        .toString()
                        .replaceAll("Exception: ", "")
                        .replaceAll("{", "")
                        .replaceAll("}", "")
                        .split(',');

                    message =
                        '${error[2].toString().replaceAll("message:", "").trim()}';
                    oldPassword =
                        '${error[1].toString().replaceAll("oldPassword:", "").trim()}';
                    newPassword =
                        '${error[0].toString().replaceAll("newPassword:", "").trim()}';
                    print(message.trim().length);

                    if (oldPassword.trim().toUpperCase() ==
                        'Old Password does not match.'.toUpperCase()) {
                      oldPassword = 'Mật khẩu cũ của bạn không chính xác';
                    }
                    _showFailDialog(
                        'Thất bại', message + oldPassword + newPassword);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Mật khẩu cũ của bạn: *',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        TextFormField(
                          validator: _checkEmpty,
                          focusNode: oldPasswordFocusNode,
                          controller: oldPasswordTxtController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.lock_open_rounded),
                            contentPadding: EdgeInsets.all(8.0),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Mật khẩu mới: *',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        TextFormField(
                          validator: checkPassword,
                          focusNode: newPasswordFocusNode,
                          controller: newPasswordTxtController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.lock_outline_rounded),
                            contentPadding: EdgeInsets.all(8.0),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Nhập lại mật khẩu mới: *',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        TextFormField(
                          validator: checkRePassword,
                          focusNode: reNewPasswordFocusNode,
                          controller: reNewPasswordTxtController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.lock_outline_rounded),
                            contentPadding: EdgeInsets.all(8.0),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  // void onPressedButton() {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setStateA) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height * 0.7,
  //           color: Color(0xFF737373),
  //           child: Container(
  //             child: BottomSheetLocation(
  //               inputList: locations,
  //               onSelecteListLocation: (List<LocationBlocModel> selectedList) {
  //                 locations = selectedList;
  //                 setState(() {});
  //               },
  //             ),
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).canvasColor,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(25.0),
  //                 topRight: Radius.circular(25.0),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

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
                'Đổi mật khẩu thành công!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
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

  Future<void> _showFailDialog(String title, String content) async {
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
                title,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                content,
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
}
