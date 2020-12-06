import 'package:customer_app_java_support/blocs/customer_blocs/customers.dart';
import 'package:customer_app_java_support/models/customer_bloc_model.dart';
import 'package:customer_app_java_support/shared/pop_up.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Detail extends StatefulWidget {
  final CustomerBlocModel customer;

  const Detail({this.customer});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _checkEmpty(String value) {
    if (value.isEmpty) {
      return 'Không thể bỏ trống trường này!';
    }
    return null;
  }

  _updateProfile() async {
    CustomerBlocModel customerBlocModel = CustomerBlocModel(
      id: widget.customer.id,
      fullname: fullnameController.text,
      email: emailController.text,
      phone: phoneController.text,
    );

    BlocProvider.of<CustomerBloc>(context)
        .add(CustomerEventUpdateProfile(customer: customerBlocModel));
  }

  // void popNotice() {
  //   StatusAlert.show(
  //     context,
  //     duration: Duration(seconds: 60),
  //     title: 'Đang gửi yêu cầu',
  //     configuration: IconConfiguration(
  //       icon: Icons.send_to_mobile,
  //     ),
  //   );
  // }
  //
  // void removeNotice() {
  //   StatusAlert.hide();
  // }

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

  @override
  void initState() {
    fullnameController.text = widget.customer.fullname;
    emailController.text = widget.customer.email;
    phoneController.text = widget.customer.phone;
    super.initState();
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
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
                  _updateProfile();
                }
              },
            ),
          ],
          title: Text('Chỉnh sửa trang cá nhân'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerStateUpdatedProfileSuccess) {
              removeNotice(context);
              popUp(
                  'Cập nhật thông tin', 'Thông tin của bạn đã được cập nhật!!');
            }
            if (state is CustomerStateLoading) {
              popNotice(context);
            }
            if (state is CustomerStateFailure) {
              removeNotice(context);
              popUp('Cập nhật thông tin',
                  'Đã có lỗi xảy ra trong lúc cập nhật. Bạn vui lòng thử lại sau!');
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Họ tên: *',
                            style: TextStyle(
                                color: Colors.black87, fontSize: 12.0),
                          ),
                          TextFormField(
                            controller: fullnameController,
                            validator: _checkEmpty,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.account_circle),
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Ví dụ: Nguyễn Văn A',
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
                            'Email: *',
                            style: TextStyle(
                                color: Colors.black87, fontSize: 12.0),
                          ),
                          TextFormField(
                            controller: emailController,
                            validator: _checkEmpty,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.mail),
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Ví dụ: abc@xzy.com',
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
                            'Số điện thoại: *',
                            style: TextStyle(
                                color: Colors.black87, fontSize: 12.0),
                          ),
                          TextFormField(
                            controller: phoneController,
                            validator: _checkEmpty,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.phone),
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Ví dụ: 012345678',
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
