import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:photographer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/location_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
import 'package:photographer_app_java_support/widgets/profile_screen/mini_locations_list_edit.dart';

class Detail extends StatefulWidget {
  final Photographer photographer;

  const Detail({this.photographer});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final fullNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  List<LocationBlocModel> locations = List<LocationBlocModel>();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PhotographerBloc>(context)
        .add(PhotographerEventGetLocations(ptgId: widget.photographer.id));
    fullnameController.text = widget.photographer.fullname;
    emailController.text = widget.photographer.email;
    phoneController.text = widget.photographer.phone;
    descriptionController.text = widget.photographer.description;
  }

  _unFocus() {
    fullNameFocusNode.unfocus();
    emailFocusNode.unfocus();
    phoneFocusNode.unfocus();
    descriptionFocusNode.unfocus();
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

  String _checkEmpty(String value) {
    if (value.isEmpty) {
      return 'Không thể bỏ trống trường này!';
    }
    return null;
  }

  _updateProfile() async {
    _unFocus();
    Photographer _photographer = Photographer(
        id: widget.photographer.id,
        fullname: fullnameController.text,
        email: emailController.text,
        phone: phoneController.text,
        description: descriptionController.text);

    print(_photographer.fullname);
    BlocProvider.of<PhotographerBloc>(context).add(
        PhotographerEventUpdateProfile(
            photographer: _photographer, locations: locations));
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
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                  child: BlocListener<PhotographerBloc, PhotographerState>(
                listener: (context, state) {
                  if (state is PhotographerStateUpdatedProfileSuccess) {
                    Navigator.pop(context);
                    _showSuccessAlert();
                    BlocProvider.of<PhotographerBloc>(context)
                        .add(PhotographerEventGetLocations(ptgId: globalPtgId));
                  }
                  if (state is PhotographerStateLoading) {
                    _showLoadingAlert();
                  }

                  if (state is PhotographerStateFailure) {
                    Navigator.pop(context);
                    _showFailDialog();
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
                          'Họ tên: *',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        TextFormField(
                          validator: _checkEmpty,
                          focusNode: fullNameFocusNode,
                          controller: fullnameController,
                          keyboardType: TextInputType.name,
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
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        TextFormField(
                          validator: _checkEmpty,
                          focusNode: emailFocusNode,
                          controller: emailController,
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
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        TextFormField(
                          validator: checkPhone,
                          focusNode: phoneFocusNode,
                          controller: phoneController,
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
                    SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Mô tả: *',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        TextFormField(
                          validator: _checkEmpty,
                          controller: descriptionController,
                          focusNode: descriptionFocusNode,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.subject),
                            contentPadding: EdgeInsets.all(8.0),
                            hintText: 'Ví dụ: Tôi là....',
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
                      children: [
                        Text(
                          'Địa điểm làm việc: *',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        SizedBox(height: 5.0),
                        BlocBuilder<PhotographerBloc, PhotographerState>(
                          builder: (context, state) {
                            if (state is PhotographerStateGetLocationsSuccess) {
                              locations = state.locations;
                              return MiniLocationsListEdit(
                                listLocations: locations,
                                onChangeParam: (List<LocationBlocModel> _list) {
                                  locations = _list;
                                },
                              );
                            }
                            return SizedBox();
                          },
                        ),
                        SizedBox(height: 30.0),
                      ],
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  locationChips() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List<Widget>.generate(locations.length, (int index) {
        LocationBlocModel location = locations[index];
        return Chip(
          label: Text(location.formattedAddress),
          onDeleted: () {
            setState(() {
              locations.removeAt(index);
            });
          },
        );
      }),
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
                'Đã cập nhật thành công!',
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
