import 'package:bloc/bloc.dart';
import 'package:caps_book/features/data/repositories/ride_boking_repository.dart';
import 'package:caps_book/features/presentation/blocs/ridebooking/myride_event.dart';
import 'package:caps_book/features/presentation/blocs/ridebooking/myride_state.dart';


  class MyrideBloc extends Bloc<MyrideEvent, MyrideState> {
  final RideRepository rideRepository;

  MyrideBloc(this.rideRepository) : super(MyrideInitial()) {
    on<FetchMyRides>((event, emit) async {
      emit(MyrideLoading());
      try {
        final bookings = await rideRepository.fetchBookings();

        // ✅ Debug Print: Check the data
        for (var booking in bookings) {
          print('🚕 Booking ID: ${booking.customerName}, Pickup: ${booking.bookingType}, Drop: ${booking.vehicleName}');
        }

        emit(MyrideLoaded(rideBookings: bookings));
      } catch (e) {
        print('❌ Error fetching bookings: $e');
        emit(MyrideError());
      }
    });
  }
}
