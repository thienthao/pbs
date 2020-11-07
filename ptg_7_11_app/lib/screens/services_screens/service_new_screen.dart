import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:ptg_7_11_app/blocs/package_blocs/packages.dart';
import 'package:ptg_7_11_app/models/package_bloc_model.dart';
import 'package:ptg_7_11_app/models/service_bloc_model.dart';
import 'package:ptg_7_11_app/widgets/service/mini_service_header.dart';
import 'package:ptg_7_11_app/widgets/service/mini_service_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewService extends StatefulWidget {
  @override
  _NewServiceState createState() => _NewServiceState();
}

class _NewServiceState extends State<NewService> {
  intl.NumberFormat oCcy = intl.NumberFormat("#,##0", "vi_VN");
  var nameTextController = TextEditingController();
  var descriptionTextController = TextEditingController();
  var priceTextController = TextEditingController();
  var onAirTimeTextController = TextEditingController();

  static String app = "Giao hàng qua ứng dụng";
  static String meet = "Gặp mặt khách hàng";

  List<String> servicesOfPackageResult = [];

  Map<String, bool> delivery = {
    app: true,
    meet: false,
  };

  _createPackage() async {
    List<ServiceBlocModel> tempServices;
    tempServices = servicesOfPackageResult.map((service) {
      return ServiceBlocModel(name: service);
    }).toList();
    print('price: ${priceTextController.text}');
    PackageBlocModel packageTemp = PackageBlocModel(
      name: nameTextController.text,
      description: descriptionTextController.text,
      price: int.parse(
          priceTextController.text.replaceAll(new RegExp(r'[^\w\s]+'), '')),
      serviceDtos: tempServices,
    );
    print(
        'This is going to create ${packageTemp.name} ${packageTemp.description} ${packageTemp.price} ${packageTemp.serviceDtos[0].name}');
    context.bloc<PackageBloc>().add(PackageEventCreate(package: packageTemp));
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
          'Tạo dịch vụ',
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
                          TextField(
                            autofocus: false,
                            controller: nameTextController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Ví dụ: Gói 01',
                              hintStyle: TextStyle(
                                fontSize: 18.0,
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
                            'Mô tả:',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          TextField(
                            autofocus: false,
                            maxLines: null,
                            controller: descriptionTextController,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Nhập mô tả cho gói dịch vụ của bạn',
                              hintStyle: TextStyle(
                                fontSize: 18.0,
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
                            'Giá thành dịch vụ (đơn vị: đồng): *',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          TextField(
                            controller: priceTextController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              ThousandsFormatter(),
                            ],
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Ví dụ: 10.000.000 đ',
                              hintStyle: TextStyle(
                                fontSize: 18.0,
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
                            'Thời gian tác nghiệp: *',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          TextField(
                            controller: onAirTimeTextController,
                            keyboardType: TextInputType.datetime,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Ví dụ: 3 giờ',
                              hintStyle: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
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
                      MiniList(
                        onChangeParam: (List<String> servicesOfPackage) {
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
                              _createPackage();
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
