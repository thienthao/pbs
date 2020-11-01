import 'package:customer_app_1_11/models/album_bloc_model.dart';
import 'package:equatable/equatable.dart';

class CommentBlocModel extends Equatable {
  final String username;
  final String fullname;
  final String comment;
  final double rating;
  final String avatar;
  final String createdAt;
  final String location;

  CommentBlocModel({
    this.username,
    this.fullname,
    this.comment,
    this.avatar,
    this.rating,
    this.createdAt,
    this.location,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        username,
        fullname,
        comment,
        avatar,
        rating,
        createdAt,
        location,
      ];

  factory CommentBlocModel.fromJson(dynamic jsonObject) {
    return CommentBlocModel(
      username: 'username' ?? 'photographer name',
      fullname: 'fullname' ?? '',
      comment: 'comment' ?? DateTime.october,
      avatar: 'avatar' ?? 'avatar link',
      rating: 'rating' ?? 4.0,
      location: 'location' ?? false,
      createdAt: 'createdAt' ?? DateTime.october,
    );
  }
}
