import 'package:customer_app_java_support/blocs/thread_bloc/thread_event.dart';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_state.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:customer_app_java_support/respositories/thread_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThreadOfUserBloc extends Bloc<ThreadEvent, ThreadState> {
  final ThreadRepository repository;

  ThreadOfUserBloc({@required this.repository}) : super(ThreadEmpty());

  @override
  Stream<ThreadState> mapEventToState(ThreadEvent event) async* {
    if (event is FetchThreadsOfUser) {
      yield ThreadLoading();
      try {
        final List<Thread> threads = await repository.threadsByUser();
        yield ThreadLoaded(threads: threads);
      } catch (e) {
        yield ThreadError(error: e.toString());
      }
    }
  }
}
