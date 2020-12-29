import 'package:equatable/equatable.dart';
import 'album_bloc_model.dart';

class ImageBlocModel extends Equatable {
  final int id;
  final String description;
  final String imageLink;
  final String comment;
  final DateTime createAt;
  final List<AlbumBlocModel> albums;

  const ImageBlocModel(
      {this.id,
      this.description,
      this.imageLink,
      this.comment,
      this.createAt,
      this.albums});

  @override
  List<Object> get props =>
      [id, description, createAt, imageLink, comment, albums];

  factory ImageBlocModel.fromJson(dynamic jsonObject) {
    return ImageBlocModel(
      id: 'id' ?? 1,
      description: 'description' ?? 'test title',
      imageLink: 'imageLink' ?? '',
      createAt: 'createAt' ?? DateTime.october,
      comment: 'comment' ?? '',
      albums: 'albums' ?? [],
    );
  }
}
