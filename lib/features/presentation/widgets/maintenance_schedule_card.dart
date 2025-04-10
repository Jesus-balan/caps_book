import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/custom_add_button.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_sheet.dart';
import 'package:flutter/material.dart';

class MaintenanceScheduleCard extends StatelessWidget {
  final String vehicleName;
  final String shopName;
  final String startingDate;
  final String startingTime;
  final String maintenanceType;
  final String startingKm;

  const MaintenanceScheduleCard({
    super.key,
    required this.vehicleName,
    required this.shopName,
    required this.startingDate,
    required this.startingTime,
    required this.maintenanceType,
    required this.startingKm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: ColorStyle.primaryColor,
              // blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Driver Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomBottomSheetButton(
                  label: 'Add',
                  icon: Icons.add,
                  bottomSheet: const MaintenanceStatusSheet(),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildRow('Vehicle Name', vehicleName),
            const SizedBox(height: 8),
            _buildRow('Shop Name', shopName),
            const SizedBox(height: 8),
            _buildRow('Starting Date', startingDate),
            const SizedBox(height: 8),
            _buildRow('Starting Time', startingTime, isHighlight: true),
            const SizedBox(height: 8),
            _buildRow('Maintenance Type', maintenanceType, isHighlight: true),
            const SizedBox(height: 8),
            _buildRow('Starting Km', startingKm, isHighlight: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isHighlight ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
