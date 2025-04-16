import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/core/utils/snackbar_utils.dart';
import 'package:caps_book/features/data/model/rideBooking_model.dart';
import 'package:caps_book/features/data/repositories/customer_repository.dart';
import 'package:caps_book/features/data/repositories/ride_response_repository.dart';
import 'package:caps_book/features/data/repositories/today_maintenance_repository.dart';
import 'package:caps_book/features/presentation/widgets/custom_text.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_report.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_schedule_card.dart';
import 'package:caps_book/features/presentation/widgets/ride_tile_widget.dart';
import 'package:caps_book/features/presentation/widgets/running_status_widget.dart';
import 'package:caps_book/features/presentation/widgets/summary_card.dart';
import 'package:caps_book/features/presentation/widgets/unplaned_maintenance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MaintenanceRepository repository;
  @override
  void initState() {
    super.initState();
    repository = MaintenanceRepository();
    _loadHomeData();
    _fetchDriverDetails();
  } 
 
  Future<void> _loadHomeData() async {
    // showLoaderDialog(context); // Show loading popup
    try {
      await Future.wait([
        _fetchDriverDetails(),
        _loadUpcomingRide(),
        _callTodayMaintenanceAPI(),
      ]);
    } catch (e) {
      
    } finally {
       setState(() => isLoading = false); // <-- Add this
      // hideLoaderDialog(context); // Hide popup
    }
  }

  bool isLoading = true;
  bool isSheetOpening = false;

  String? balance;
  String? rating;

  RideBookingModel? _upcomingRide;

  Future<void> _loadUpcomingRide() async {
    try {
      final ride = await RideBookingRepository()
          .fetchFirstUpcomingBooking()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception("Request timed out"),
          );

      setState(() {
        _upcomingRide = ride;
      });
    } catch (e) {
      
    }
  }

  Future<void> _callTodayMaintenanceAPI() async {
    try {
      await repository.fetchMaintenanceList();
    } catch (e) {
      
    }
  }

  Future<void> _fetchDriverDetails() async {
    try {
      final driverDetails = await CustomerService.fetchDriverDetails();
      setState(() {
        balance = driverDetails.data.driver.balance;
        rating = driverDetails.data.driver.rating;
      });
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/logo.png',
          height: screenHeight * 0.035,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        backgroundColor: ColorStyle.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: screenWidth * 0.065,
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            iconSize: screenWidth * 0.065,
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadHomeData,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // ensures pull works even if list is short
            child: Column(
              children: [
                // Summary Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: "Total Earnings(April)",
                        value: balance != null ? "₹$balance" : "--",
                        icon: LucideIcons.wallet,
                        bottomColor: ColorStyle.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: "Rating Star",
                        value: rating ?? "--",
                        icon: LucideIcons.star,
                        bottomColor: ColorStyle.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "New Upcoming Ride",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                _upcomingRide != null
                    ? RideTile(
                      name: _upcomingRide!.customerName,
                      date: DateFormat(
                        'MMM dd, yyyy – hh:mm a',
                      ).format(_upcomingRide!.dateTime),
                      pickup: _upcomingRide!.pickupAddress,
                      drop: _upcomingRide!.dropAddress,
                    )
                    : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.directions_car_filled_outlined,
                            size: 30,
                            color: ColorStyle.primaryColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No Upcoming Ride",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "You're all caught up for now!",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                const SizedBox(height: 16),
                Row(
                  children: const [
                    CustomText(
                      text: 'Running Status',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RunningStatusWidget(),
                SizedBox(height: 25),
                MaintenanceScheduleCard(),
                SizedBox(height: screenHeight * 0.01),
                MaintenanceReport(),
                SizedBox(height: screenHeight * 0.07),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            isSheetOpening
                ? null
                : () async {
                  setState(() => isSheetOpening = true);
                  try {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => UnplannedMaintenanceSheet(),
                    );
                  } finally {
                    setState(() => isSheetOpening = false);
                  }
                },
        icon:
            isSheetOpening
                ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                : const Icon(Icons.add, color: Colors.white),
        label: Text(
          isSheetOpening ? "Loading..." : "Emergency Service",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorStyle.primaryColor,
      ),
    );
  }
}
