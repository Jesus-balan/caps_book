import 'package:caps_book/features/config/styles.dart';
import 'package:flutter/material.dart';


import 'package:caps_book/features/presentation/widgets/custom_text.dart';
import 'package:http/http.dart' as http;

class RideSummaryScreen extends StatelessWidget {
  final String customerName;
  final DateTime dateTime;
  final String pickupAddress;
  final String dropAddress;
  final String bookingType;
  final String vehicleName;
  final String vehicleNumber;
  final String bookingStatus;
  final String customerPhone;
  final String startKm;
 final String rideId; // The ID to be passed to the API


  

  const RideSummaryScreen({
    super.key,
    required this.customerName,
    required this.dateTime,
    required this.pickupAddress,
    required this.dropAddress,
    required this.bookingType,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.bookingStatus,
    required this.customerPhone,
    required this.startKm,
    required this.rideId,
  });

 Future<void> _startTrip(BuildContext context) async {
  final String apiUrl = 'https://h5r5msdk-1111.inc1.devtunnels.ms/driver/booking/$rideId/trip-start/';

  try {
    final response = await http.patch(
      Uri.parse(apiUrl),
      body: {}, // Include body only if required
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trip started successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to start trip. Code: ${response.statusCode}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final String date = "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}";
    final String time = "${_formatTime(dateTime)}";

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        title: const Text("Ride Summary", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorStyle.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                        ],
                      ),
                      const Spacer(),
                      Text("$date, $time", style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/taxi-app.png',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Address Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(pickupAddress)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(dropAddress)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CustomText(text: 'Customer Details', fontSize: 20),
              ],
            ),
            const SizedBox(height: 12),

            // Details Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _billRow("Customer Name", customerName),
                  _billRow("Customer Number", customerPhone),
                  _billRow("Vehicle Name", vehicleName),
                  _billRow("Vehicle Number", vehicleNumber),
                  _billRow("Starting Date", date),
                  _billRow("Starting Time", time),
                  _billRow("Start KM", startKm),
                  _billRow("Booking Type", bookingType),
                  _billRow("Booking Status", bookingStatus),
                  _billRow("Pickup Address", pickupAddress),
                  _billRow("Drop Address", dropAddress),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Start Trip Button
             SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startTrip(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Start Trip", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _billRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 14,
                  color: color ?? Colors.black,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                )),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    int hour = dt.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12 == 0 ? 12 : hour % 12;
    String minute = dt.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
