
import 'package:photographer_app/models/category_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryStateLoading extends CategoryState {}

class CategoryStateSuccess extends CategoryState {
  final List<CategoryBlocModel> categories;
  const CategoryStateSuccess({@required this.categories}) : assert(categories != null);
  @override
  List<Object> get props => [categories];

  @override
  String toString() => 'CategorysLoadSuccess { album: $categories }';
}

class CategoryStateFailure extends CategoryState {}
