import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_state.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void recoverPassword() {
    String username = this.username.text;
    String email = this.email.text;
    BlocProvider.of<PhotographerBloc>(context).add(
        PhotographerEventRecoveryPassword(username: username, email: email));
  }

  String checkEmail(String email) {
    RegExp regExp = new RegExp(
        '^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})\$');
    if (email.isEmpty) {
      return 'Vui lòng nhập email của bạn';
    } else if (!regExp.hasMatch(email)) {
      return 'Email phải theo định dạng, ví dụ: pbs@fpt.edu.vn';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhotographerBloc, PhotographerState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.FLOATING,
              backgroundColor: Colors.red[200],
              reverseAnimationCurve: Curves.decelerate,
              forwardAnimationCurve: Curves.elasticOut,
              isDismissible: false,
              duration: Duration(seconds: 2),
              titleText: Text(
                "Gửi yêu cầu thất bại!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily: "Quicksand"),
              ),
              messageText: Text(
                "Gửi yêu cầu không thành công!",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: "Quicksand"),
              ),
            ).show(context);
          }

          if (state is RegisterSuccess) {
            Navigator.popUntil(context, (route) => route.isFirst);
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              flushbarStyle: FlushbarStyle.FLOATING,
              backgroundColor: Colors.red[200],
              reverseAnimationCurve: Curves.decelerate,
              forwardAnimationCurve: Curves.elasticOut,
              isDismissible: false,
              duration: Duration(seconds: 2),
              titleText: Text(
                "Gửi yêu cầu thành công",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily: "Quicksand"),
              ),
              messageText: Text(
                "Gửi yêu cầu thành công",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: "Quicksand"),
              ),
            ).show(context);
          }
        },
        child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF894A4),
                          Color(0xFFF9D1B7),
                        ],
                        stops: [0.1, 0.9],
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 70.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Quên mật khẩu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[400],
                                            offset: Offset(0.0, 2.0),
                                            blurRadius: 6.0)
                                      ]),
                                  child: TextFormField(
                                    validator: checkEmail,
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      hintText: 'Ví dụ: abc@xzy.com',
                                      hintStyle: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 35.0),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25.0),
                              width: double.infinity,
                              child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    recoverPassword();
                                  }
                                },
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.white,
                                child: Text(
                                  'Khôi phục lại mật khẩu',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: 1.5,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
