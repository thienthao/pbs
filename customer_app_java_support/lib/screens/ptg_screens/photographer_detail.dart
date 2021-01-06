import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:customer_app_java_support/blocs/album_blocs/album.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:customer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:customer_app_java_support/blocs/warning_blocs/warnings.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/plane_indicator.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/warning_repository.dart';
import 'package:customer_app_java_support/screens/booking_many_screens/booking_many_screen.dart';
import 'package:customer_app_java_support/shared/block_loading.dart';
import 'package:customer_app_java_support/shared/loading.dart';
import 'package:customer_app_java_support/shared/photographer_album_loading.dart';
import 'package:customer_app_java_support/shared/photographer_info_loading.dart';
import 'package:customer_app_java_support/shared/pop_up.dart';
import 'package:customer_app_java_support/widgets/ptg_screen/album_of_ptg_carousel.dart';
import 'package:customer_app_java_support/widgets/ptg_screen/bottom_sheet_ptg.dart';
import 'package:customer_app_java_support/widgets/ptg_screen/calendar_show_ptg.dart';
import 'package:customer_app_java_support/widgets/ptg_screen/comment_show_ptg.dart';
import 'package:customer_app_java_support/widgets/ptg_screen/service_show_ptg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;

class CustomerPhotographerDetail extends StatefulWidget {
  final int id;
  final String name;

  const CustomerPhotographerDetail({this.id, this.name});

  @override
  _CustomerPhotographerDetailState createState() =>
      _CustomerPhotographerDetailState();
}

class _CustomerPhotographerDetailState
    extends State<CustomerPhotographerDetail> {
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  WarningRepository _warningRepository =
      WarningRepository(httpClient: http.Client());
  List<PackageBlocModel> blocPackages;

  Completer<void> _completer;
  PackageBlocModel selectedPackage;
  Photographer _photographer;
  bool packageIsNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  _logOut() async {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  @override
  Widget build(BuildContext context) {
    return PlaneIndicator(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ////////////////////////////////// Container
              ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Center(
                child: BlocConsumer<PhotographerBloc, PhotographerState>(
                  listener: (context, photographerState) {
                    if (photographerState is PhotographerStateFailure) {
                      print(photographerState.error);
                      String error =
                          photographerState.error.replaceAll('Exception: ', '');

                      if (error.toUpperCase() == 'UNAUTHORIZED') {
                        _showUnauthorizedDialog();
                      }
                    }
                  },
                  builder: (context, photographerState) {
                    if (photographerState is PhotographerIDStateSuccess) {
                      _photographer = photographerState.photographer;
                      if (photographerState.photographer == null) {
                        return Text(
                          'Đà Lạt',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///////////////////////////// Photographer info
                            Stack(
                              children: <Widget>[
                                Container(
                                  transform: Matrix4.translationValues(
                                      0.0, -50.0, 0.0),
                                  child: Hero(
                                    tag:
                                        photographerState.photographer.fullname,
                                    child: Container(
                                      child: Image(
                                        image: NetworkImage(
                                            photographerState
                                                    .photographer.cover ??
                                                'https://atlasadventuretravel.com/wp-content/uploads/2018/03/events-placeholder.jpg',
                                            headers: {
                                              HttpHeaders.authorizationHeader:
                                                  'Bearer $globalCusToken'
                                            }),
                                        height: 220.0,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      padding: EdgeInsets.only(left: 30.0),
                                      onPressed: () => Navigator.pop(context),
                                      icon: RotatedBox(
                                        quarterTurns: 1,
                                        child: Icon(
                                          Icons.expand_more,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ),
                                      iconSize: 30.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Positioned.fill(
                                  left: 30.0,
                                  right: 30.0,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 60,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            photographerState
                                                    .photographer.avatar ??
                                                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                                            headers: {
                                              HttpHeaders.authorizationHeader:
                                                  'Bearer $globalCusToken'
                                            }),
                                        radius: 55,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.0,
                                  left: 160.0,
                                  child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Quicksand',
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: photographerState
                                                        .photographer.booked !=
                                                    null
                                                ? '${photographerState.photographer.booked}'
                                                : '0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: ' đã đặt ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal)),
                                        TextSpan(
                                            text: '    |   ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal)),
                                        TextSpan(
                                          text: ' ★ ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        TextSpan(
                                            text: photographerState.photographer
                                                        .ratingCount !=
                                                    null
                                                ? '${photographerState.photographer.ratingCount}'
                                                : '0',
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  25.0, 2.0, 0.0, 0.0),
                              child: Text(
                                  '${photographerState.photographer.fullname}',
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          '${photographerState.photographer.description}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }

                    if (photographerState is PhotographerStateLoading) {
                      return PhotographerInfoLoadingWidget();
                    }

                    if (photographerState is PhotographerStateFailure) {
                      return Text(
                        'Đã xảy ra lỗi trong lúc tải dữ liệu',
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text(
                  'Các album của ${widget.name}',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: BlocBuilder<AlbumBloc, AlbumState>(
                  builder: (context, albumState) {
                    if (albumState is AlbumStateSuccess) {
                      if (albumState.albums == null) {
                        return Text(
                          'Đà Lạt',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      } else if (albumState.albums.length == 0) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              '${widget.name} hiện tại chưa có album nào',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      } else {
                        AlbumOfPhotographerCarouselWidget(
                          onUpdateAlbum: (bool onUpdated) {
                            if (onUpdated) {
                              BlocProvider.of<AlbumBloc>(context).add(
                                  AlbumByPhotographerIdEventFetch(
                                      id: widget.id));
                            }
                          },
                          blocAlbums: albumState.albums,
                        );
                      }
                    }

                    if (albumState is AlbumStateLoading) {
                      return AlbumOfPhotographerLoadingWidget();
                    }

                    if (albumState is AlbumStateFailure) {
                      return Text(
                        'Đã xảy ra lỗi trong lúc tải dữ liệu',
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                      );
                    }
                    final albumsTemp = (albumState as AlbumStateSuccess).albums;
                    return RefreshIndicator(
                        child: AlbumOfPhotographerCarouselWidget(
                          onUpdateAlbum: (bool onUpdated) {
                            if (onUpdated) {
                              BlocProvider.of<AlbumBloc>(context).add(
                                  AlbumByPhotographerIdEventFetch(
                                      id: widget.id));
                            }
                          },
                          blocAlbums: albumsTemp,
                        ),
                        onRefresh: () {
                          BlocProvider.of<AlbumBloc>(context)
                              .add(AlbumEventRefresh(album: albumsTemp[0]));
                          return _completer.future;
                        });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Nhận xét',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, commentState) {
                    if (commentState is CommentStateSuccess) {
                      if (commentState.comments == null) {
                        return Center(
                          child: Text(
                            '${widget.name} hiện tại chưa có nhận xét nào',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      } else if (commentState.comments.length == 0) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              '${widget.name} hiện tại chưa có nhận xét nào',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            CommentShow(
                              blocComments: commentState.comments,
                            ),
                          ],
                        );
                      }
                    }

                    if (commentState is CommentStateLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Loading(),
                      );
                    }

                    if (commentState is CommentStateFailure) {
                      return Text(
                        'Đã xảy ra lỗi trong lúc tải dữ liệu',
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Lịch của ${widget.name}',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  if (state is CalendarStateLoading) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlockLoadingWidget(),
                    );
                  }

                  if (state is CalendarStateFailure) {
                    return Center(
                      child: InkWell(
                        onTap: () {
                          BlocProvider.of<CalendarBloc>(context).add(
                              CalendarEventPhotographerDaysFetch(
                                  ptgId: widget.id));
                        },
                        child: Text(
                          'Đã xảy ra lỗi trong lúc tải dữ liệu \n Ấn để thử lại',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        ),
                      ),
                    );
                  }

                  if (state is CalendarStatePhotographerDaysSuccess) {
                    return CalendarView(
                      photographerDays: state.photographerDays,
                    );
                  }
                  return Text('');
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: Text(
                  'Chọn gói dịch vụ bạn muốn',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Center(
                child: BlocBuilder<PackageBloc, PackageState>(
                  builder: (context, packageState) {
                    if (packageState is PackageStateSuccess) {
                      if (packageState.packages == null) {
                        return Center(
                          child: Text(
                            'Hiện tại ${widget.name} chưa có dịch vụ nào.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      } else if (packageState.packages.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Hiện tại ${widget.name} chưa có dịch vụ nào.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      } else {
                        packageIsNotEmpty = true;
                        blocPackages = packageState.packages;
                        ServiceShow(
                          blocPackages: packageState.packages,
                        );
                      }
                    }

                    if (packageState is PackageStateLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Loading(),
                      );
                    }

                    if (packageState is PackageStateFailure) {
                      return Text(
                        'Đã xảy ra lỗi trong lúc tải dữ liệu',
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                      );
                    }
                    final packagesTemp =
                        (packageState as PackageStateSuccess).packages;
                    return RefreshIndicator(
                        child: ServiceShow(
                          blocPackages: packagesTemp,
                          onSelectParam: (PackageBlocModel package) {
                            print(
                                'Package multi day: ${package.supportMultiDays}');
                            selectedPackage = package;
                          },
                        ),
                        onRefresh: () {
                          BlocProvider.of<PackageBloc>(context).add(
                              PackageEventRefresh(package: packagesTemp[0]));
                          return _completer.future;
                        });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: RaisedButton(
                  onPressed: () {
                    if (_photographer != null && packageIsNotEmpty) {
                      onPressedButton();
                    }
                    if (!packageIsNotEmpty) {
                      popUp(context, 'Không thể đặt lịch với ${widget.name}',
                          'Do ${widget.name} chưa có dịch vụ nên bạn không thể đặt hẹn');
                    }
                  },
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 70.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void onPressedButton() {
    if (selectedPackage.supportMultiDays) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    BookingBloc(bookingRepository: _bookingRepository),
              ),
            ],
            child: BookingMany(
              photographer: _photographer,
              blocPackages: blocPackages,
              selectedPackage: selectedPackage,
            ),
          ),
        ),
      );
    } else {
      print(blocPackages);
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.95,
                color: Colors.black45,
                child: Container(
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            BookingBloc(bookingRepository: _bookingRepository),
                      ),
                      BlocProvider(
                        create: (context) =>
                            WarningBloc(warningRepository: _warningRepository),
                      )
                    ],
                    child: BottomSheetShow(
                      photographerName:
                          Photographer(id: widget.id, fullname: widget.name),
                      blocPackages: blocPackages,
                      selectedPackage: selectedPackage,
                    ),
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
            },
          );
        },
      );
    }
  }

  Future<void> _showUnauthorizedDialog() async {
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
                'Thông báo',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Tài khoản không có quyền truy cập nội dung này!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                _logOut();
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
