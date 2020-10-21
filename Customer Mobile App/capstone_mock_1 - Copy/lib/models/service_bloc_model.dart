import 'package:capstone_mock_1/models/category_bloc_model.dart';
import 'package:capstone_mock_1/models/photographer_bloc_model.dart';
import 'package:equatable/equatable.dart';

class ServiceBlocModel extends Equatable {
  final int id;
  final String name;
  final String description;


  const ServiceBlocModel(
      {this.id,
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
