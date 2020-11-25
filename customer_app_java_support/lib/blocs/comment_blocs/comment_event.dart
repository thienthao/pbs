import 'package:customer_app_java_support/models/comment_bloc_model.dart';
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

class CommentEventPost extends CommentEvent {
  final CommentBlocModel comment;
  CommentEventPost({this. comment});
}
