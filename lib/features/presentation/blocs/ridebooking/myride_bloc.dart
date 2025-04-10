import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:caps_book/features/data/model/rideBooking_model.dart';
import 'package:meta/meta.dart';

part 'myride_event.dart';
part 'myride_state.dart';

class MyrideBloc extends Bloc<MyrideEvent, MyrideState> {
  List<RideBookingModel> rideBookings = [
    RideBookingModel(
      customerName: 'Saravanan',
      dateTime: DateTime(2025, 5, 15, 10, 15),
      pickupAddress: 'kalakkad',
      dropAddress: 'Kaniyakumari',
      bookingType: 'Completed Ride',
      vehicleName: "Car",
      vehicleNumber: "TN 72 0134"
    ),
    RideBookingModel(
      customerName: 'Raja',
      dateTime: DateTime(2025, 5, 15, 10, 15),
      pickupAddress: 'Mavadi',
      dropAddress: 'Kalakkad',
      bookingType: 'Pending Ride',
      vehicleName: "Hero",
      vehicleNumber: "TN 69 8934"
    ),
  ];

  MyrideBloc() : super(MyrideInitial()) {
    on<FetchBookingEvent>((event, emit) async {
      try {
        emit(MyrideLoading());
        await Future.delayed(const Duration(seconds: 2)); // Simulate API delay

        // Show Pending Rides initially
        final filteredPending = rideBookings
            .where((booking) => booking.bookingType == "Pending Ride")
            .toList();

        emit(MyrideLoaded(filteredPending, "Pending Ride"));
      } catch (e) {
        emit(MyrideError('Failed to Load Bookings'));
      }
    });

    on<SelectCategory>(_selectCategory);
  }

  void _selectCategory(SelectCategory event, Emitter<MyrideState> emit) {
    final filtered = rideBookings
        .where((ride) => ride.bookingType == event.category)
        .toList();

    emit(MyrideLoaded(filtered, event.category));
  }
}
