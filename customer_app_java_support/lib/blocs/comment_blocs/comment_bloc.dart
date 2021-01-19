import 'package:customer_app_java_support/models/comment_bloc_model.dart';
import 'package:customer_app_java_support/respositories/comment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;
  CommentBloc({
    @required this.commentRepository,
  })  : assert(commentRepository != null),
        super(CommentStateLoading());

  @override
  Stream<CommentState> mapEventToState(CommentEvent commentEvent) async* {
    if (commentEvent is CommentEventFetch) {
    } else if (commentEvent is CommentByPhotographerIdEventFetch) {
      yield* _mapCommentsByPhotographerIdLoadedToState(commentEvent.id);
    } else if (commentEvent is CommentByBookingIdEventFetch) {
      yield* _mapCommentsByBookingIdLoadedToState(commentEvent.id);
    } else if (commentEvent is CommentEventPost) {
      yield* _mapPostCommentToState(commentEvent.comment);
    }
  }

  Stream<CommentState> _mapCommentsByPhotographerIdLoadedToState(
      int id) async* {
    try {
      final comments =
          await this.commentRepository.getCommentByPhotographerId(id);
      yield CommentStateSuccess(comments: comments);
    } catch (_) {
      yield CommentStateFailure();
    }
  }

  Stream<CommentState> _mapCommentsByBookingIdLoadedToState(int id) async* {
    yield CommentStateLoading();
    try {
      final comments = await this.commentRepository.getCommentByBookingId(id);
      yield CommentStateSuccess(comments: comments);
    } catch (_) {
      yield CommentStateFailure();
    }
  }

  Stream<CommentState> _mapPostCommentToState(CommentBlocModel comment) async* {
    try {
      final isPostedSuccess = await this.commentRepository.postComment(comment);
      yield CommentStatePostedSuccess(isPostedSuccess: isPostedSuccess);
    } catch (_) {
      yield CommentStateFailure();
    }
  }
}
