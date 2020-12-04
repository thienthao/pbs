import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/blocs/customer_blocs/customers.dart';
import 'package:customer_app_java_support/respositories/customer_repository.dart';
import 'package:customer_app_java_support/screens/profile_screens/profile_detail_screen.dart';
import 'package:customer_app_java_support/widgets/profile_screen/profile_body_info.dart';
import 'package:customer_app_java_support/widgets/profile_screen/profile_body_info_loading.dart';
import 'package:customer_app_java_support/widgets/profile_screen/profile_body_menu_item.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  CustomerRepository _customerRepository =
      CustomerRepository(httpClient: http.Client());
  String avatar = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void popUp(String title, String content) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.black87,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      isDismissible: false,
      duration: Duration(seconds: 5),
      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
            fontFamily: "Quicksand"),
      ),
      messageText: Text(
        content,
        style: TextStyle(
            fontSize: 16.0, color: Colors.white, fontFamily: "Quicksand"),
      ),
    ).show(context);
  }

  _loadProfile() async {
    BlocProvider.of<CustomerBloc>(context)
        .add(CustomerEventProfileFetch(cusId: 2));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerStateFetchedProfileSuccess) {
          return Column(
            children: [
              BlocListener<CustomerBloc, CustomerState>(
                listener: (context, state) {
                  if (state is CustomerStateUpdatedAvatarSuccess) {
                    popUp('Cập nhật ảnh đại diện',
                        'Ảnh đại diện của bạn đã được cập nhật thành công!!');
                  }
                  _loadProfile();
                },
                child: Info(
                  customer: state.customer,
                ),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    ProfileMenuItem(
                      iconSrc: "assets/icons/avatar.svg",
                      title: "Thông tin của tôi",
                      press: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration:
                                    Duration(milliseconds: 1000),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.fastLinearToSlowEaseIn);
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) {
                                  return BlocProvider(
                                    create: (context) => CustomerBloc(
                                        customerRepository:
                                            _customerRepository),
                                    child: Detail(
                                      customer: state.customer,
                                    ),
                                  );
                                }));
                      },
                    ),
                    ProfileMenuItem(
                      iconSrc: "assets/icons/logout.svg",
                      title: "Đăng xuất",
                      press: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut());
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        if (state is CustomerStateLoading) {
          return InfoLoading();
        }
        if (state is CustomerStateFailure) {
          return Center(
            child: InkWell(
              onTap: () {
                _loadProfile();
              },
              child: Text(
                'Đã xảy ra lỗi trong lúc tải dữ liệu \n Ấn để thử lại',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
