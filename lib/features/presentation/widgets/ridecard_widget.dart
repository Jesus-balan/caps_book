import 'package:caps_book/features/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RideCard extends StatelessWidget {
  final String customerName;
  final String dateTime; // Accepts formatted string
  final String vehicleName;
  final String vehicleNumber;
  final String pickupLocation;
  final String dropLocation;
  final VoidCallback onPickup;
  final String status;

  const RideCard({
    super.key,
    required this.customerName,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.dateTime,
    required this.pickupLocation,
    required this.dropLocation,
    required this.onPickup,
    required this.status,
  });

  String formatDateTime(String input) {
    try {
      final parsed = DateTime.parse(input);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(parsed);
    } catch (_) {
      return input;
    }
  }

  @override
  Widget build(BuildContext context) {
    String cleanStatus = status.trim().toLowerCase();

    // Only allow "pending ride" or "completed ride"
    if (cleanStatus != "Ordered" && cleanStatus != "Completed") {
      return const SizedBox(); // Skip rendering
    }

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
            color: ColorStyle.primaryColor,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Name and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customerName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatDateTime(dateTime),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vehicleName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                vehicleNumber,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade300),

          // Pickup
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pickupLocation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
                  dropLocation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: cleanStatus == "pending ride" ? onPickup : null,
              icon: const Icon(Icons.local_taxi, color: Colors.white),
              label: Text(
                cleanStatus == "Ordered" ? "Pickup Customer" : "Completed",
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    cleanStatus == "Ordered" ? Colors.deepPurple : Colors.green,
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
  }
}
