import 'package:equatable/equatable.dart';

abstract class MyrideEvent extends Equatable {
  const MyrideEvent();

  @override
  List<Object> get props => [];
}

class FetchMyRides extends MyrideEvent {
  const FetchMyRides(); // No params
}
