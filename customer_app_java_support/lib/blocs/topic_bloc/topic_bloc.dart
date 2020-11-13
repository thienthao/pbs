

import 'package:customer_app_java_support/blocs/topic_bloc/topic_event.dart';
import 'package:customer_app_java_support/blocs/topic_bloc/topic_state.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:customer_app_java_support/respositories/topic-repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final TopicRepository repository;

  TopicBloc({@required this.repository}) : super(TopicEmpty());

  @override
  Stream<TopicState> mapEventToState(TopicEvent event) async* {
    if(event is FetchTopics) {
      yield TopicLoading();
      try {
        final List<Topic> topics = await repository.all();
        yield TopicLoaded(topics: topics);
      } catch(e) {
        print(e.toString());
        yield TopicError();
      }
    }
  }
}