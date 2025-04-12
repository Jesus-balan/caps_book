import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/repositories/today_maintenance_repository.dart';
import 'package:caps_book/features/presentation/widgets/custom_text.dart';
import 'package:caps_book/features/presentation/widgets/custom_timeline.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_report.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_schedule_card.dart';
import 'package:caps_book/features/presentation/widgets/ride_tile_widget.dart';
import 'package:caps_book/features/presentation/widgets/summary_card.dart';
import 'package:caps_book/features/presentation/widgets/unplaned_maintenance.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tripStep = 0; // 0 = ready for pickup, 1 = picked, 2 = dropped
  DateTime? pickupTime;
  DateTime? dropTime;
  DateTime? completeTime;

  final MaintenanceRepository repository = MaintenanceRepository();

  @override
  void initState() {
    super.initState();
    _callTodayMaintenanceAPI();
  }

  void _callTodayMaintenanceAPI() async {
    try {
      await repository.fetchMaintenanceList();
    } catch (e) {
      print("Error calling maintenance API: $e");
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
          color: Colors.white,
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
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: "Total Earnings(April)",
                      value: "\$3100",
                      icon: LucideIcons.wallet,
                      bottomColor: ColorStyle.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: "Complete Ride(April)",
                      value: "16",
                      icon: LucideIcons.checkCircle2,
                      bottomColor: ColorStyle.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: "Absent Ride(April)",
                      value: "02",
                      icon: LucideIcons.clock4,
                      bottomColor: ColorStyle.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: "Rating Star",
                      value: "",
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
              RideTile(
                name: 'Peter Thornton',
                date: '10 May’25 at 4:10 AM',
                pickup: '17, Yonge St, Toronto, Canada',
                drop: '20, Avenue St, Toronto, Canada',
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  CustomText(
                    text: 'Running Order',
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.030),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: ColorStyle.primaryColor,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    CustomTimelineTile(
                      title: "START",
                      time: "15:30, Sep 9, 2018",
                      icon: Icons.check,
                      step: 0,
                      currentStep: tripStep,
                    ),
                    CustomTimelineTile(
                      title: "TRAVELING",
                      time: "15:45, Sep 9, 2018",
                      icon: Icons.directions_car,
                      step: 1,
                      currentStep: tripStep,
                    ),
                    CustomTimelineTile(
                      title: "COMPLETED",
                      time: "Estimated: 17:30",
                      icon: Icons.done_all,
                      step: 2,
                      currentStep: tripStep,
                      isLast: true,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed:
                              tripStep < 3
                                  ? () {
                                    setState(() {
                                      if (tripStep == 0) {
                                        pickupTime = DateTime.now();
                                        tripStep = 1;
                                      } else if (tripStep == 1) {
                                        dropTime = DateTime.now();
                                        tripStep = 2;
                                      } else if (tripStep == 2) {
                                        completeTime = DateTime.now();
                                        tripStep = 3;
                                      }
                                    });
                                  }
                                  : null, // Disable when tripStep == 3
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                tripStep < 3
                                    ? ColorStyle.primaryColor
                                    : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                          child: Text(
                            tripStep == 0
                                ? 'Pickup Customer'
                                : tripStep == 1
                                ? 'Drop Customer'
                                : tripStep == 2
                                ? 'Complete Trip'
                                : 'Trip Completed',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              MaintenanceScheduleCard(),
              SizedBox(height: screenHeight * 0.02),
              MaintenanceReport(),
             SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => UnplannedMaintenanceSheet(),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Unplanned',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorStyle.primaryColor,
      ),
    );
  }

}
