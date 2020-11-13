

import 'package:equatable/equatable.dart';

abstract class TopicEvent extends Equatable {
  TopicEvent();
}

class FetchTopics extends TopicEvent {
  FetchTopics();

  @override
  List<Object> get props => [];
}