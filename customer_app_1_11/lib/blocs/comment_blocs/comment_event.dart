import 'package:customer_app_1_11/models/comment_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class CommentEventFetch extends CommentEvent {}

class CommentByPhotographerIdEventFetch extends CommentEvent {
  final int id;
  CommentByPhotographerIdEventFetch({@required this.id});
}

class CommentEventLoadSuccess extends CommentEvent {
  CommentEventLoadSuccess(List<CommentBlocModel> list);
}

class CommentEventRequested extends CommentEvent {
  final CommentBlocModel comment;
  CommentEventRequested({
    @required this.comment,
  }) : assert(comment != null);
  @override
  List<Object> get props => [comment];
}

class CommentEventRefresh extends CommentEvent {
  final CommentBlocModel comment;
  CommentEventRefresh({
    @required this.comment,
  }) : assert(comment != null);
  @override
  List<Object> get props => [comment];
}
