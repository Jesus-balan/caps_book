import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/custom_text.dart';
import 'package:caps_book/features/presentation/widgets/custom_timeline.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_schedule_card.dart';
import 'package:caps_book/features/presentation/widgets/ride_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentStep = 0; // 0 -> Ordered, 1 -> Traveling, 2 -> Completed

  void startTrip() {
    setState(() {
      currentStep = 1; // Move to Traveling
    });
  }

  void completeTrip() {
    setState(() {
      currentStep = 2; // Move to Completed
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.network(
          'https://zenvicsoft.com/assets/img/logo-color.png',
          height: 50,
          color: Colors.white,
        ),
        backgroundColor: ColorStyle.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: 25,
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {},
            iconSize: 25,
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RideCard(
                title: 'Upcoming Ride',
                source: 'Kalakkad',
                destination: 'Tirunelveli',
                date: '2025-04-05',
                km: '42 KM',
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(0.2),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Running Order',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    const Divider(),
                    const SizedBox(height: 6),
                    CustomTimelineTile(
                      title: "START",
                      time: "15:30, Sep 9, 2018",
                      icon: Icons.check,
                      step: 0,
                      currentStep: currentStep,
                    ),
                    CustomTimelineTile(
                      title: "TRAVELING",
                      time: "15:45, Sep 9, 2018",
                      icon: Icons.directions_car,
                      step: 1,
                      currentStep: currentStep,
                    ),
                    CustomTimelineTile(
                      title: "COMPLETED",
                      time: "Estimated: 17:30",
                      icon: Icons.done_all,
                      step: 2,
                      currentStep: currentStep,
                      isLast: true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: currentStep == 0 ? startTrip : null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            backgroundColor: ColorStyle.primaryColor,
                          ),
                          child: const Text(
                            'Start Trip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: currentStep == 1 ? completeTrip : null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Complete Trip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              MaintenanceScheduleCard(
                vehicleName: "XUV 500",
                shopName: "Jayam Auto Works",
                startingDate: "10-Apr-2025",
                startingTime: "10:00 AM",
                maintenanceType: "Oil Change",
                startingKm: "25600 km",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
