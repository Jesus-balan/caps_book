import 'package:caps_book/features/data/model/booking_model.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: booking.isCompleted ? Colors.green[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                booking.isCompleted ? "Completed Order" : "Upcoming Order",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: booking.isCompleted ? Colors.green[800] : Colors.blue[800],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Source & Destination
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLocationInfo(Icons.location_on, "From", booking.source, Colors.red),
                _buildLocationInfo(Icons.flag, "To", booking.destination, Colors.blue),
              ],
            ),

            const SizedBox(height: 12),

            // Distance & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoTile(Icons.directions_car, "Distance", booking.distance),
                _buildInfoTile(Icons.access_time, "ETA", "45 mins"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
