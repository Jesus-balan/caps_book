import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/blocs/myride/myride_bloc.dart';
import 'package:caps_book/features/presentation/blocs/myride/myride_event.dart';
import 'package:caps_book/features/presentation/blocs/myride/myride_state.dart';
import 'package:caps_book/features/presentation/ui/bookingdetails/booking_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyRideScreen extends StatefulWidget {
  @override
  _MyRideScreenState createState() => _MyRideScreenState();
}

class _MyRideScreenState extends State<MyRideScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<MyrideBloc>().add(const FetchMyRides());
    });
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: 25,
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            iconSize: 25,
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: ColorStyle.primaryColor,
        title: const Text("My Rides", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Ordered
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => selectedIndex = 0);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 0 ? Colors.blue : Colors.grey[300],
                        foregroundColor: selectedIndex == 0 ? Colors.white : Colors.black,
                      ),
                      child: const Text('Ordered'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Completed
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => selectedIndex = 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 1 ? Colors.blue : Colors.grey[300],
                        foregroundColor: selectedIndex == 1 ? Colors.white : Colors.black,
                      ),
                      child: const Text('Complete'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bloc UI
            BlocBuilder<MyrideBloc, MyrideState>(
              builder: (context, state) {
                if (state is MyrideLoaded) {
                  final filteredBookings = state.rideBookings.where((booking) {
                    return selectedIndex == 0
                        ? booking.booking_status == 'Ordered'
                        : booking.booking_status == 'Completed';
                  }).toList();

                  if (filteredBookings.isEmpty) {
                    return Center(
                      child: Text(
                        selectedIndex == 0 ? "No upcoming bookings" : "No completed bookings",
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurpleAccent.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top: Customer Name & Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  booking.customerName ?? "No Name",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatDateTime(booking.dateTime),
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Vehicle Info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  booking.vehicleName ?? "No Vehicle",
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  booking.vehicleNumber ?? "No Number",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            // Pickup
                            Row(
                              children: [
                                const Icon(Icons.arrow_upward, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.pickupAddress ?? "No Pickup",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Drop
                            Row(
                              children: [
                                const Icon(Icons.arrow_downward, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.dropAddress ?? "No Drop",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: booking.booking_status?.toLowerCase() == "ordered"
                                    ? () {
                                        Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RideSummaryScreen(
                                          customerName: booking.customerName ?? '',
                                          dateTime: booking.dateTime,
                                          pickupAddress: booking.pickupAddress ?? '',
                                          dropAddress: booking.dropAddress ?? '',
                                          bookingType: booking.bookingType ?? '',
                                          vehicleName: booking.vehicleName ?? '',
                                          vehicleNumber: booking.vehicleNumber ?? '',
                                          bookingStatus: booking.booking_status ?? '',
                                          customerPhone: booking.customerPhone ?? '',
                                          startKm: booking.startKm ?? '',
                                          rideId: booking.uuid ?? '',
                                        ),
                                      ),
                                    );
                                      }
                                    : null,
                                icon: const Icon(Icons.local_taxi, color: Colors.white),
                                label: Text(
                                  booking.booking_status?.toLowerCase() == "ordered"
                                      ? "Pickup Customer"
                                      : "Completed",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: booking.booking_status?.toLowerCase() == "ordered"
                                      ? Colors.deepPurple
                                      : Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
