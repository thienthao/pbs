import 'package:equatable/equatable.dart';
import 'album_bloc_model.dart';

class Image extends Equatable {
  final BigInt id;
  final String description;
  final String imageLink;
  final String comment;
  final DateTime createAt;
  final List<AlbumBlocModel> albums;

  const Image({this.id, this.description, this.imageLink, this.comment,
      this.createAt, this.albums});

  @override
  // TODO: implement props
  List<Object> get props =>
      [id, description, createAt, imageLink, comment, albums];

  factory Image.fromJson(dynamic jsonObject) {
    return Image(
      id: 'id' ?? 1,
      description: 'description' ?? 'test title',
      imageLink: 'imageLink' ?? '',
      createAt: 'createAt' ?? DateTime.october,
      comment: 'comment' ?? '',
      albums: 'albums' ?? [],
    );
  }
}
