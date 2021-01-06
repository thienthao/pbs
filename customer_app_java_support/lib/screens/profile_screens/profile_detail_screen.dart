import 'package:customer_app_java_support/blocs/customer_blocs/customers.dart';
import 'package:customer_app_java_support/models/customer_bloc_model.dart';
import 'package:customer_app_java_support/shared/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

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
  final fullNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  String _checkEmpty(String value) {
    if (value.isEmpty) {
      return 'Không thể bỏ trống trường này!';
    }
    return null;
  }

  _unFocus() {
    fullNameFocusNode.unfocus();
    emailFocusNode.unfocus();
    phoneFocusNode.unfocus();
  }

  String checkPhone(String phone) {
    RegExp regExp = new RegExp('(84|0[3|5|7|8|9])+([0-9]{8,9})',
        caseSensitive: false, multiLine: false);
    if (phone.isEmpty) {
      return 'Vui lòng nhập số điện thoại của bạn';
    } else if (!regExp.hasMatch(phone)) {
      return 'Số điện thoại phải theo định dạng của Việt Nam';
    }
    return null;
  }

  _updateProfile() async {
    _unFocus();
    CustomerBlocModel customerBlocModel = CustomerBlocModel(
      id: widget.customer.id,
      fullname: fullnameController.text,
      email: emailController.text,
      phone: phoneController.text,
    );

    BlocProvider.of<CustomerBloc>(context)
        .add(CustomerEventUpdateProfile(customer: customerBlocModel));
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
              Navigator.pop(context);
              _showSuccessAlert();
              popUp(context, 'Cập nhật thông tin',
                  'Thông tin của bạn đã được cập nhật!!');
            }
            if (state is CustomerStateLoading) {
              _showLoadingAlert();
            }
            if (state is CustomerStateFailure) {
              Navigator.pop(context);
              popUp(context, 'Cập nhật thông tin',
                  'Đã có lỗi xảy ra trong lúc cập nhật. Bạn vui lòng thử lại sau!');
              _showFailDialog();
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
                            focusNode: fullNameFocusNode,
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
                            focusNode: emailFocusNode,
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
                            focusNode: phoneFocusNode,
                            controller: phoneController,
                            validator: checkPhone,
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
                'Cập nhật thông tin thành công!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
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
}
