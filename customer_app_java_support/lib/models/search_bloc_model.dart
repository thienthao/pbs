import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:equatable/equatable.dart';

class SearchModel extends Equatable {
  final List<Photographer> photographers;
  final List<PackageBlocModel> packages;

  SearchModel({this.photographers, this.packages});

  @override
  List<Object> get props => [photographers, packages];
}
