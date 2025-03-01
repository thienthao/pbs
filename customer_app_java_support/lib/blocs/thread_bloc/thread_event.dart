import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ThreadEvent extends Equatable {
  ThreadEvent();
}

class FetchThreads extends ThreadEvent {
  FetchThreads();
  @override
  List<Object> get props => [];
}

class FetchThreadsOfUser extends ThreadEvent {
  FetchThreadsOfUser();
  @override
  List<Object> get props => [];
}

class PostThread extends ThreadEvent {
  final Thread thread;

  PostThread({@required this.thread});

  @override
  List<Object> get props => [thread];
}

class EditThread extends ThreadEvent {
  final Thread thread;
  EditThread({@required this.thread});
  @override
  List<Object> get props => [thread];
}

class DeleteThread extends ThreadEvent {
  final int id;
  DeleteThread({@required this.id});
  @override
  List<Object> get props => [id];
}

class PostComment extends ThreadEvent {
  final ThreadComment threadComment;

  PostComment({@required this.threadComment});

  @override
  List<Object> get props => [threadComment];
}
