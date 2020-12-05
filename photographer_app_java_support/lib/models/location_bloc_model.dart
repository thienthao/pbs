import 'package:equatable/equatable.dart';

class LocationBlocModel extends Equatable {
  final int id;
  final String formattedAddress;
  final double latitude;
  final double longitude;

  LocationBlocModel(
      {this.id, this.formattedAddress, this.latitude, this.longitude});
  @override
  List<Object> get props => [id, formattedAddress, latitude, longitude];
}
