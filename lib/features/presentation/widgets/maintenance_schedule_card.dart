import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/model/today_maintenance_model.dart';
import 'package:caps_book/features/data/repositories/today_maintenance_repository.dart';
import 'package:caps_book/features/presentation/widgets/custom_add_button.dart';
import 'package:caps_book/features/presentation/widgets/custom_text.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_sheet.dart';
import 'package:flutter/material.dart';

class MaintenanceScheduleCard extends StatelessWidget {
  final MaintenanceRepository repository = MaintenanceRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/maintenance');
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            boxShadow: [
              BoxShadow(color: ColorStyle.primaryColor, offset: Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Today Maintenance',
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomBottomSheetButton(
                    label: 'Add',
                    icon: Icons.add,
                    bottomSheet: const MaintenanceStatusSheet(),
                  ),
                ],
              ),
              const Divider(),

              /// FutureBuilder to load maintenance data
              FutureBuilder<MaintenanceResponse>(
                future: repository.fetchMaintenanceList(),
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
                  final vehicleName = maintenance.vehicleDetails.identity;
                  final shopName = maintenance.workshopDetails?.identity ?? 'N/A';
                  final startingDate = maintenance.startDate;
                  final maintenanceType = maintenance.maintenanceType;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_buildRow(vehicleName), _buildRow(shopName)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRow(startingDate.split('T').first),
                          _buildRow(maintenanceType, isHighlight: true),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isHighlight ? ColorStyle.accentColor : Colors.black87,
        ),
      ),
    );
  }
}
