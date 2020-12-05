import 'package:flutter/scheduler.dart';
import 'package:photographer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:photographer_app_java_support/models/location_bloc_model.dart';
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
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<LocationBlocModel> locations = List<LocationBlocModel>();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PhotographerBloc>(context)
        .add(PhotographerEventGetLocations(ptgId: 168));
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
            child: Container(
                child: BlocListener<PhotographerBloc, PhotographerState>(
              listener: (context, state) {
                if(state is PhotographerStateUpdatedProfileSuccess) {
                  
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
                        style: TextStyle(color: Colors.black87, fontSize: 12.0),
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
                        style: TextStyle(color: Colors.black87, fontSize: 12.0),
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
                        style: TextStyle(color: Colors.black87, fontSize: 12.0),
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
                        style: TextStyle(color: Colors.black87, fontSize: 12.0),
                      ),
                      SizedBox(height: 5.0),
                      BlocListener<PhotographerBloc, PhotographerState>(
                        listener: (context, state) {
                          if (state is PhotographerStateGetLocationsSuccess) {
                            print(state.locations);
                            locations = state.locations;
                            setState(() {});
                          }
                        },
                        child: SingleChildScrollView(
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
              ),
            )),
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

  void onPressedButton() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateA) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            color: Color(0xFF737373),
            child: Container(
              child: BottomSheetLocation(
                inputList: locations,
                onSelecteListLocation: (List<LocationBlocModel> selectedList) {
                  locations = selectedList;
                  setState(() {});
                },
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
