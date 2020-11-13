

import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TopicState extends Equatable {
  const TopicState();

  @override
  List<Object> get props => [];
}

class TopicEmpty extends TopicState{}

class TopicLoading extends TopicState {}

class TopicLoaded extends TopicState {
  final List<Topic> topics;

  const TopicLoaded({@required this.topics}) : assert(topics != null);

  @override
  List<Object> get props => [topics];
}

class TopicError extends TopicState {}