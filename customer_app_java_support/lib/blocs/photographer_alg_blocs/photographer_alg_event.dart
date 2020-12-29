import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class PhotographerAlgEvent extends Equatable {
  const PhotographerAlgEvent();

  @override
  List<Object> get props => [];
}

class PhotographerAlgEventFetch extends PhotographerAlgEvent {
  final int categoryId;
  

  PhotographerAlgEventFetch({this.categoryId});
}

class PhotographerAlgEventFetchByFactorAlg extends PhotographerAlgEvent {
  final LatLng latLng;
  final int category;
   final String city;
  PhotographerAlgEventFetchByFactorAlg({this.latLng, this.category, this.city});
}
