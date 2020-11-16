import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/package_repository.dart';
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
    } else if (packageEvent is PackageEventCreate) {
      yield* _mapPackageCreatedtoState(packageEvent.package);
    } else if (packageEvent is PackageEventUpdate) {
      yield* _mapPackageUpdatedtoState(packageEvent.package);
    } else if (packageEvent is PackageEventDelete) {
      yield* _mapPackageDeletedtoState(packageEvent.package);
    } else if (packageEvent is PackageEventLoadSuccess) {
    } else if (packageEvent is PackageEventRequested) {
    } else if (packageEvent is PackageEventRefresh) {}
  }

  Stream<PackageState> _mapPackagesByPhotographerIdLoadedToState(
      int id) async* {
    yield PackageStateLoading();
    try {
      final packages =
          await this.packageRepository.getPackagesByPhotographerId(id);
      yield PackageStateSuccess(packages: packages);
    } catch (_) {
      yield PackageStateFailure();
    }
  }

  Stream<PackageState> _mapPackageCreatedtoState(
      PackageBlocModel package) async* {
    yield PackageStateLoading();
    try {
      final isSuccess = await this.packageRepository.createPackage(package);
      yield PackageStateCreatedSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield PackageStateFailure();
    }
  }

  Stream<PackageState> _mapPackageUpdatedtoState(
      PackageBlocModel package) async* {
    yield PackageStateLoading();
    try {
      final isSuccess = await this.packageRepository.updatePackage(package);
      yield PackageStateUpdatedSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield PackageStateFailure();
    }
  }

  Stream<PackageState> _mapPackageDeletedtoState(
      PackageBlocModel package) async* {
    try {
      final isSuccess = await this.packageRepository.deletePackage(package);
      yield PackageStateDeletedSuccess(isSuccess: isSuccess);
    } catch (error) {
      yield PackageStateFailure(error: error.toString());
    }
  }
}
