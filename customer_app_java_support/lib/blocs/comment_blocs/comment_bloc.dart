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
    } else if (commentEvent is CommentEventLoadSuccess) {
    } else if (commentEvent is CommentEventRequested) {
    } else if (commentEvent is CommentEventRefresh) {}
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
}
