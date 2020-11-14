import 'package:equatable/equatable.dart';

class CalendarModel extends Equatable {
  final List<String> busyDays;
  final List<String> bookedDays;

  CalendarModel({this.busyDays, this.bookedDays});

  @override
  List<Object> get props => [busyDays, bookedDays];

  @override
  String toString() {
    return super.toString();
  }
}
