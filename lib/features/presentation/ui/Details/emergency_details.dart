import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:caps_book/features/data/model/maintenance_response_model.dart';
import 'package:caps_book/features/data/repositories/maintenance_response_repository.dart';

class EmergencyServiceDetails extends StatelessWidget {
  const EmergencyServiceDetails({super.key});

  Future<TodayMaintenanceResult> fetchEmergencyServiceData() async {
    final repo = UnplannedMaintenanceRepository();
    final response = await repo.fetchUnplannedMaintenanceList();
    if (response.data.results.isEmpty) {
      throw Exception("No emergency service data found.");
    }
    return response.data.results.first;
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return "Not available";
    final date = DateTime.parse(dateStr);
    return DateFormat.yMMMMd().format(date);
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
              value.isNotEmpty ? value : 'Not available',
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
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: const Text("Emergency Service Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<TodayMaintenanceResult>(
        future: fetchEmergencyServiceData(),
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
                buildRow("Service ID", data.maintenanceId ?? "Not entered"),
                buildRow("Vehicle", data.vehicleDetails?.identity ?? "Not entered", highlight: true),

                sectionTitle("Maintenance Info"),
                buildRow("Type", data.maintenanceType ?? "Not entered", highlight: true),
                buildRow("Description", data.description ?? "Not entered"),
                buildRow("Start Date", formatDate(data.startDate)),
                buildRow("End Date", formatDate(data.endDate)),
                buildRow("Start KM", data.startKm ?? "Not entered Km"),
                buildRow("End KM", data.endKm ?? "Not entered"),
                buildRow("Cost", "₹${data.cost ?? '0.00'}"),

                sectionTitle("Status"),
                buildRow("Maintenance", data.maintenanceStatus ?? "Not entered", highlight: true),
                buildRow("Payment", data.paymentStatus ?? "Not entered"),
              ],
            ),
          );
        },
      ),
    );
  }
}
