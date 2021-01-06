import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:photographer_app_java_support/models/comment_bloc_model.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentStateLoading extends CommentState {}

class CommentStateSuccess extends CommentState {
  final List<CommentBlocModel> comments;
  const CommentStateSuccess({@required this.comments})
      : assert(comments != null);
  @override
  List<Object> get props => [comments];

  @override
  String toString() => 'CommentsLoadSuccess { Comment: $comments }';
}

class CommentStateFailure extends CommentState {
  final String error;
  CommentStateFailure({
    this.error,
  });
}
