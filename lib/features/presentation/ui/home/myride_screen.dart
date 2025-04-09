import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/blocs/myride/myride_bloc.dart';
import 'package:caps_book/features/presentation/widgets/ridecard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRideScreen extends StatefulWidget {
  @override
  _MyRideScreenState createState() => _MyRideScreenState();
}

class _MyRideScreenState extends State<MyRideScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyrideBloc>().add(FetchBookingEvent());
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
        title: Text("My Rides", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            // Categories Section
            BlocBuilder<MyrideBloc, MyrideState>(
              builder: (context, state) {
                String selectedCategory = "All";
                if (state is MyrideLoaded) {
                  selectedCategory = state.bookingCategory;
                }
                return Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _categoryButton("Pending Ride", selectedCategory),
                          _categoryButton("Completed Ride", selectedCategory),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

            // Product List
            BlocBuilder<MyrideBloc, MyrideState>(
              builder: (context, state) {
                if (state is MyrideLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MyrideError) {
                  return const Center(
                    child: Text(
                      "Failed to load bookings",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is MyrideLoaded) {
                  if (state.rideBookings.isEmpty) {
                    return const Center(child: Text("No bookings available"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.rideBookings.length,
                    itemBuilder: (context, index) {
                      final booking = state.rideBookings[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RideCard(
                          vehicleName: booking.vehicleName,
                          vehicleNumber: booking.vehicleNumber,
                          customerName: booking.customerName,
                          dateTime: booking.dateTime.toString(),
                          pickupLocation: booking.pickupAddress,
                          dropLocation: booking.dropAddress,
                          onPickup: () {
                            // only for Pending
                            if (state.bookingCategory == "Pending Ride") {
                              Navigator.pushNamed(context, '/ridesummary');
                            }
                          },
                          status:
                              state.bookingCategory, // pass current category
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Category Button Widget
  Widget _categoryButton(String category, String selectedCategory) {
    return GestureDetector(
      onTap: () {
        context.read<MyrideBloc>().add(SelectCategory(category));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color:
              selectedCategory == category
                  ? Colors.deepPurpleAccent
                  : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Text(
              category,
              style: TextStyle(
                fontSize: 14,
                color:
                    selectedCategory == category ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
