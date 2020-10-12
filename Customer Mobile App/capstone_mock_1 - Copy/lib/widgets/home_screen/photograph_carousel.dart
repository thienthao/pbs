import 'package:capstone_mock_1/blocs/photographer_blocs/photographer.dart';
import 'package:capstone_mock_1/models/photographer_bloc_model.dart';
import 'package:capstone_mock_1/respositories/photographer_respository.dart';
import 'package:capstone_mock_1/screens/photographer_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PhotographCarousel extends StatefulWidget {
  List<Photographer> bloc_photographers;

  PhotographCarousel({this.bloc_photographers});

  @override
  _PhotographCarouselState createState() => _PhotographCarouselState();
}

class _PhotographCarouselState extends State<PhotographCarousel> {
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Photographer được đánh giá cao',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  wordSpacing: -1,
                  color: Colors.black54,
                ),
              ),
              GestureDetector(
                onTap: () => print('See All'),
                child: Text(
                  'Xem thêm',
                  style: TextStyle(
                    wordSpacing: -1,
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: const EdgeInsets.only(left: 21.0, right: 300.0),
          height: 3.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.0),
          child: Container(
            height: 240.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.bloc_photographers.length,
              itemBuilder: (BuildContext context, int index) {
                Photographer photographer = widget.bloc_photographers[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) =>
                            PhotographerBloc(photographerRepository: _photographerRepository)..add(PhotographerbyIdEventFetch(id: photographer.id)),
                        child: CustomerPhotographerDetail(
                          id: photographer.id,
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    width: 240.0,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0)
                              ]),
                          child: Stack(
                            children: <Widget>[
                              Hero(
                                tag: photographer.avatar,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image(
                                    image: NetworkImage(photographer.avatar),
                                    height: 240.0,
                                    width: 240.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15.0,
                                bottom: 15.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      photographer.fullname,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1.2,
                                          shadows: [
                                            Shadow(
                                                offset: Offset(1, 3),
                                                blurRadius: 6)
                                          ]),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_border_outlined,
                                          color: Colors.amberAccent,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 2.0),
                                        Text(
                                          '${photographer.ratingCount}',
                                          style: TextStyle(
                                              color: Colors.amberAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: 1.2,
                                              shadows: [
                                                Shadow(
                                                    offset: Offset(1, 3),
                                                    blurRadius: 6)
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
