import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/model/maintenance_response_model.dart';
import 'package:caps_book/features/data/repositories/maintenance_response_repository.dart';
import 'package:caps_book/features/presentation/widgets/custom_add_button.dart';
import 'package:caps_book/features/presentation/widgets/maintenanace_edit.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_complete.dart';
import 'package:flutter/material.dart';

class MaintenanceReport extends StatelessWidget {
  final UnplannedMaintenanceRepository repository =
      UnplannedMaintenanceRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(color: ColorStyle.primaryColor, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Maintenance Report',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomBottomSheetButton(
                label: 'Edit',
                icon: Icons.edit,
                bottomSheet: MaintenanceEdit(),
              ),
              CustomBottomSheetButton(
                label: 'Complete',
                icon: Icons.check_circle,
                bottomSheet: MaintenanceComplete(),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(thickness: 1),

          const SizedBox(height: 12),
          FutureBuilder<TodayMaintenanceResponse>(
            future: repository.fetchUnplannedMaintenanceList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData ||
                  snapshot.data!.data.results.isEmpty) {
                return const Text("No maintenance scheduled today.");
              }
              final maintenance = snapshot.data!.data.results.first;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailText(
                        maintenance.vehicleDetails.identity.toString(),
                      ),
                      _buildDetailText(
                        maintenance.workshopDetails?.identity ?? 'N/A',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailText(
                        maintenance.startDate.split('T').join(' '),
                      ),
                      _buildDetailText(maintenance.startKm),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(value, style: const TextStyle(fontSize: 15))],
    );
  }
}
