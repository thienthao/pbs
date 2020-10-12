import 'package:capstone_mock_1/models/album_bloc_model.dart';
import 'package:equatable/equatable.dart';

class Photographer extends Equatable {
  final int id;
  final String username;
  final String fullname;
  final String description;
  final String avatar;
  final String phone;
  final double ratingCount;
  final bool isBlocked;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;
  final List<AlbumBlocModel> albums;

  Photographer(
      {this.id,
      this.username,
      this.fullname,
      this.description,
      this.avatar,
      this.phone,
      this.ratingCount,
      this.isBlocked,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.password,
      this.albums});

  @override
  // TODO: implement props
  List<Object> get props => [
        id,
        username,
        password,
        fullname,
        description,
        avatar,
        phone,
        ratingCount,
        isBlocked,
        isDeleted,
        createdAt,
        updatedAt,
        albums
      ];

  factory Photographer.fromJson(dynamic jsonObject) {
    return Photographer(
      id: 'id' ?? 1,
      username: 'username' ?? 'photographer name',
      fullname: 'fullname' ?? '',
      description: 'description' ?? DateTime.october,
      avatar: 'avatar' ?? 'avatar link',
      phone: 'phone' ?? 'phone link',
      ratingCount: 'ratingCount' ?? 4.0,
      isBlocked: 'isBlocked' ?? false,
      isDeleted: 'isDeleted' ?? false,
      createdAt: 'createdAt' ?? DateTime.october,
      updatedAt: 'updatedAt' ?? DateTime.october,
      albums: 'albums' ?? [],
    );
  }
}
