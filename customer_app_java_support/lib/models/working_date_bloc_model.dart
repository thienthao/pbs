import 'package:equatable/equatable.dart';

class WorkingDayBlocModel extends Equatable {
  final int id;
  final int day;
  final String startTime;
  final String endTime;
  final bool workingDay;

  WorkingDayBlocModel(
      {this.id, this.day, this.startTime, this.endTime, this.workingDay});

  List<Object> get props => throw UnimplementedError();
}
