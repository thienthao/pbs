import 'package:cus_2_11_app/models/item_model.dart';
import 'package:cus_2_11_app/models/topic_model.dart';
import 'package:cus_2_11_app/screens/forum_screen/forum_detail.dart';
import 'package:cus_2_11_app/screens/forum_screen/list_topic.dart';
import 'package:cus_2_11_app/widgets/forum_screen/list_thread.dart';
import 'package:cus_2_11_app/widgets/forum_screen/list_topic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabList = [
    Tab(
      child: Text('Xu hướng thảo luận'),
    ),
    Tab(
      child: Text('Gần đây nhất'),
    ),
    Tab(
      child: Text('Danh mục'),
    ),
    Tab(
      child: Text('Bài đăng của tôi'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120.0,
        backgroundColor: Color(0xFFFAFAFA),
        centerTitle: true,
        title: Text(
          'Forum',
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TopicAdd()),
          );
        },
        child: Icon(
          Icons.post_add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                Item item = items[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForumDetail(
                        item: item,
                      ),
                    ),
                  ),
                  child: listThread(items[index]),
                );
              },
            ),
          ),
          Container(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                Item item = items[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForumDetail(
                        item: item,
                      ),
                    ),
                  ),
                  child: listThread(items[index]),
                );
              },
            ),
          ),
          Container(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: listTopic(topics[index]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
