
import 'package:capstone_mock_1/respositories/category_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryBloc({
    @required this.categoryRepository,
  })  : assert(categoryRepository != null),
        super(CategoryStateLoading());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent categoryEvent) async* {
    if (categoryEvent is CategoryEventFetch) {
      final categories = await categoryRepository.getListCategory();
      yield CategoryStateSuccess(categories: categories);
      yield* _mapCategoriesLoadedToState();
    } else if (categoryEvent is CategoryEventLoadSuccess) {
      yield* _mapCategoriesLoadedToState();
    } else if (categoryEvent is CategoryEventRequested) {
      yield* _mapCategoriesLoadedToState();
    } else if (categoryEvent is CategoryEventRefresh) {
      yield* _mapCategoriesLoadedToState();
    }
  }

  Stream<CategoryState> _mapCategoriesLoadedToState() async* {
    try {
      final categories = await this.categoryRepository.getListCategory();
      yield CategoryStateSuccess(categories: categories);
    } catch (_) {
      yield CategoryStateFailure();
    }
  }
}
