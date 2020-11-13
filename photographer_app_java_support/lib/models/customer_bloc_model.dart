import 'package:equatable/equatable.dart';

class CustomerBlocModel extends Equatable {
  final int id;
  final String username;
  final String fullname;
  final String description;
  final String avatar;
  final String cover;
  final String phone;
  final String email;

  CustomerBlocModel(
      {this.id,
      this.username,
      this.fullname,
      this.description,
      this.avatar,
      this.cover,
      this.phone,
      this.email});

  @override
  // TODO: implement props
  List<Object> get props =>
      [id, username, fullname, description, avatar, cover, phone, email];

  factory CustomerBlocModel.fromJson(dynamic jsonObject) {
    return CustomerBlocModel(
        id: 'id' ?? 1,
        username: 'username' ?? 'photographer name',
        fullname: 'fullname' ?? '',
        description: 'description' ?? DateTime.october,
        avatar: 'avatar' ?? 'avatar link',
        cover: 'cover' ?? 'avatar link',
        phone: 'phone' ?? 'phone link',
        email: 'email' ?? 'email');
  }
}
