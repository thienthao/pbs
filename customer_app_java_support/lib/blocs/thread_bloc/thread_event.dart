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

class PostThread extends ThreadEvent {
  final Thread thread;

  PostThread({@required this.thread});

  @override
  List<Object> get props => [thread];
}

class PostComment extends ThreadEvent {
  final ThreadComment threadComment;

  PostComment({@required this.threadComment});

  @override
  List<Object> get props => [threadComment];
}
