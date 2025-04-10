import 'package:equatable/equatable.dart';

abstract class MyrideState extends Equatable {
  const MyrideState();

  @override
  List<Object?> get props => [];
}

class MyrideInitial extends MyrideState {}

class MyrideLoading extends MyrideState {}

class MyrideLoaded extends MyrideState {
  final List<dynamic> rideBookings; // Replace `dynamic` with your booking model type


  const MyrideLoaded({
    required this.rideBookings,
   
  });

  @override
  List<Object> get props => [rideBookings];
}

class MyrideError extends MyrideState {}
