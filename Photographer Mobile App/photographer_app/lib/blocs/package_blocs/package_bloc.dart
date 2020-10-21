import 'package:photographer_app/respositories/package_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package_event.dart';
import 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final PackageRepository packageRepository;
  PackageBloc({
    @required this.packageRepository,
  })  : assert(packageRepository != null),
        super(PackageStateLoading());

  @override
  Stream<PackageState> mapEventToState(PackageEvent packageEvent) async* {
    if (packageEvent is PackageEventFetch) {
    } else if (packageEvent is PackageByPhotographerIdEventFetch) {
      yield* _mapPackagesByPhotographerIdLoadedToState(packageEvent.id);
    } else if (packageEvent is PackageEventLoadSuccess) {
    } else if (packageEvent is PackageEventRequested) {
    } else if (packageEvent is PackageEventRefresh) {}
  }

  Stream<PackageState> _mapPackagesByPhotographerIdLoadedToState(
      int id) async* {
    try {
      final packages =
          await this.packageRepository.getPackagesByPhotographerId(id);
      yield PackageStateSuccess(packages: packages);
    } catch (_) {
      yield PackageStateFailure();
    }
  }
}
