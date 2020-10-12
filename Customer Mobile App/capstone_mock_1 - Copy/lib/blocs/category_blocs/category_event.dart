
import 'package:capstone_mock_1/models/category_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryEventFetch extends CategoryEvent {}

class CategoryEventLoadSuccess extends CategoryEvent {
  CategoryEventLoadSuccess(List<CategoryBlocModel> list);
}

class CategoryEventRequested extends CategoryEvent {
  final CategoryBlocModel category;
  CategoryEventRequested({
    @required this.category,
  }) : assert(category != null);
  @override
  List<Object> get props => [category];
}

class CategoryEventRefresh extends CategoryEvent {
  final CategoryBlocModel category;
  CategoryEventRefresh({
    @required this.category,
  }) : assert(category != null);
  @override
  List<Object> get props => [category];
}
