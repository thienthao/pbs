import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:photographer_app_java_support/blocs/register_blocs/register_bloc.dart';
import 'package:photographer_app_java_support/respositories/photographer_respository.dart';
import 'package:photographer_app_java_support/screens/forget_password_screen.dart';
import 'package:photographer_app_java_support/screens/sign_up_screen.dart';
import 'package:photographer_app_java_support/widgets/shared/slide_navigator.dart';
import 'package:http/http.dart' as http;
import '../blocs/authen_blocs/authen_export.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  LoginScreen({@required this.userRepository});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool remember = false;
  final _formKey = GlobalKey<FormState>();

  String _checkEmpty(String value) {
    if (value.isEmpty) {
      return 'Thông tin này là bắt buộc.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      if (_formKey.currentState.validate()) {
        BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ));
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
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
              "${state.error.replaceAll("Exception: ", "")}",
              style: TextStyle(
                  fontSize: 16.0, color: Colors.white, fontFamily: "Quicksand"),
            ),
          ).show(context);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
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
                            Color(0xFFF9D1B7),
                            Color(0xFFF894A4),
                          ],
                          stops: [0.1, 0.8],
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
                                'Đăng nhập',
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
                                    'Tên đăng nhập',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 6.0)
                                        ]),
                                    child: TextFormField(
                                      validator: _checkEmpty,
                                      controller: _usernameController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                        color: Color(0xFFF67062),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14.0),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Color(0xFFF67062),
                                        ),
                                        hintText: 'Tên đăng nhập của bạn',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFF67062),
                                        ),
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
                                    'Mật khẩu',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 6.0)
                                        ]),
                                    child: TextFormField(
                                      validator: _checkEmpty,
                                      controller: _passwordController,
                                      obscureText: true,
                                      style: TextStyle(
                                        color: Color(0xFFF67062),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14.0),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Color(0xFFF67062),
                                        ),
                                        hintText: 'Mật khẩu của bạn',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFF67062),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: FlatButton(
                                  onPressed: () {},
                                  padding: EdgeInsets.only(right: 0.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      slideNavigator(
                                          context,
                                          MultiBlocProvider(
                                            providers: [
                                              BlocProvider(
                                                  create: (context) =>
                                                      PhotographerBloc(
                                                          photographerRepository:
                                                              _photographerRepository))
                                            ],
                                            child: ForgetPasswordScreen(),
                                          ));
                                    },
                                    child: Text(
                                      'Quên mật khẩu?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   height: 20.0,
                              //   child: Row(
                              //     children: <Widget>[
                              //       Theme(
                              //         data: ThemeData(
                              //             unselectedWidgetColor: Colors.white),
                              //         child: Checkbox(
                              //           value: remember,
                              //           checkColor: Colors.green,
                              //           activeColor: Colors.white,
                              //           onChanged: (value) {
                              //             setState(() {
                              //               remember = value;
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //       Text(
                              //         'Nhớ mật khẩu',
                              //         style: TextStyle(
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.w600,
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 25.0),
                                width: double.infinity,
                                child: RaisedButton(
                                  elevation: 5.0,
                                  onPressed: _onLoginButtonPressed,
                                  // onPressed: () {
                                  //   Navigator.pop(context);
                                  //   Navigator.push(
                                  //       context,
                                  //       PageRouteBuilder(
                                  //           transitionDuration:
                                  //               Duration(milliseconds: 1000),
                                  //           transitionsBuilder: (BuildContext
                                  //                   context,
                                  //               Animation<double> animation,
                                  //               Animation<double> secAnimation,
                                  //               Widget child) {
                                  //             animation = CurvedAnimation(
                                  //                 parent: animation,
                                  //                 curve: Curves
                                  //                     .fastLinearToSlowEaseIn);
                                  //             return FadeTransition(
                                  //               opacity: animation,
                                  //               child: child,
                                  //             );
                                  //           },
                                  //           pageBuilder: (BuildContext context,
                                  //               Animation<double> animation,
                                  //               Animation<double> secAnimation) {
                                  //             return NavScreen();
                                  //           }));
                                  // },
                                  padding: EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.white,
                                  child: Text(
                                    'ĐĂNG NHẬP',
                                    style: TextStyle(
                                      color: Color(0xFFF67062),
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
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.w400,
                              //       ),
                              //     ),
                              //     SizedBox(height: 20.0),
                              //     Text(
                              //       'Đăng nhập với',
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 30.0),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceEvenly,
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => RegisterBloc(
                                              userRepository:
                                                  widget.userRepository),
                                          child: SignUpScreen(),
                                        ),
                                      ));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Không có tài khoản? ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Đăng kí',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
