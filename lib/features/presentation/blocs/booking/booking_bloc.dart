import 'package:bloc/bloc.dart';
import 'package:caps_book/features/data/model/booking_model.dart';
import 'package:caps_book/features/data/repositories/booking_repository.dart';
import 'package:meta/meta.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    on<FetchBookings>((event, emit) async {
      emit(BookingLoading());
      try {
        final bookings = await repository.fetchBookings();
        emit(BookingLoaded(bookings));
      } catch (_) {
        emit(BookingError("Failed to fetch bookings"));
      }
    });
  }
}
