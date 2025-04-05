import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/custom_timeline.dart';
import 'package:flutter/material.dart';
import 'package:caps_book/features/presentation/widgets/custom_card.dart';
import 'package:caps_book/features/presentation/widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
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
    return Scaffold(
      backgroundColor: Colors.white,
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
          IconButton(onPressed: () {}, iconSize: 25, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, iconSize: 25, icon: const Icon(Icons.person)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CustomText(text: 'Today, 19 Jan', fontSize: 24, fontWeight: FontWeight.bold),
                    SizedBox(height: 8),
                    CustomText(text: "₹ 3,000", fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    SizedBox(height: 8),
                    CustomText(text: '2 Rides Completed', fontSize: 20, fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              const CustomText(text: 'Order:', fontSize: 24, fontWeight: FontWeight.bold),
              const SizedBox(height: 12),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(text: "Upcoming Order", fontSize: 16, fontWeight: FontWeight.w600),
                    const Divider(),
                    const SizedBox(height: 6),
                    const CustomText(text: 'Source: Kalakkad', fontSize: 14),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CustomText(text: 'Destination: Tirunelveli', fontSize: 14),
                        CustomText(text: '45 km', fontSize: 14, fontWeight: FontWeight.bold),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(text: 'Running Order', fontSize: 16, fontWeight: FontWeight.w600),
                    const Divider(),
                    const SizedBox(height: 6),
                    _buildTimeline(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: currentStep == 0 ? startTrip : null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            backgroundColor: ColorStyle.primaryColor),
                          child: const Text('Start Trip',style: TextStyle(color: Colors.white),),
                        ),
                        ElevatedButton(
                          onPressed: currentStep == 1 ? completeTrip : null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            backgroundColor: Colors.green),
                          child: const Text('Complete Trip',style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        CustomTimelineTile(
          title: "ORDERED",
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
      ],
    );
  }
}
