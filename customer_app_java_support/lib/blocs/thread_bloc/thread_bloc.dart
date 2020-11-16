

import 'package:customer_app_java_support/blocs/thread_bloc/thread_event.dart';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_state.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:customer_app_java_support/respositories/thread_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThreadBloc extends Bloc<ThreadEvent, ThreadState> {
  final ThreadRepository repository;

  ThreadBloc({@required this.repository}) : super(ThreadEmpty());

  @override
  Stream<ThreadState> mapEventToState(ThreadEvent event) async* {
    if (event is FetchThreads) {
      yield ThreadLoading();
      try {
        final List<Thread> threads = await repository.all();
        yield ThreadLoaded(threads: threads);
      } catch(_) {
        yield ThreadError();
      }
    }
    print("vo bloc");

    if (event is PostThread) {
      yield ThreadLoading();
      try {
        print("vo post thread");
        bool success = await repository.postThread(event.thread);
        if(success) {
          yield ThreadSuccess();
        } else {
          yield ThreadError();
        }
      } catch(e) {
        print(e.toString());
        yield ThreadError();
      }
    }
  }
}