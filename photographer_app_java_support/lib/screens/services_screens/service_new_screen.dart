import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:photographer_app_java_support/blocs/category_blocs/categories.dart';
import 'package:photographer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:photographer_app_java_support/models/category_bloc_model.dart';
import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:photographer_app_java_support/models/service_bloc_model.dart';
import 'package:photographer_app_java_support/widgets/service/mini_service_list.dart';
import 'package:status_alert/status_alert.dart';

class NewService extends StatefulWidget {
  @override
  _NewServiceState createState() => _NewServiceState();
}

enum SingingCharacter { one_day, multi_day }

class _NewServiceState extends State<NewService> {
  SingingCharacter _character = SingingCharacter.one_day;
  bool isMultiDay = false;
  intl.NumberFormat oCcy = intl.NumberFormat("#,##0", "vi_VN");
  var nameTextController = TextEditingController();
  var descriptionTextController = TextEditingController();
  var priceTextController = TextEditingController();
  var onAirTimeTextController = TextEditingController();
  ScrollController _scrollController;

  static String app = "Giao hàng qua ứng dụng";
  static String meet = "Gặp mặt khách hàng";

  final _formKey = GlobalKey<FormState>();

  List<String> servicesOfPackageResult = [];

  List<CategoryBlocModel> listCategory = List<CategoryBlocModel>();
  List<DropdownMenuItem<CategoryBlocModel>> categoryDropDownMenuItems;
  CategoryBlocModel selectedCategory;

  Map<String, bool> delivery = {
    app: true,
    meet: false,
  };

  List<DropdownMenuItem<CategoryBlocModel>> buildCategoryDropdownMenuItems(
      List categories) {
    List<DropdownMenuItem<CategoryBlocModel>> items = List();
    for (CategoryBlocModel category in categories) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.category),
        ),
      );
    }
    return items;
  }

  onChangeCategoryDropdownItem(CategoryBlocModel newSelectedCategory) {
    setState(() {
      selectedCategory = newSelectedCategory;
    });
  }

  Widget _buildCategoryComboBox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: MediaQuery.of(context).size.width * 0.99,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[300],
              offset: Offset(-1.0, 2.0),
              blurRadius: 6.0)
        ],
      ),
      padding: EdgeInsets.all(10),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: selectedCategory,
            items: categoryDropDownMenuItems,
            onChanged: onChangeCategoryDropdownItem,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.pink,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeEstimateTextFormField(bool _isMultiDay) {
    if (_isMultiDay) {
      return SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Thời gian tác nghiệp: *',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.0),
          ),
          TextFormField(
            validator: checkTextFormFieldIsEmpty,
            controller: onAirTimeTextController,
            keyboardType: TextInputType.number,
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
          SizedBox(height: 30.0),
        ],
      );
    }
  }

  void popNotice() {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 60),
      title: 'Đang gửi yêu cầu',
      configuration: IconConfiguration(
        icon: Icons.send_to_mobile,
      ),
    );
  }

  void removeNotice() {
    StatusAlert.hide();
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

  bool _validateBooking() {
    if (int.parse(onAirTimeTextController.text.trim()) > 0 &&
        int.parse(onAirTimeTextController.text.trim()) < 24) {
      popUp('Thời gian tác nghiệp',
          'Thời gian tác nghiệp ít hơn 1 giờ và quá 24 giờ!');
      return false;
    } else if (servicesOfPackageResult.isEmpty) {
      popUp('Chi tiết dịch vụ', 'Xin hãy tạo dịch vụ bên trong gói dịch vụ!');
      return false;
    }
    return true;
  }

  _createPackage() async {
    if (_validateBooking()) {
      List<ServiceBlocModel> tempServices;
      tempServices = servicesOfPackageResult.map((service) {
        return ServiceBlocModel(name: service);
      }).toList();
      print('price: ${priceTextController.text}');
      PackageBlocModel packageTemp = PackageBlocModel(
          name: nameTextController.text,
          description: descriptionTextController.text,
          supportMultiDays: isMultiDay,
          price: int.parse(
              priceTextController.text.replaceAll(new RegExp(r'[^\w\s]+'), '')),
          serviceDtos: tempServices,
          category: selectedCategory);
      print(
          'This is going to create ${packageTemp.name} ${packageTemp.description} ${packageTemp.price} ${packageTemp.serviceDtos[0].name}');
      BlocProvider.of<PackageBloc>(context)
          .add(PackageEventCreate(package: packageTemp));
    }
  }

  String checkTextFormFieldIsEmpty(value) {
    if (value.isEmpty) {
      return 'Bạn không thể bỏ trống trường này!';
    }
    return null;
  }

  void _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 800), curve: Curves.easeInOutBack);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    BlocProvider.of<CategoryBloc>(context).add(CategoryEventFetch());
    _character = SingingCharacter.one_day;
    isMultiDay = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
        body: BlocListener<PackageBloc, PackageState>(
          listener: (context, state) {
            if (state is PackageStateCreatedSuccess) {
              removeNotice();
              popUp('Tạo gói dịch vụ', 'Tạo gói dịch vụ thành công!!');
            }

            if (state is PackageStateLoading) {
              popNotice();
            }
            if (state is PackageStateFailure) {
              removeNotice();
              popUp('Tạo gói dịch vụ', 'Tạo gói dịch vụ thất bại!!');
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
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
                      controller: _scrollController,
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
                                  'Kiểu dịch vụ: *',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: SingingCharacter.one_day,
                                            groupValue: _character,
                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                isMultiDay = false;
                                                _character = value;
                                              });
                                            },
                                          ),
                                          Text('Trong ngày'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: SingingCharacter.multi_day,
                                          groupValue: _character,
                                          onChanged: (SingingCharacter value) {
                                            setState(() {
                                              isMultiDay = true;
                                              _character = value;
                                            });
                                          },
                                        ),
                                        Text('Nhiều ngày'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 30.0),
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
                                TextFormField(
                                  validator: checkTextFormFieldIsEmpty,
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
                                  'Thể loại: *',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                BlocListener<CategoryBloc, CategoryState>(
                                  listener: (context, state) {
                                    if (state is CategoryStateSuccess) {
                                      for (CategoryBlocModel category
                                          in state.categories) {
                                        if (!(category.id == 1)) {
                                          listCategory.add(category);
                                        }
                                      }

                                      categoryDropDownMenuItems =
                                          buildCategoryDropdownMenuItems(
                                              listCategory);
                                      selectedCategory =
                                          categoryDropDownMenuItems[0].value;
                                      setState(() {});
                                    }
                                    if (state is CategoryStateLoading) {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                  child: SizedBox(),
                                ),
                                _buildCategoryComboBox()
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
                                TextFormField(
                                  autofocus: false,
                                  maxLines: null,
                                  controller: descriptionTextController,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    hintText:
                                        'Nhập mô tả cho gói dịch vụ của bạn',
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
                            _timeEstimateTextFormField(isMultiDay),
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
                                TextFormField(
                                  validator: checkTextFormFieldIsEmpty,
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
                                    if (_formKey.currentState.validate()) {
                                      _createPackage();
                                    } else {
                                      _scrollToTop();
                                    }
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
          ),
        ));
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
