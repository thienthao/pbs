import 'dart:io';

import 'package:customer_app_java_support/models/customer_bloc_model.dart';
import 'package:customer_app_java_support/respositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  CustomerBloc({
    @required this.customerRepository,
  })  : assert(customerRepository != null),
        super(CustomerStateLoading());

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent customerEvent) async* {
    if (customerEvent is CustomerEventProfileFetch) {
      if (state is CustomerStateUpdatedAvatarSuccess) {
        yield CustomerStateLoading();
      }
      yield* _mapFetchCustomerProfileToState(customerEvent.cusId);
    } else if (customerEvent is CustomerEventUpdateProfile) {
      yield* _mapUpdatedProfileToState(customerEvent.customer);
    } else if (customerEvent is CustomerEventUpdateAvatar) {
      yield* _mapUpdateAvatarToState(customerEvent.cusId, customerEvent.image);
    } else if (customerEvent is CustomerEventChangePassword) {
      yield* _mapChangePassword(customerEvent.username,
          customerEvent.oldPassword, customerEvent.newPassword);
    } else if (customerEvent is CustomerEventRecoveryPassword) {
      yield* _mapRecoverPassword(customerEvent.email);
    }
  }

  Stream<CustomerState> _mapFetchCustomerProfileToState(int id) async* {
    try {
      final customer = await this.customerRepository.getProfileById(id);
      yield CustomerStateFetchedProfileSuccess(customer: customer);
    } catch (_) {
      yield CustomerStateFailure(error: _.toString());
    }
  }

  Stream<CustomerState> _mapUpdatedProfileToState(
      CustomerBlocModel customer) async* {
    yield CustomerStateLoading();
    try {
      final isSuccess = await this.customerRepository.updateProfile(customer);
      yield CustomerStateUpdatedProfileSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield CustomerStateFailure(error: _.toString());
    }
  }

  Stream<CustomerState> _mapUpdateAvatarToState(int id, File image) async* {
    try {
      final isSuccess = await this.customerRepository.updateAvatar(id, image);
      yield CustomerStateUpdatedAvatarSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield CustomerStateFailure(error: _.toString());
    }
  }

  Stream<CustomerState> _mapChangePassword(
      String username, String oldPassword, String newPassword) async* {
    yield CustomerStateLoading();
    try {
      final isSuccess = await this
          .customerRepository
          .changePassword(username, oldPassword, newPassword);
      yield CustomerStateChangedPasswordSuccess(isSuccess: isSuccess);
    } catch (error) {
      yield CustomerStateChangePasswordFailure(error: error);
    }
  }

  Stream<CustomerState> _mapRecoverPassword(String email) async* {
    yield CustomerStateLoading();
    try {
      final isSuccess = await this.customerRepository.recoverPassword(email);
      yield CustomerStateRecoveryPasswordSuccess(isSuccess: isSuccess);
    } catch (_) {
      yield CustomerStateFailure(error: _.toString());
    }
  }
}
