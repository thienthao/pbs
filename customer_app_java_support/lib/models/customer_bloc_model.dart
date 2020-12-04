import 'package:equatable/equatable.dart';

class CustomerBlocModel extends Equatable {
  final int id;
  final String username;
  final String fullname;
  final String description;
  final String avatar;
  final String phone;
  final String email;

  CustomerBlocModel(
      {this.id,
      this.username,
      this.fullname,
      this.description,
      this.avatar,
      this.phone,
      this.email});

  @override
  List<Object> get props =>
      [id, username, fullname, description, avatar, phone, email];
}
