import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:photographer_app_java_support/blocs/album_blocs/album.dart';
import 'package:photographer_app_java_support/blocs/category_blocs/categories.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/album_bloc_model.dart';
import 'package:photographer_app_java_support/models/category_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';

class AddAlbum extends StatefulWidget {
  @override
  _AddAlbumState createState() => _AddAlbumState();
}

class _AddAlbumState extends State<AddAlbum> {
  List<File> _images = [];
  File _thumbnail;
  AlbumBlocModel _album;

  Future getImage() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Gallery,
    );
    setState(() {
      if (image != null) {
        _images.add(image);
      }
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<CategoryBlocModel> listCategory = List<CategoryBlocModel>();
  List<DropdownMenuItem<CategoryBlocModel>> categoryDropDownMenuItems;
  CategoryBlocModel selectedCategory;

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

  _createAlbum() async {
    _album = AlbumBlocModel(
        name: nameController.text,
        description: descriptionController.text,
        category: selectedCategory,
        photographer: Photographer(id: globalPtgId));
    print(_album.name);
    print(_images[0].path.split('/').last);
    BlocProvider.of<AlbumBloc>(context).add(AlbumEventCreateAlbum(
        album: _album, thumbnail: _thumbnail, images: _images));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          BlocListener<AlbumBloc, AlbumState>(
            listener: (context, state) {
              if (state is AlbumStateLoading) {
                _showLoadingAlert();
              }
              if (state is AlbumStateCreatedSuccess) {
                Navigator.pop(context);
                _showSuccessAlert();
              }
              if (state is AlbumStateLoading) {
                Navigator.pop(context);
                _showFailDialog();
              }
            },
            child: IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.blue,
              ),
              onPressed: () {
                _createAlbum();
              },
            ),
          ),
        ],
        title: Text('Tạo Album'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tên Album: *',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),
                ),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.notes),
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: 'Ví dụ: Album 01',
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
                  'Thời gian: *',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),
                ),
                TextField(
                  controller: dateController,
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.calendar_today),
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: 'Ví dụ: 01/01/2011',
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Text(
            //       'Địa điểm: *',
            //       style: TextStyle(color: Colors.black87, fontSize: 12.0),
            //     ),
            //     TextField(
            //       controller: locationController,
            //       enableSuggestions: true,
            //       autocorrect: true,
            //       keyboardType: TextInputType.text,
            //       style: TextStyle(
            //         color: Colors.black87,
            //       ),
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //         icon: Icon(Icons.location_on),
            //         contentPadding: EdgeInsets.all(8.0),
            //         hintText: 'Ví dụ: Hà Nội',
            //         hintStyle: TextStyle(
            //           fontSize: 15.0,
            //           color: Colors.grey,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 30.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Mô tả: *',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),
                ),
                TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.subject),
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: 'Ví dụ: Album này ....',
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
                  'Category: *',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),
                ),
                BlocListener<CategoryBloc, CategoryState>(
                  listener: (context, state) {
                    if (state is CategoryStateSuccess) {
                      for (CategoryBlocModel category in state.categories) {
                        if (!(category.id == 1)) {
                          listCategory.add(category);
                        }
                      }


                      categoryDropDownMenuItems =
                          buildCategoryDropdownMenuItems(listCategory);
                      selectedCategory = categoryDropDownMenuItems[0].value;
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
                  'Ảnh: *',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),
                ),
                GestureDetector(
                  onTap: () => getImage(),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: List.generate(_images.length, (index) {
                      return Hero(
                        
                        tag: _images[index],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            image: FileImage(_images[index]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                'Thêm album thành công!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
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
