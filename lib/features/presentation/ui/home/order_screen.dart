import 'package:caps_book/features/presentation/blocs/booking/booking_bloc.dart';
import 'package:caps_book/features/presentation/widgets/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<BookingBloc>().add(FetchBookings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Cab Bookings"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Upcoming"),
            Tab(text: "Completed"),
          ],
        ),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingLoaded) {
            final upcoming = state.bookings.where((b) => !b.isCompleted).toList();
            final completed = state.bookings.where((b) => b.isCompleted).toList();
            return TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(upcoming),
                _buildBookingList(completed),
              ],
            );
          } else if (state is BookingError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBookingList(List bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: bookings.length,
      itemBuilder: (_, index) {
        return BookingCard(booking: bookings[index]);
      },
    );
  }
}
