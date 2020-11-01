import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:photographer_app_1_11/blocs/package_blocs/packages.dart';
import 'package:photographer_app_1_11/models/package_bloc_model.dart';
import 'package:photographer_app_1_11/models/service_bloc_model.dart';
import 'package:photographer_app_1_11/models/service_model.dart';
import 'package:photographer_app_1_11/widgets/service/mini_service_header.dart';
import 'package:photographer_app_1_11/widgets/service/mini_service_list_edit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditService extends StatefulWidget {
  final PackageBlocModel package;

  EditService({this.package});

  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  intl.NumberFormat oCcy = intl.NumberFormat("#,##0", "vi_VN");
  var nameTextController = TextEditingController();
  var priceTextController = TextEditingController();
  var txt3 = TextEditingController();
  var descriptionTextController = TextEditingController();

  static String app = "Giao hàng qua ứng dụng";
  static String meet = "Gặp mặt khách hàng";

  Map<String, bool> delivery = {
    app: true,
    meet: false,
  };

  List<ServiceBlocModel> servicesOfPackageResult = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextController.text = widget.package.name;
    priceTextController.text = '${oCcy.format(widget.package.price)}' + ' đ';
    txt3.text = '6 giờ';
    descriptionTextController.text = widget.package.description;
  }

  _updatePackage() async {
    List<ServiceBlocModel> tempServices;
    tempServices = servicesOfPackageResult.map((service) {
      return ServiceBlocModel(id: service.id, name: service.name);
    }).toList();
    print('services: ${tempServices.length}');
    PackageBlocModel packageTemp = PackageBlocModel(
      id: widget.package.id,
      name: nameTextController.text,
      description: descriptionTextController.text,
      price: int.parse(
          priceTextController.text.replaceAll(new RegExp(r'[^\w\s]+'), '')),
      serviceDtos: tempServices,
    );
    // print(
    //     'This is going to update ${packageTemp.name} ${packageTemp.description} ${packageTemp.price} ${packageTemp.serviceDtos[0].id}');
    context.bloc<PackageBloc>().add(PackageEventUpdate(package: packageTemp));
  }

  @override
  void dispose() {
    // other dispose methods
    nameTextController.dispose();
    priceTextController.dispose();
    txt3.dispose();
    descriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Chỉnh sửa dịch vụ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(height: 5.0),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Tên dịch vụ: *',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: nameTextController,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Nhập tên dịch vụ của bạn',
                              hintStyle: TextStyle(
                                fontSize: 17.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
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
                            'Mô tả: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: descriptionTextController,
                            maxLines: null,
                            autofocus: false,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Nhập mô tả cho gói dịch vụ của bạn',
                              hintStyle: TextStyle(
                                fontSize: 17.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
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
                            'Giá thành dịch vụ: *',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: priceTextController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Nhập giá thành dịch vụ',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
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
                            'Thời gian tác nghiệp: *',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: txt3,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Nhập thời gian tác nghiệp dự kiến',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Phương thức giao hàng: *',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      ),
                      SizedBox(height: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          checkbox(app, delivery[app]),
                          checkbox(meet, delivery[meet]),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Chi tiết dịch vụ: *',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      ),
                      // MiniHeader(),
                      MiniListEdit(
                        servicesOfPackage: widget.package.serviceDtos,
                        onChangeParam:
                            (List<ServiceBlocModel> servicesOfPackage) {
                          servicesOfPackageResult = servicesOfPackage;
                        },
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 30.0),
                          width: 300,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              _updatePackage();
                              // Navigator.pop(context);
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Hoàn thành',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget checkbox(String title, bool boolValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: (value) => setState(() => delivery[title] = value),
        ),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
