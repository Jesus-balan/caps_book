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
        child: FutureBuilder<MaintenanceResponse>(
          future: repository.fetchMaintenanceList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("");
            } else if (!snapshot.hasData ||
                snapshot.data!.data.results.isEmpty) {
              return const SizedBox();
            }

            final maintenance = snapshot.data!.data.results.first;
            final uuid = maintenance.uuid;
            final vehicleName = maintenance.vehicleDetails.identity;
            final cost = maintenance.cost ?? 'N/A';
            final maintenanceType = maintenance.maintenanceType;
            final startingDate = maintenance.startDate?.split('T').first ?? 'N/A';

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: ColorStyle.primaryColor.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
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
                        bottomSheet: MaintenanceStatusSheet(
                          maintenanceUuid: uuid,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  /// Info Rows with Labels
                  _buildInfoRow("Vehicle", vehicleName),
                  _buildInfoRow("Cost", cost),
                  _buildInfoRow("Date", startingDate),
                  _buildInfoRow("Type", maintenanceType ?? '', isHighlight: true),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isHighlight ? ColorStyle.accentColor : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
