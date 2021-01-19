import 'package:equatable/equatable.dart';

class TimeAndLocationBlocModel extends Equatable {
  final int id;
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String start;
  final String end;
  final bool isCheckin;
  final String qrCheckinCode;

  TimeAndLocationBlocModel(
      {this.id,
      this.latitude,
      this.longitude,
      this.formattedAddress,
      this.start,
      this.end,
      this.isCheckin,
      this.qrCheckinCode});

  @override
  List<Object> get props => [];
}
