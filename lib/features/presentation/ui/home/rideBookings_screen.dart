import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/blocs/ridebooking/myride_bloc.dart';
import 'package:caps_book/features/presentation/blocs/ridebooking/myride_event.dart';
import 'package:caps_book/features/presentation/blocs/ridebooking/myride_state.dart';
import 'package:caps_book/features/presentation/ui/Details/booking_details.dart';
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

  void onTabSwitch(int index) {
    if (selectedIndex != index) {
      setState(() => selectedIndex = index);
      context.read<MyrideBloc>().add(const FetchMyRides());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: screenWidth * 0.065,
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            iconSize: screenWidth * 0.065,
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: ColorStyle.primaryColor,
        title: const Text("My Rides", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onTabSwitch(0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 0
                            ? ColorStyle.primaryColor
                            : Colors.grey[300],
                        foregroundColor:
                            selectedIndex == 0 ? Colors.white : Colors.black,
                      ),
                      child: const Text('Ordered'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onTabSwitch(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == 1
                            ? ColorStyle.primaryColor
                            : Colors.grey[300],
                        foregroundColor:
                            selectedIndex == 1 ? Colors.white : Colors.black,
                      ),
                      child: const Text('Complete'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<MyrideBloc, MyrideState>(
              builder: (context, state) {
                if (state is MyrideError) {
                  return const Center(
                    child: Text(
                      "Failed to load rides. Try again.",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is MyrideLoaded) {
                  final filtered = state.rideBookings.where((booking) {
                    return selectedIndex == 0
                        ? booking.booking_status == 'Ordered'
                        : booking.booking_status == 'Completed';
                  }).toList();

                  if (filtered.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Text(
                          selectedIndex == 0
                              ? "No upcoming bookings"
                              : "No completed bookings",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final booking = filtered[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 2),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ColorStyle.primaryColor.withOpacity(0.2),
                              offset: const Offset(0, 6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  booking.customerName ?? "No Name",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatDateTime(booking.dateTime),
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Vehicle Info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  booking.vehicleName ?? "No Vehicle",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  booking.vehicleNumber ?? "No Number",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(color: Colors.grey.shade300),
                            const SizedBox(height: 5),
                            // Pickup / Drop
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.arrow_upward,
                                    color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.pickupAddress ?? "No Pickup",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Icon(Icons.arrow_downward,
                                    color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.dropAddress ?? "No Drop",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: booking.booking_status
                                            ?.toLowerCase() ==
                                        "ordered"
                                    ? () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => RideSummaryScreen(
                                              customerName:
                                                  booking.customerName ?? '',
                                              dateTime: booking.dateTime,
                                              pickupAddress:
                                                  booking.pickupAddress ?? '',
                                              dropAddress:
                                                  booking.dropAddress ?? '',
                                              bookingType:
                                                  booking.bookingType ?? '',
                                              vehicleName:
                                                  booking.vehicleName ?? '',
                                              vehicleNumber:
                                                  booking.vehicleNumber ?? '',
                                              bookingStatus:
                                                  booking.booking_status ?? '',
                                              customerPhone:
                                                  booking.customerPhone ?? '',
                                              startKm: booking.startKm ?? '',
                                              rideId: booking.uuid ?? '',
                                            ),
                                          ),
                                        );
                                        context
                                            .read<MyrideBloc>()
                                            .add(const FetchMyRides());
                                      }
                                    : null,
                                icon: const Icon(Icons.local_taxi),
                                label: Text(
                                  booking.booking_status?.toLowerCase() ==
                                          "ordered"
                                      ? "Pickup Customer"
                                      : "Completed",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: booking.booking_status
                                              ?.toLowerCase() ==
                                          "ordered"
                                      ? ColorStyle.primaryColor
                                      : Colors.green,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
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
