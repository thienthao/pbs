import 'package:customer_app_java_support/models/comment_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

class CommentStatePostedSuccess extends CommentState {
  final bool isPostedSuccess;
  CommentStatePostedSuccess({this.isPostedSuccess});
}

class CommentStateFailure extends CommentState {}
