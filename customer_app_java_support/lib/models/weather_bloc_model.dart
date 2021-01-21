import 'package:equatable/equatable.dart';

class WeatherBlocModel extends Equatable {
  final String noti;
  final String outlook;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final bool overall;
  final bool isHourly;
  final String location;
  final String date;
  final bool isSuitable;
  final Map<String,dynamic> time;
  WeatherBlocModel(
      {this.noti,
      this.outlook,
      this.temperature,
      this.humidity,
      this.windSpeed,
      this.overall,
      this.isHourly,
      this.location,
      this.date,
      this.isSuitable,
      this.time});

  @override
  List<Object> get props => [];
}
