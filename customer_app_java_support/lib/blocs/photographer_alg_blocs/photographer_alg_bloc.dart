import 'package:customer_app_java_support/blocs/photographer_alg_blocs/photographers_alg.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PhotographerAlgBloc
    extends Bloc<PhotographerAlgEvent, PhotographerAlgState> {
  static const NUMBER_OF_PHOTOGRAPHERS_PER_PAGE = 10;
  final PhotographerRepository photographerRepository;
  PhotographerAlgBloc({
    @required this.photographerRepository,
  })  : assert(PhotographerRepository != null),
        super(PhotographerAlgStateLoading());

  @override
  Stream<PhotographerAlgState> mapEventToState(
      PhotographerAlgEvent photographerEvent) async* {
    if (photographerEvent is PhotographerAlgEventFetchByFactorAlg) {
      yield* _mapPhotographersFetchByFactorAlgToState(photographerEvent.latLng,
          photographerEvent.category, photographerEvent.city);
    }
  }

  Stream<PhotographerAlgState> _mapPhotographersFetchByFactorAlgToState(
      LatLng latLng, int category, String city) async* {
    yield PhotographerAlgStateLoading();
    try {
      final photographers = await this
          .photographerRepository
          .getListPhotographerByFactorAlg(latLng, category, city);
      yield PhotographerAlgStateSuccess(photographers: photographers);
    } catch (_) {
      yield PhotographerAlgStateFailure();
    }
  }
}
