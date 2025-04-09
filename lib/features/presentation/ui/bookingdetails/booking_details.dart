import 'package:caps_book/features/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class RideSummaryScreen extends StatelessWidget {
  const RideSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        title: const Text("Ride Summary", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
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
                  // Rider Info
                  Row(
                    children: [
                     
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Jonathan Higgins", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                        ],
                      ),
                      const Spacer(),
                      const Text("15 Feb'25, 10:15 AM", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Ride Path Image
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
                children: const [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text("17, Yonge St, Toronto, Canada"),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text("20, Yonge St, Toronto, Canada"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: 'Customer Details', fontSize: 20,),
              ],
            ),
            const SizedBox(height: 12),
            // Bill Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  _billRow("Customer Name", "Jonathan Higgins"),
                  _billRow("Customer Number", "+1 98765 43210"),
                  _billRow("Vehicle Name", "Toyota Camry"),
                  _billRow("Vehicle Number", "TN 01 AB 1234"),
                  _billRow("Starting Date", "15 Feb 2025"),
                  _billRow("Start KM", "18452 km"),
                  _billRow("Starting Time", "10:15 AM"),
                  _billRow("Pickup Address", "17, Yonge St, Toronto, Canada"),
                  _billRow("Drop Address", "20, Yonge St, Toronto, Canada"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Start Trip Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Start Trip
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
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

  Widget _billRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                fontSize: 14,
                color: color ?? Colors.black,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              )),
        ],
      ),
    );
  }
}
