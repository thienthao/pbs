import 'package:capstone_mock_1/models/category_bloc_model.dart';
import 'package:capstone_mock_1/models/photographer_bloc_model.dart';
import 'package:capstone_mock_1/models/service_bloc_model.dart';
import 'package:equatable/equatable.dart';

class PackageBlocModel extends Equatable {
  final int id;
  final String name;
  final int price;
  final String description;
  final List<ServiceBlocModel> serviceDtos;

  const PackageBlocModel(
      {this.id, this.name, this.description, this.price, this.serviceDtos});

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
