import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_bloc.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_event.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_state.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/user_register_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool remember = false;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repassword = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void signup() {
    String username = this.username.text;
    String email = this.email.text;
    String password = this.password.text;
    String fullname = this.fullname.text;
    String phone = this.phone.text;
    // String repassword = this.repassword.text;
    UserRegister userRegister = UserRegister(
        username: username,
        email: email,
        password: password,
        fullname: fullname,
        phone: phone);
    BlocProvider.of<RegisterBloc>(context)
        .add(SignUp(userRegister: userRegister));
  }

  String checkUsername(String username) {
    if (username.isEmpty) {
      return 'Thông tin này là bắt buộc.';
    } else if (!(username.length >= 8 && username.length <= 20)) {
      return 'Tên đăng nhập phải từ 8 - 20 kí tự.';
    }
    return null;
  }

  String checkEmail(String email) {
    RegExp regExp = new RegExp(
        '^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})\$');
    if (email.isEmpty) {
      return 'Thông tin này là bắt buộc.';
    } else if (!regExp.hasMatch(email)) {
      return 'Email phải theo định dạng, ví dụ: pbs@fpt.edu.vn';
    }
    return null;
  }

  String checkPassword(String password) {
    RegExp regExp = new RegExp(
        '^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@\$!%*#?&])[A-Za-z\\d@\$!%*#?&]{8,}\$');
    if (password.isEmpty) {
      return 'Thông tin này là bắt buộc.';
    } else if (!regExp.hasMatch(password)) {
      return 'Thiểu 8 kí tự, 1 chữ cái, 1 số và 1 kí tự đặt biệt.';
    }
    return null;
  }

  String checkRePassword(String repassword) {
    if (repassword.isEmpty) {
      return 'Thông tin này là bắt buộc.';
    } else if (repassword.trim().toUpperCase() !=
        password.text.trim().toUpperCase()) {
      return 'Mật khẩu không khớp.';
    }
    return null;
  }

  String checkPhone(String phone) {
    RegExp regExp = new RegExp('(84|0[3|5|7|8|9])+([0-9]{8,9})',
        caseSensitive: false, multiLine: false);
    if (phone.isEmpty) {
      return 'Thông tin này là bắt buộc.';
    } else if (!regExp.hasMatch(phone)) {
      return 'Số điện thoại phải theo định dạng của Việt Nam.';
    } else if (phone.length > 11) {
      return 'Số điện thoại phải theo định dạng của Việt Nam.';
    }
    return null;
  }

  String checkName(String fullname) {
    RegExp regExp =
        new RegExp('[^A-Za-zàáãạảăắằẳẵặâấầẩẫậèéẹẻẽêềếểễệđìíĩỉịòóõọỏôốồổỗộơớờởỡợùúũụủưứừửữựỳỵỷỹýÀÁÃẠẢĂẮẰẲẴẶÂẤẦẨẪẬÈÉẸẺẼÊỀẾỂỄỆĐÌÍĨỈỊÒÓÕỌỎÔỐỒỔỖỘƠỚỜỞỠỢÙÚŨỤỦƯỨỪỬỮỰỲỴỶỸÝ ]+', caseSensitive: false, multiLine: false);
    if (fullname.isEmpty) {
      return 'Thông tin này là bắt buộc.';
    } else if (regExp.hasMatch(fullname)) {
      return 'Chỉ có thể sử dụng chữ cái cho tên.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
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
              "Đăng ký thất bại!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                  fontFamily: "Quicksand"),
            ),
            messageText: Text(
              "Đăng ký không thành công!",
              style: TextStyle(
                  fontSize: 16.0, color: Colors.white, fontFamily: "Quicksand"),
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
              "Đăng ký thành công",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                  fontFamily: "Quicksand"),
            ),
            messageText: Text(
              "Đăng ký thành công",
              style: TextStyle(
                  fontSize: 16.0, color: Colors.white, fontFamily: "Quicksand"),
            ),
          ).show(context);
        }
      },
      child:
          BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
        return Scaffold(
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
                              'Đăng kí',
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
                                  'Tên tài khoản',
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
                                    validator: checkUsername,
                                    controller: username,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      hintText: 'Từ 8 - 20 kí tự',
                                      hintStyle: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Họ & Tên',
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
                                    validator: checkName,
                                    controller: fullname,
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.perm_contact_cal_sharp,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      hintText: 'Ví dụ: Nguyễn Văn A',
                                      hintStyle: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
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
                            SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Số điện thoại',
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
                                    validator: checkPhone,
                                    autocorrect: true,
                                    controller: phone,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.call,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      hintText: 'Ví dụ: 01234567890',
                                      hintStyle: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Mật khẩu',
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
                                    validator: checkPassword,
                                    controller: password,
                                    obscureText: true,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      hintText: 'Từ 8 kí tự trở lên',
                                      hintStyle: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Nhập lại mật khẩu',
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
                                    validator: checkRePassword,
                                    controller: repassword,
                                    obscureText: true,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      hintText: 'Nhập lại mật khẩu của bạn',
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
                                    signup();
                                  }
                                },
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.white,
                                child: Text(
                                  'ĐĂNG KÍ',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: 1.5,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // Column(
                            //   children: <Widget>[
                            //     Text(
                            //       '- HOẶC -',
                            //       style: TextStyle(
                            //         color: Colors.black87,
                            //         fontWeight: FontWeight.w400,
                            //       ),
                            //     ),
                            //     SizedBox(height: 20.0),
                            //     Text(
                            //       'Đăng kí với',
                            //       style: TextStyle(
                            //         color: Colors.black87,
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(vertical: 30.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       GestureDetector(
                            //         onTap: () {},
                            //         child: Container(
                            //           height: 60.0,
                            //           width: 60.0,
                            //           decoration: BoxDecoration(
                            //             shape: BoxShape.circle,
                            //             color: Colors.white,
                            //             boxShadow: [
                            //               BoxShadow(
                            //                 color: Colors.black26,
                            //                 offset: Offset(0, 2),
                            //                 blurRadius: 6.0,
                            //               ),
                            //             ],
                            //             image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/images/facebook.jpg'),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       GestureDetector(
                            //         onTap: () {},
                            //         child: Container(
                            //           height: 60.0,
                            //           width: 60.0,
                            //           decoration: BoxDecoration(
                            //             shape: BoxShape.circle,
                            //             color: Colors.white,
                            //             boxShadow: [
                            //               BoxShadow(
                            //                 color: Colors.black26,
                            //                 offset: Offset(0, 2),
                            //                 blurRadius: 6.0,
                            //               ),
                            //             ],
                            //             image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/images/google.jpg'),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
