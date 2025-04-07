import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/blocs/booking/booking_bloc.dart';
import 'package:caps_book/features/presentation/widgets/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(FetchBookings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Cab Bookings"),
        backgroundColor: ColorStyle.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSegmentedToggle(),
          const SizedBox(height: 6), // spacing below toggle
          Expanded(
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingLoaded) {
                  final upcoming = state.bookings.where((b) => !b.isCompleted).toList();
                  final completed = state.bookings.where((b) => b.isCompleted).toList();
                  final list = selectedIndex == 0 ? upcoming : completed;
                  return _buildBookingList(list);
                } else if (state is BookingError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedToggle() {
    final List<String> tabs = ['Upcoming', 'Completed'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBookingList(List bookings) {
    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings found."));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        return BookingCard(booking: bookings[index]);
      },
    );
  }
}
