import 'package:caps_book/features/presentation/widgets/custom_add_button.dart';
import 'package:caps_book/features/presentation/widgets/maintennance_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 5,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Maintenance Sheet',
                    style: TextStyle(
                      fontSize: 22,
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
              _buildRow('Shop Name', shopName),
              const SizedBox(height: 8),
              _buildRow('Starting Date', startingDate),
              _buildRow('Starting Time', startingTime, isHighlight: true),
              const SizedBox(height: 8),
              _buildRow('Maintenance Type', maintenanceType, isHighlight: true),
              _buildRow('Starting Km', startingKm, isHighlight: true),
            ],
          ),
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
