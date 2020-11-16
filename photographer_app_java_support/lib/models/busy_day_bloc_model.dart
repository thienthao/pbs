import 'package:equatable/equatable.dart';

class BusyDayBlocModel extends Equatable {
  final int id;
  final String description;
  final String startDate;
  final String endDate;
  final String title;

  BusyDayBlocModel({
    this.id,
    this.description,
    this.startDate,
    this.endDate,
    this.title,
  });

  List<Object> get props => throw UnimplementedError();
}
