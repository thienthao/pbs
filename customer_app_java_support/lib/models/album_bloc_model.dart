import 'package:customer_app_java_support/models/category_bloc_model.dart';
import 'package:customer_app_java_support/models/image_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:equatable/equatable.dart';

class AlbumBlocModel extends Equatable {
  final int id;
  final String name;
  final String thumbnail;
  final String location;
  final String description;
  final String createdAt;
  final bool isActive;
  final Photographer photographer;
  final int likes;
  final CategoryBlocModel category;
  final List<ImageBlocModel> images;

  const AlbumBlocModel(
      {this.id,
      this.name,
      this.location,
      this.thumbnail,
      this.description,
      this.createdAt,
      this.isActive,
      this.images,
      this.likes,
      this.category,
      this.photographer});

  @override
  List<Object> get props => [
        id,
        name,
        location,
        thumbnail,
        description,
        createdAt,
        isActive,
        images,
        category,
        likes,
        photographer
      ];

  factory AlbumBlocModel.fromJson(dynamic jsonObject) {
    return AlbumBlocModel(
        id: 'id' ?? 1,
        name: 'name' ?? 'album name',
        location: 'location' ?? 'album location',
        description: 'description' ?? 'test desc',
        thumbnail: 'thumbnail' ?? '',
        createdAt: 'createAt' ?? DateTime.october,
        isActive: 'isActive' ?? true,
        likes: 'likes' ?? 0,
        images: 'images' ?? [],
        photographer: 'photographer' ?? false,
        category: 'category' ?? false);
  }
}
