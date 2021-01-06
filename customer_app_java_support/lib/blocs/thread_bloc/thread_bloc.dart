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
      } catch (e) {
        yield ThreadError(error: e.toString());
      }
    }

    if (event is PostThread) {
      yield ThreadLoading();
      try {
        bool success = await repository.postThread(event.thread);
        if (success) {
          yield ThreadSuccess();
        } else {
          yield ThreadError();
        }
      } catch (e) {
        yield ThreadError(error: e.toString());
      }
    }

    if (event is EditThread) {
      yield ThreadLoading();
      try {
        bool success = await repository.editThread(event.thread);

        if (success) {
          yield ThreadSuccess();
        } else {
          yield ThreadError();
        }
      } catch (e) {
        yield ThreadError(error: e.toString());
      }
    }

    if (event is DeleteThread) {
      yield ThreadLoading();
      try {
        bool success = await repository.deleteThread(event.id);
        if (success) {
          yield ThreadSuccess();
        } else {
          yield ThreadError();
        }
      } catch (e) {
        yield ThreadError(error: e.toString());
      }
    }

    if (event is PostComment) {
      yield ThreadLoading();
      try {
        bool success = await repository.postComment(event.threadComment);
        if (success) {
          yield CommentSuccess();
        } else {
          yield CommentFailure();
        }
      } catch (e) {
        yield ThreadError(error: e.toString());
      }
    }
  }
}
