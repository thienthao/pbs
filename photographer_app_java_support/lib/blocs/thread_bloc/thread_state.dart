import 'package:photographer_app_java_support/models/thread_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ThreadState extends Equatable {
  const ThreadState();

  @override
  List<Object> get props => [];
}

class ThreadEmpty extends ThreadState {}

class ThreadLoading extends ThreadState {}

class ThreadLoaded extends ThreadState {
  final List<Thread> threads;

  const ThreadLoaded({@required this.threads}) : assert(threads != null);

  @override
  List<Object> get props => [threads];
}

class ThreadPost extends ThreadState {
  final Thread thread;

  const ThreadPost({@required this.thread}) : assert(thread != null);
}

class ThreadSuccess extends ThreadState {}

class ThreadError extends ThreadState {}

class CommentSuccess extends ThreadState {}

class CommentFailure extends ThreadState {}
