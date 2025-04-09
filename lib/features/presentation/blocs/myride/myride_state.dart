part of 'myride_bloc.dart';

@immutable
abstract class MyrideState {}

class MyrideInitial extends MyrideState {}

class MyrideLoading extends MyrideState {}

class MyrideLoaded extends MyrideState {
 final List<RideBookingModel> rideBookings;
 final String bookingCategory;
 MyrideLoaded(this.rideBookings, this.bookingCategory);
}

class MyrideError extends MyrideState {
  final String message;
  MyrideError(this.message);
}
