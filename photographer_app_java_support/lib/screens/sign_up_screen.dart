import 'package:photographer_app_java_support/blocs/register_blocs/register_bloc.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_event.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_state.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/user_register_model.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void signup() {
    String username = this.username.text;
    String email = this.email.text;
    String password = this.password.text;
    String repassword = this.repassword.text;
    UserRegister userRegister =
        UserRegister(username: username, email: email, password: password);
    BlocProvider.of<RegisterBloc>(context)
        .add(SignUp(userRegister: userRegister));
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
              "Đăng nhập thất bại",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                  fontFamily: "Quicksand"),
            ),
            messageText: Text(
              "dang nhap that bai",
              style: TextStyle(
                  fontSize: 16.0, color: Colors.white, fontFamily: "Quicksand"),
            ),
          ).show(context);
        }

        if (state is RegisterSuccess) {
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
              "Đăng ký thanh cong",
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
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 70.0),
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
                                child: TextField(
                                  controller: username,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14.0),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    hintText: 'Nhập tên tài khoản',
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
                                child: TextField(
                                  controller: email,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14.0),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    hintText: 'Nhập email',
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
                                child: TextField(
                                  controller: password,
                                  obscureText: true,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14.0),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    hintText: 'Nhập mật khẩu của bạn',
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
                                child: TextField(
                                  controller: repassword,
                                  obscureText: true,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14.0),
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
                                signup();
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
                          Column(
                            children: <Widget>[
                              Text(
                                '- HOẶC -',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                'Đăng kí với',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 60.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/facebook.jpg'),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 60.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/google.jpg'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
