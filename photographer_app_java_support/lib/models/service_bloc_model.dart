import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ServiceBlocModel extends Equatable {
  final int id;
  String name;
  final String description;

  ServiceBlocModel({
    this.id,
    this.name,
    this.description,
  });

  @override
  List<Object> get props => [
        id,
        name,
        description,
      ];

  factory ServiceBlocModel.fromJson(dynamic jsonObject) {
    return ServiceBlocModel(
      id: 'id' ?? 1,
      name: 'name' ?? 'service name',
      description: 'description' ?? 'Desc of service',
    );
  }
}
