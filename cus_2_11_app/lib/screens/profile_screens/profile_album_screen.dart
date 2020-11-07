import 'package:cus_2_11_app/constant/search.dart';
import 'package:cus_2_11_app/screens/profile_screens/album_add_screen.dart';
import 'package:flutter/material.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Album của tôi'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAlbum()),
              );
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
                width: 320.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF1E4F2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'Thêm Album',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(searchImages.length, (index) {
                  return Column(
                    children: [
                      Container(
                        color: Theme.of(context).accentColor,
                        height: 1.0,
                        width: (size.width - 3.0) / 3.0,
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        color: Theme.of(context).accentColor,
                        height: 1.0,
                        width: (size.width - 2.8) / 2.8,
                      ),
                      SizedBox(height: 4.0),
                      Hero(
                        tag: searchImages[index],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            image: NetworkImage(searchImages[index]),
                            width: (size.width - 2.5) / 2.5,
                            height: (size.width - 2.5) / 2.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
