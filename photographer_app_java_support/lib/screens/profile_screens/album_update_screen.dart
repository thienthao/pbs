import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:photographer_app_java_support/blocs/album_blocs/album.dart';
import 'package:photographer_app_java_support/blocs/category_blocs/categories.dart';
import 'package:photographer_app_java_support/models/album_bloc_model.dart';
import 'package:photographer_app_java_support/models/category_bloc_model.dart';
import 'package:photographer_app_java_support/screens/profile_screens/photo_view_screen.dart';
import 'package:photographer_app_java_support/widgets/shared/scale_navigator.dart';

class UpdateAlbum extends StatefulWidget {
  final AlbumBlocModel album;

  const UpdateAlbum({this.album});
  @override
  _UpdateAlbumState createState() => _UpdateAlbumState();
}

class _UpdateAlbumState extends State<UpdateAlbum> {
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

  _addImageForAlbum(File image) async {
    BlocProvider.of<AlbumBloc>(context).add(
        AlbumEventAddAnImageForAnAlbum(albumId: widget.album.id, image: image));
  }

  _removeImageOfAnAlbum(int imageId) async {
    BlocProvider.of<AlbumBloc>(context).add(AlbumEventDeleteAnImageOfAnAlbum(
        albumId: widget.album.id, imageId: imageId));
  }

  _removeAlbum() async {
    BlocProvider.of<AlbumBloc>(context)
        .add(AlbumEventDeleteAlbum(albumId: widget.album.id));
  }

  _updateAlbumInfo() async {
    print(widget.album.id);
    AlbumBlocModel albumBlocModel = AlbumBlocModel(
      id: widget.album.id,
      description: descriptionController.text,
      location: locationController.text,
      name: nameController.text,
      category: selectedCategory,
    );

    BlocProvider.of<AlbumBloc>(context)
        .add(AlbumEventUpdateInfo(album: albumBlocModel));
  }

  List<File> _images = [];

  Future getImage() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Gallery,
    );
    setState(() {
      if (image != null) {
        _images.add(image);
        _addImageForAlbum(image);
      }
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.album.name ?? '';
    dateController.text = widget.album.createAt.toString() == 'null'
        ? ''
        : widget.album.createAt.toString();
    locationController.text = widget.album.location ?? '';
    descriptionController.text =
        widget.album.description == 'null' ? '' : widget.album.description;
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
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.blue,
            ),
            onPressed: () => _updateAlbumInfo(),
          ),
        ],
        title: Text('Chi tiết Album'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocListener<AlbumBloc, AlbumState>(
            listener: (context, state) {
              if (state is AlbumStateRemoveImageSuccess) {}
              if (state is AlbumStateLoading) {
                _showLoadingAlert();
              }
              if (state is AlbumStateDeleteAlbumSuccess) {
                Navigator.pop(context);
                _showDeleteSuccessAlert();
              }

              if (state is AlbumStateFailure) {
                Navigator.pop(context);
                _showFailDialog();
              }
              if (state is AlbumStateFailure) {
                Navigator.pop(context);
                _showFailDialog();
              }

              if (state is AlbumStateUpdatedSuccess) {
                Navigator.pop(context);
                _showSuccessAlert();
              }
            },
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
                    SizedBox(height: 5.0),
                    BlocListener<CategoryBloc, CategoryState>(
                      listener: (context, state) {
                        if (state is CategoryStateSuccess) {
                          for (CategoryBlocModel category in state.categories) {
                            if (!(category.id == 1)) {
                              listCategory.add(category);
                            }
                          }
                          for (var item in state.categories) {
                            if (item.id == widget.album.category.id) {
                              selectedCategory = item;
                            }
                          }

                          categoryDropDownMenuItems =
                              buildCategoryDropdownMenuItems(listCategory);

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
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.vertical,
                    //   child: Wrap(
                    //     spacing: 7,
                    //     runSpacing: 7,
                    //     children: List.generate(
                    //       _images.length,
                    //       (index) {
                    //         return Hero(
                    //           tag: _images[index],
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(10.0),
                    //             child: Image(
                    //               image: FileImage(_images[index]),
                    //               width: 100,
                    //               height: 100,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        children: [
                          Wrap(
                            spacing: 7,
                            runSpacing: 7,
                            children: List.generate(
                              widget.album.images.length,
                              (index) {
                                return Hero(
                                  tag: widget.album.images[index],
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            return scaleNavigator(
                                                context,
                                                PhotoViewScreen(
                                                  imageUrl: widget.album
                                                      .images[index].imageLink,
                                                ));
                                          },
                                          child: Image(
                                            image: NetworkImage(widget
                                                .album.images[index].imageLink),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            // print(widget.album.images[index].id);
                                            print(widget.album.id);
                                            _removeImageOfAnAlbum(
                                                widget.album.images[index].id);
                                            widget.album.images.removeAt(index);
                                            setState(() {});
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: Container(
                                              color: Colors.black54,
                                              height: 30,
                                              width: 30,
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Wrap(
                              spacing: 7,
                              runSpacing: 7,
                              children: List.generate(
                                _images.length,
                                (index) {
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
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: ButtonTheme(
                                  minWidth: 300.0,
                                  child: RaisedButton(
                                    color: Color(0xFFF77474),
                                    onPressed: () {
                                      _showConfirmAlert();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Xóa Album',
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
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
                'Thành công',
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

  Future<void> _showDeleteSuccessAlert() async {
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
                'Thành công',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Xóa album thành công!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
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

  Future<void> _showConfirmAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/question.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Xác nhận',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Bạn có chắc là muốn xóa album này hay không?',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () {
                Navigator.pop(context);
                _removeAlbum();
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
              buttonCancelColor: Theme.of(context).scaffoldBackgroundColor,
              buttonCancelText: Text(
                'Hủy bỏ',
                style: TextStyle(color: Colors.black87),
              ),
            ));
  }
}
