import 'package:customer_app_java_support/blocs/photographer_alg_blocs/photographers_alg.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographer_event.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographer_state.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      yield* _mapPhotographersFetchByFactorAlgToState();
    }
  }

  Stream<PhotographerAlgState>
      _mapPhotographersFetchByFactorAlgToState() async* {
    yield PhotographerAlgStateLoading();
    try {
      final photographers =
          await this.photographerRepository.getListPhotographerByFactorAlg();
      yield PhotographerAlgStateSuccess(photographers: photographers);
    } catch (_) {
      yield PhotographerAlgStateFailure();
    }
  }
}
