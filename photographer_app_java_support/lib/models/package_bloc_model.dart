import 'package:photographer_app_java_support/models/category_bloc_model.dart';
import 'package:photographer_app_java_support/models/service_bloc_model.dart';
import 'package:equatable/equatable.dart';

class PackageBlocModel extends Equatable {
  final int id;
  final String name;
  final int price;
  final String description;
  final bool supportMultiDays;
  final int timeAnticipate;
  final List<ServiceBlocModel> serviceDtos;
  final CategoryBlocModel category;

  const PackageBlocModel(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.supportMultiDays,
      this.timeAnticipate,
      this.serviceDtos,
      this.category});

  @override
  List<Object> get props => [id, name, description, price, serviceDtos];
}
