import 'dart:convert';

import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/repositories/trip_start_repository.dart';
import 'package:caps_book/features/presentation/widgets/custom_timeline.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RunningStatusWidget extends StatefulWidget {
  const RunningStatusWidget({super.key});

  @override
  State<RunningStatusWidget> createState() => _RunningStatusWidgetState();
}

class _RunningStatusWidgetState extends State<RunningStatusWidget> {
  int tripStep = 0;
  DateTime? pickupTime;
  DateTime? dropTime;
  DateTime? completeTime;
  DateTime? returnToCabTime;
  String? bookingId;

  late Future<void> _tripFuture;

  @override
  void initState() {
    super.initState();
    loadTripData();
    _tripFuture = fetchStartDate(); // ✅ assign here
  }

  void loadTripData() async {
    final pickupStr = await HiveService().getTripTime('pickupTime');
    final dropStr = await HiveService().getTripTime('dropTime');
    final completeStr = await HiveService().getTripTime('completeTime');
    final returnStr = await HiveService().getTripTime('returnToCabTime');

    setState(() {
      pickupTime = pickupStr != null ? DateTime.tryParse(pickupStr) : null;
      dropTime = dropStr != null ? DateTime.tryParse(dropStr) : null;
      completeTime =
          completeStr != null ? DateTime.tryParse(completeStr) : null;
      returnToCabTime = returnStr != null ? DateTime.tryParse(returnStr) : null;
      updateTripStep();
    });
  }

  void updateTripStep() {
    setState(() {
      if (pickupTime != null && dropTime == null) {
        tripStep = 1;
      } else if (pickupTime != null &&
          dropTime != null &&
          completeTime == null) {
        tripStep = 2;
      } else if (pickupTime != null &&
          dropTime != null &&
          completeTime != null &&
          returnToCabTime == null) {
        tripStep = 3;
      } else if (pickupTime != null &&
          dropTime != null &&
          completeTime != null &&
          returnToCabTime != null) {
        tripStep = 4;
      } else {
        tripStep = 0;
      }
    });
  }

  Future<void> fetchStartDate() async {
    final response = await BookingRepository().fetchBookingList();
    if (response.results.isNotEmpty &&
        response.results.first.startDate.isNotEmpty) {
      setState(() {
        bookingId = response.results.first.uuid;
      });
    }
  }

  String formatTime(DateTime? time) {
    return time != null
        ? DateFormat('hh:mm a, MMM d').format(time)
        : "Waiting...";
  }

  // API -1
  Future<void> markCustomerPickup(String uuid) async {
    final url = Uri.parse(
      'https://h5r5msdk-1111.inc1.devtunnels.ms/driver/booking/$uuid/customer-pickup/',
    );

    final token =
        await HiveService().getToken(); // Assume you store token securely

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Customer pickup marked successfully');
    } else {
      print('Failed to mark pickup: ${response.body}');
    }
  }

  // API -2
  Future<void> markCustomerDrop(String uuid) async {
    final url = Uri.parse(
      'https://h5r5msdk-1111.inc1.devtunnels.ms/driver/booking/$uuid/customer-drop/',
    );

    final token =
        await HiveService().getToken(); // Assume you store token securely

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Customer drop marked successfully');
    } else {
      print('Failed to mark pickup: ${response.body}');
    }
  }

  // API -3
  Future<void> markCustomerReturn(String uuid, String endKm) async {
    final url = Uri.parse(
      'https://h5r5msdk-1111.inc1.devtunnels.ms/driver/booking/$uuid/trip-end/',
    );

    final token =
        await HiveService().getToken(); // Assume you store token securely

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: '{"end_km": "$endKm"}',
    );

    if (response.statusCode == 200) {
      print('Customer pickup marked successfully');
    } else {
      print('Failed to mark pickup: ${response.body}');
    }
  }

  // FUEL API-4
  Future<void> markCustomerFuel(String uuid, double amount) async {
    final url = Uri.parse(
      'https://h5r5msdk-1111.inc1.devtunnels.ms/driver/booking/$uuid/update-fuel/',
    );

    final token = await HiveService().getToken();

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"fuel": amount}),
    );

    if (response.statusCode == 200) {
      print('Fuel updated successfully');
    } else {
      print('Failed to update fuel: ${response.body}');
    }
  }

  // Fuel popup
  void showFuelDialog() {
    TextEditingController fuelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Enter Fuel Amount"),
          content: TextField(
            controller: fuelController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "Amount (in ₹)",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (bookingId != null && fuelController.text.isNotEmpty) {
                  Navigator.pop(context);
                  double? amount = double.tryParse(fuelController.text.trim());

                  if (amount != null && bookingId != null) {
                    await markCustomerFuel(bookingId!, amount);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Fuel ₹$amount submitted")),
                    );
                  }

                  setState(() {
                    returnToCabTime = DateTime.now();
                    updateTripStep();
                  });
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEndKmDialogAndSubmit() async {
    TextEditingController kmController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Enter End KM"),
            content: TextField(
              controller: kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "e.g. 12456"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  if (bookingId != null && kmController.text.isNotEmpty) {
                    Navigator.pop(context);
                    await markCustomerReturn(bookingId!, kmController.text);
                    setState(() {
                      returnToCabTime = DateTime.now();
                      updateTripStep();
                    });
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
    );
  }

  String getButtonLabel() {
    switch (tripStep) {
      case 0:
        return 'Start Trip';
      case 1:
        return 'Pickup Customer';
      case 2:
        return 'Drop Customer';
      case 3:
        return 'Return to Cab';
      case 4:
        return 'Trip Completed';
      default:
        return '';
    }
  }

  IconData getButtonIcon() {
    switch (tripStep) {
      case 0:
        return Icons.directions_walk;
      case 1:
        return Icons.location_on;
      case 2:
        return Icons.flag;
      case 4:
        return Icons.verified_user_outlined;
      default:
        return Icons.check;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: _tripFuture,
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.06),
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.01),
              (pickupTime == null)
                  ? Column(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: const Icon(
                              Icons.local_taxi,
                              color: Colors.teal,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Waiting for customer to start ride...",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Your trip will begin once the customer confirms.",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                  : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTimelineTile(
                            title: "START",
                            time: formatTime(pickupTime),
                            icon: Icons.play_arrow_rounded,
                            step: 0,
                            currentStep: tripStep,
                          ),
                          ElevatedButton.icon(
                            onPressed: showFuelDialog, // Define this method
                            icon: Icon(
                              Icons.local_gas_station_rounded,
                              size: 20,
                            ),
                            label: Text("Fuel"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenHeight * 0.012,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomTimelineTile(
                        title: "PICKED",
                        time: formatTime(dropTime),
                        icon: Icons.directions_car,
                        step: 1,
                        currentStep: tripStep,
                      ),
                      CustomTimelineTile(
                        title: "DROPPED",
                        time: formatTime(completeTime),
                        icon: Icons.done_all,
                        step: 2,
                        currentStep: tripStep,
                      ),
                      CustomTimelineTile(
                        title: "RETURNED",
                        time: formatTime(returnToCabTime),
                        icon: Icons.home,
                        step: 3,
                        currentStep: tripStep,
                        isLast: true,
                      ),
                    ],
                  ),

              SizedBox(height: screenHeight * 0.01),
              Center(
                child:
                    pickupTime == null
                        ? const SizedBox() // Hides the button when waiting
                        : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: ElevatedButton.icon(
                            key: ValueKey(tripStep),
                            onPressed:
                                tripStep >= 4
                                    ? null
                                    : () async {
                                      if (tripStep == 0) {
                                        setState(() {
                                          pickupTime = DateTime.now();
                                          HiveService().saveBoxValue(
                                            'pickupTime',
                                            pickupTime!.toIso8601String(),
                                          );
                                          updateTripStep();
                                        });
                                      } else if (tripStep == 1) {
                                        setState(() {
                                          dropTime = DateTime.now();
                                          HiveService().saveBoxValue(
                                            'dropTime',
                                            dropTime!.toIso8601String(),
                                          );
                                          updateTripStep();
                                        });
                                        if (bookingId != null) {
                                          await markCustomerPickup(bookingId!);
                                        }
                                      } else if (tripStep == 2) {
                                        setState(() {
                                          completeTime = DateTime.now();
                                          HiveService().saveBoxValue(
                                            'completeTime',
                                            completeTime!.toIso8601String(),
                                          );
                                          updateTripStep();
                                        });
                                        if (bookingId != null) {
                                          await markCustomerDrop(bookingId!);
                                        }
                                      } else if (tripStep == 3) {
                                        setState(() {
                                          returnToCabTime = DateTime.now();
                                          HiveService().saveBoxValue(
                                            'returnToCabTime',
                                            returnToCabTime!.toIso8601String(),
                                          );
                                          updateTripStep();
                                        });
                                        await showEndKmDialogAndSubmit();
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  tripStep < 4
                                      ? ColorStyle.primaryColor
                                      : Colors.grey,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06,
                                vertical: screenHeight * 0.017,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.04,
                                ),
                              ),
                            ),
                            icon: Icon(
                              getButtonIcon(),
                              color: Colors.white,
                              size: screenWidth * 0.06,
                            ),
                            label: Text(
                              getButtonLabel(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w500,
                              ),
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
}
