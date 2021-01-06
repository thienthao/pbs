import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/blocs/album_blocs/album.dart';
import 'package:photographer_app_java_support/blocs/category_blocs/categories.dart';
import 'package:photographer_app_java_support/models/album_bloc_model.dart';
import 'package:photographer_app_java_support/models/category.dart';
import 'package:photographer_app_java_support/models/category_bloc_model.dart';
import 'package:photographer_app_java_support/screens/profile_screens/photo_view_screen.dart';
import 'package:photographer_app_java_support/widgets/profile_screen/bottom_sheet_category.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
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
                                    borderRadius: BorderRadius.circular(10.0),
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
                                  BlocListener<AlbumBloc, AlbumState>(
                                    listener: (context, state) {
                                      if (state
                                          is AlbumStateRemoveImageSuccess) {}
                                    },
                                    child: Positioned(
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
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  categoryChips() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List<Widget>.generate(categorys.length, (int index) {
        Category location = categorys[index];
        return Chip(
          label: Text(location.name),
          onDeleted: () {
            setState(() {
              categorys.removeAt(index);
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
            child: BottomSheetCategory(),
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
