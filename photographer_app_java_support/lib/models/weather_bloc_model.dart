import 'package:equatable/equatable.dart';

class WeatherBlocModel extends Equatable {
  final String noti;
  final String outlook;
  final double temperature;
  final double humidity;
  final double windSpeed;

  WeatherBlocModel({
    this.noti,
    this.outlook,
    this.temperature,
    this.humidity,
    this.windSpeed,
  });
  
  @override
  List<Object> get props => [];
}
