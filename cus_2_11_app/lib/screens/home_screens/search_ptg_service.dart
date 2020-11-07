import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class SearchPtgService extends StatefulWidget {
  @override
  _SearchPtgServiceState createState() => _SearchPtgServiceState();
}

class _SearchPtgServiceState extends State<SearchPtgService>
    with SingleTickerProviderStateMixin {
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
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
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
    print('success');
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
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                listPtg(),
              ],
            ),
          ),
          Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                listService(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget listPtg() {
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
                image: AssetImage('assets/avatars/man02.jpg'),
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Text(
            'Tên 01',
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
}

Widget listService() {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gói chụp thời trang',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                ' tạo bởi Thành Long',
                style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

