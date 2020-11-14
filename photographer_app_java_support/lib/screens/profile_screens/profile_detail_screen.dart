import 'package:flutter/scheduler.dart';
import 'package:photographer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:photographer_app_java_support/models/location.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
import 'package:photographer_app_java_support/widgets/profile_screen/bottom_sheet_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:status_alert/status_alert.dart';

class Detail extends StatefulWidget {
  final Photographer photographer;

  const Detail({this.photographer});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<Location> selectedLocation;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedLocation = [];
    fullnameController.text = widget.photographer.fullname;
    emailController.text = widget.photographer.email;
    phoneController.text = widget.photographer.phone;
    descriptionController.text = widget.photographer.description;
  }

  _updateProfile() async {
    Photographer _photographer = Photographer(
        fullname: fullnameController.text,
        email: emailController.text,
        phone: phoneController.text,
        description: descriptionController.text);

    print(_photographer.fullname);
    context
        .bloc<PhotographerBloc>()
        .add(PhotographerEventUpdateProfile(photographer: _photographer));
  }

  Future<void> _loadingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Đang cập nhật',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void successNotice(String name) async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: name,
        titleOptions:
            StatusAlertTextConfiguration(style: TextStyle(fontSize: 18)),
        configuration: IconConfiguration(
          icon: Icons.done,
        ),
      );
    });
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
              _updateProfile();
            },
          ),
        ],
        title: Text('Chỉnh sửa trang cá nhân'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: BlocBuilder<PhotographerBloc, PhotographerState>(
              builder: (context, state) {
                if (state is PhotograherStateUpdatedProfileSuccess) {
                  successNotice("Cập nhật thành công!");
                }

                if (state is PhotographerStateLoading) {}
                return Column(
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
                        TextField(
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
                        TextField(
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
                        TextField(
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
                      children: [
                        Text(
                          'Địa điểm làm việc: *',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        SizedBox(height: 5.0),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => onPressedButton(),
                              ),
                              locationChips(),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Mô tả: *',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 12.0),
                            ),
                            TextField(
                              controller: descriptionController,
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
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  locationChips() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List<Widget>.generate(locations.length, (int index) {
        Location location = locations[index];
        return Chip(
          label: Text(location.city),
          onDeleted: () {
            setState(() {
              locations.removeAt(index);
            });
          },
        );
      }),
    );
  }

  void onPressedButton() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          color: Color(0xFF737373),
          child: Container(
            child: BottomSheetLocation(),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
