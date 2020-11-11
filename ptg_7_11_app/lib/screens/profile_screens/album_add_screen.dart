import 'dart:io';
import 'package:ptg_7_11_app/blocs/album_blocs/album.dart';
import 'package:ptg_7_11_app/models/album_bloc_model.dart';
import 'package:ptg_7_11_app/models/category.dart';
import 'package:ptg_7_11_app/models/photographer_bloc_model.dart';
import 'package:ptg_7_11_app/widgets/profile_screen/bottom_sheet_category.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  _createAlbum() async {
    _album = AlbumBlocModel(
        name: nameController.text,
        description: descriptionController.text,
        photographer: Photographer(id: 168));
    print(_album.name);
    print(_images[0].path.split('/').last);
    context.bloc<AlbumBloc>().add(AlbumEventCreateAlbum(
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
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.blue,
            ),
            onPressed: () {
              _createAlbum();
            },
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Địa điểm: *',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),
                ),
                TextField(
                  controller: locationController,
                  enableSuggestions: true,
                  autocorrect: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.location_on),
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: 'Ví dụ: Hà Nội',
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
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => onPressedButton(),
                      ),
                      categoryChips(),
                    ],
                  ),
                ),
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