import 'package:equatable/equatable.dart';

abstract class PhotographerAlgEvent extends Equatable {
  const PhotographerAlgEvent();

  @override
  List<Object> get props => [];
}

class PhotographerAlgEventFetch extends PhotographerAlgEvent {
  final int categoryId;

  PhotographerAlgEventFetch({this.categoryId});
}


class PhotographerAlgEventFetchByFactorAlg extends PhotographerAlgEvent {}

