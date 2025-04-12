import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:caps_book/features/data/model/today_maintenance_model.dart';
import 'package:caps_book/features/data/repositories/today_maintenance_repository.dart';

class MaintenanceDetailsScreen extends StatelessWidget {
  const MaintenanceDetailsScreen({super.key});

  Future<MaintenanceResult> fetchFirstMaintenance() async {
    final repo = MaintenanceRepository();
    final response = await repo.fetchMaintenanceList();
    if (response.data.results.isEmpty) {
      throw Exception("No maintenance data found.");
    }
    return response.data.results.first;
  }

  String formatDate(String? isoDate) {
    if (isoDate == null) return "-";
    final dateTime = DateTime.parse(isoDate);
    return DateFormat.yMMMMd().format(dateTime);
  }

  Widget buildRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                color: highlight ? Colors.teal.shade700 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal.shade800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maintenance Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<MaintenanceResult>(
        future: fetchFirstMaintenance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data available."));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: ListView(
              children: [
                sectionTitle("Basic Info"),
                buildRow("Maintenance ID", data.maintenanceId ?? "-"),
                buildRow("Vehicle", data.vehicleDetails?.identity ?? "-", highlight: true),

                sectionTitle("Workshop Details"),
                buildRow("Workshop", data.workshopDetails?.identity ?? "-"),
                buildRow("Phone", data.workshopDetails?.phone ?? "-"),

                sectionTitle("Maintenance Info"),
                buildRow("Type", data.maintenanceType ?? "-", highlight: true),
                buildRow("Description", data.description ?? "-"),
                buildRow("Start Date", formatDate(data.startDate)),
                buildRow("Start KM", "${data.startKm ?? '-'} km"),

                sectionTitle("Status"),
                buildRow("Maintenance", data.maintenanceStatus ?? "-", highlight: true),
                buildRow("Payment", data.paymentStatus ?? "-"),
              ],
            ),
          );
        },
      ),
    );
  }
}
