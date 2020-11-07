import 'package:equatable/equatable.dart';

class CategoryBlocModel extends Equatable {
  final int id;
  final String category;
  final String iconLink;

  CategoryBlocModel({this.id, this.category, this.iconLink});

  @override
  List<Object> get props => [id, category, iconLink];

  factory CategoryBlocModel.fromJson(dynamic jsonObject) {
    return CategoryBlocModel(
      id: 'id' ?? 1,
      category: 'category' ?? 'category',
      iconLink: 'iconLink' ?? 'iconLink',
    );
  }
}
