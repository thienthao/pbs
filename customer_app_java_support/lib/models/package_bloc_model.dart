import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/service_bloc_model.dart';
import 'package:equatable/equatable.dart';

class PackageBlocModel extends Equatable {
  final int id;
  final String name;
  final int price;
  final String description;
  final bool supportMultiDays;
  final int timeAnticipate;
  final List<ServiceBlocModel> serviceDtos;
  final Photographer photographer;

  const PackageBlocModel(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.supportMultiDays,
      this.timeAnticipate,
      this.serviceDtos,
      this.photographer});

  @override
  List<Object> get props => [id, name, description, price, serviceDtos];

  factory PackageBlocModel.fromJson(dynamic jsonObject) {
    return PackageBlocModel(
      id: 'id' ?? 1,
      name: 'name' ?? 'album name',
      price: 'price' ?? 5,
      description: 'description' ?? 'test desc',
      serviceDtos: 'serviceDtos' ?? [],
    );
  }

  toMap() {}

  static fromMap(map) {}
}
