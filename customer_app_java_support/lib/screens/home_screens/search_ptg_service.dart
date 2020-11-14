import 'package:customer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class SearchPtgService extends StatefulWidget {
  @override
  _SearchPtgServiceState createState() => _SearchPtgServiceState();
}

class _SearchPtgServiceState extends State<SearchPtgService>
    with SingleTickerProviderStateMixin {
  bool isInit = true;
  List<Tab> _tabList = [
    Tab(
      child: Text('Photographer'),
    ),
    Tab(
      child: Text('Gói dịch vụ'),
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _searchPhotographerAndPackage(String _search) {
    BlocProvider.of<PhotographerBloc>(context)
        .add(PhotographerEventSearch(search: _search));
  }

  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        toolbarHeight: 120.0,
        backgroundColor: Color(0xFFFAFAFA),
        title: Text(
          'Tìm kiếm',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            isScrollable: true,
            controller: _tabController,
            tabs: _tabList,
            labelColor: Colors.black,
          ),
        ),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    _searchPhotographerAndPackage(value);
  }

  _SearchPtgServiceState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: BlocBuilder<PhotographerBloc, PhotographerState>(
        builder: (context, state) {
          if (state is PhotographerStateLoading) {
            if (isInit) {
              isInit = false;
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                    child: Text(
                  'Bạn hãy nhập photographer hoặc gói dịch vụ bạn muốn tìm',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                )),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }

          if (state is PhotographerStateSearchSuccess) {
            return TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: listPtg(state.searchModel.photographers),
                ),
                Container(
                  child: listService(state.searchModel.packages),
                ),
              ],
            );
          }

          if (state is PhotographerStateFailure) {
            return Center(child: Text('Đã xảy ra lỗi'));
          }

          return Text('');
        },
      ),
    );
  }
}

Widget listPtg(List<Photographer> listPhotographers) {
  if (listPhotographers.isEmpty) {
    return Center(
        child: Text(
      'Không có kết quả nào phù hợp',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.0),
    ));
  } else {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: listPhotographers.length,
      itemBuilder: (BuildContext context, int index) {
        Photographer photographer = listPhotographers[index];
        return Card(
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 65.0,
                  height: 65.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(photographer.avatar),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Text(
                  photographer.fullname,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget listService(List<PackageBlocModel> listPackages) {
  if (listPackages.isEmpty) {
    return Center(
        child: Text(
      'Không có kết quả nào phù hợp',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.0),
    ));
  } else {
    return ListView.builder(
      itemCount: listPackages.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        PackageBlocModel package = listPackages[index];
        return Card(
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(Icons.category),
                ),
                SizedBox(width: 20.0),
                Container(
                  child: Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.name,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          ' tạo bởi ${package.photographer.fullname}',
                          style: TextStyle(fontSize: 11.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
