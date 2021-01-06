import 'package:photographer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_event.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_state.dart';
import 'package:photographer_app_java_support/blocs/thread_of_user_blocs/thread_of_user_bloc.dart';
import 'package:photographer_app_java_support/blocs/topic_bloc/topic_bloc.dart';
import 'package:photographer_app_java_support/blocs/topic_bloc/topic_event.dart';
import 'package:photographer_app_java_support/blocs/topic_bloc/topic_state.dart';
import 'package:photographer_app_java_support/models/thread_model.dart';
import 'package:photographer_app_java_support/respositories/thread_api_client.dart';
import 'package:photographer_app_java_support/respositories/thread_repository.dart';
import 'package:photographer_app_java_support/respositories/topic-repository.dart';
import 'package:photographer_app_java_support/screens/forum_screen/forum_detail.dart';
import 'package:photographer_app_java_support/screens/forum_screen/list_topic.dart';
import 'package:photographer_app_java_support/widgets/forum_screen/list_thread.dart';
import 'package:photographer_app_java_support/widgets/forum_screen/list_topic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;

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

  // thao's
  final ThreadRepository threadRepository = ThreadRepository(
    threadApiClient: ThreadApiClient(httpClient: http.Client()),
  );

  final TopicRepository topicRepository = TopicRepository(
    threadApiClient: ThreadApiClient(
      httpClient: http.Client(),
    ),
  );
  // end thao's

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
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ThreadBloc(repository: threadRepository),
            ),
            BlocProvider(
              create: (context) =>
                  ThreadOfUserBloc(repository: threadRepository),
            ),
            BlocProvider(
              create: (context) => TopicBloc(repository: topicRepository),
            ),
          ],
          child: ForumBody(_tabController, topicRepository, threadRepository),
        ));
  }
}

class ForumBody extends StatefulWidget {
  final TabController _tabController;
  final TopicRepository topicRepository;
  final ThreadRepository threadRepository;

  ForumBody(this._tabController, this.topicRepository, this.threadRepository);

  @override
  _ForumBodyState createState() => _ForumBodyState();
}

class _ForumBodyState extends State<ForumBody> {
  bool isCreated = false;
  bool isCommentPosted = false;
  _logOut() async {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return FutureBuilder<List<Topic>>(
                  future: widget.topicRepository.all(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Topic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                          body: Center(
                        child: CircularProgressIndicator(),
                      ));
                    } else {
                      if (snapshot.hasError) {
                        return Text("Error loading topics");
                      } else {
                        return TopicAdd(
                          isCreated: (bool _isCreated) {
                            if (_isCreated) {
                              isCreated = true;
                            } else {
                              isCreated = false;
                            }
                          },
                          topics: snapshot.data,
                          repository: widget.threadRepository,
                        );
                      }
                    }
                  });
            }),
          ).then((value) {
            if (isCreated) {
              BlocProvider.of<ThreadBloc>(context).add(FetchThreads());
              BlocProvider.of<ThreadOfUserBloc>(context)
                  .add(FetchThreadsOfUser());
            }
          });
        },
        child: Icon(
          Icons.post_add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<ThreadBloc, ThreadState>(
        listener: (context, state) {
          if (state is ThreadError) {
            String error = state.error.replaceAll('Exception: ', '');
            if (error.toUpperCase() == 'UNAUTHORIZED') {
              _showUnauthorizedDialog();
            }
          }
        },
        builder: (context, state) {
          if (state is ThreadEmpty) {
            BlocProvider.of<ThreadBloc>(context).add(FetchThreads());
          }

          if (state is ThreadError) {
            return Center(
              child: Text("Đã có lỗi xảy ra"),
            );
          }

          if (state is ThreadLoaded) {
            return TabBarView(
              controller: widget._tabController,
              children: [
                Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.threads.length,
                    itemBuilder: (context, index) {
                      Thread thread = state.threads[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) {
                            return BlocProvider(
                              create: (context) => ThreadBloc(
                                  repository: widget.threadRepository),
                              child: ForumDetail(
                                isPosted: (bool _isPosted) {
                                  if (_isPosted) {
                                    isCommentPosted = true;
                                  }
                                },
                                thread: thread,
                                threadRepository: widget.threadRepository,
                              ),
                            );
                          }),
                        ).then((value) {
                          if (isCommentPosted) {
                            BlocProvider.of<ThreadBloc>(context)
                                .add(FetchThreads());
                            BlocProvider.of<ThreadOfUserBloc>(context)
                                .add(FetchThreadsOfUser());
                            isCommentPosted = false;
                          }
                        }),
                        child: listThread(state.threads[index]),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.threads.length,
                    itemBuilder: (context, index) {
                      Thread thread = state.threads[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) {
                            return BlocProvider(
                              create: (context) => ThreadBloc(
                                  repository: widget.threadRepository),
                              child: ForumDetail(
                                isPosted: (bool _isPosted) {
                                  if (_isPosted) {
                                    isCommentPosted = true;
                                  }
                                },
                                thread: thread,
                                threadRepository: widget.threadRepository,
                              ),
                            );
                          }),
                        ).then((value) {
                          if (isCommentPosted) {
                            BlocProvider.of<ThreadBloc>(context)
                                .add(FetchThreads());
                            BlocProvider.of<ThreadOfUserBloc>(context)
                                .add(FetchThreadsOfUser());
                            isCommentPosted = false;
                          }
                        }),
                        child: listThread(state.threads[index]),
                      );
                    },
                  ),
                ),
                Container(
                  child: BlocBuilder<TopicBloc, TopicState>(
                    builder: (context, topicState) {
                      if (topicState is TopicEmpty) {
                        BlocProvider.of<TopicBloc>(context).add(FetchTopics());
                      }

                      if (topicState is TopicError) {
                        return Text("Đã xảy ra lỗi khi tải dữ liệu");
                      }

                      if (topicState is TopicLoaded) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: topicState.topics.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: listTopic(topicState.topics[index]),
                            );
                          },
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                BlocConsumer<ThreadOfUserBloc, ThreadState>(
                  listener: (context, state) {
                    if (state is ThreadError) {
                      String error = state.error.replaceAll('Exception: ', '');
                      if (error.toUpperCase() == 'UNAUTHORIZED') {
                        _showUnauthorizedDialog();
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is ThreadEmpty) {
                      BlocProvider.of<ThreadOfUserBloc>(context)
                          .add(FetchThreadsOfUser());
                    }
                    if (state is ThreadError) {
                      return Center(
                        child: Text('Đã có lỗi xảy ra trong lúc tải dữ liệu'),
                      );
                    }

                    if (state is ThreadLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is ThreadLoaded) {
                      return Container(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: state.threads.length,
                          itemBuilder: (context, index) {
                            Thread thread = state.threads[index];
                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) {
                                  return BlocProvider(
                                    create: (context) => ThreadBloc(
                                        repository: widget.threadRepository),
                                    child: ForumDetail(
                                      isPosted: (bool _isPosted) {
                                        if (_isPosted) {
                                          isCommentPosted = true;
                                        }
                                      },
                                      thread: thread,
                                      threadRepository: widget.threadRepository,
                                    ),
                                  );
                                }),
                              ).then((value) {
                                if (isCommentPosted) {
                                  BlocProvider.of<ThreadBloc>(context)
                                      .add(FetchThreads());
                                  BlocProvider.of<ThreadOfUserBloc>(context)
                                      .add(FetchThreadsOfUser());
                                  isCommentPosted = false;
                                }
                              }),
                              child: listThread(state.threads[index]),
                            );
                          },
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
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
