import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/model/maintenance_response_model.dart';
import 'package:caps_book/features/data/repositories/maintenance_response_repository.dart';
import 'package:caps_book/features/presentation/widgets/custom_add_button.dart';
import 'package:caps_book/features/presentation/widgets/maintenanace_edit.dart';
import 'package:caps_book/features/presentation/widgets/maintenance_complete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceReport extends StatefulWidget {
  @override
  State<MaintenanceReport> createState() => _MaintenanceReportState();
}

class _MaintenanceReportState extends State<MaintenanceReport> {
  final UnplannedMaintenanceRepository repository =
      UnplannedMaintenanceRepository();
  late Future<TodayMaintenanceResponse> _maintenanceFuture;

  @override
  void initState() {
    super.initState();
    _loadMaintenance();
  }

  void _loadMaintenance() {
    _maintenanceFuture = repository.fetchUnplannedMaintenanceList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TodayMaintenanceResponse>(
      future: _maintenanceFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("");
        } else if (!snapshot.hasData || snapshot.data!.data.results.isEmpty) {
          return SizedBox();
        }

        final maintenance = snapshot.data!.data.results.first;
        final uuid = maintenance.uuid;
        final formattedDateTime = DateFormat(
          'MMM dd, yyyy hh:mm a',
        ).format(DateTime.parse(maintenance.startDate!));
        final costText =
            maintenance.cost?.isNotEmpty == true ? maintenance.cost! : 'N/A';

        final endDateTime =
            maintenance.endDate != null && maintenance.endDate!.isNotEmpty
                ? DateFormat(
                  'MMM dd, yyyy hh:mm a',
                ).format(DateTime.parse(maintenance.endDate!))
                : 'N/A';

        return GestureDetector(
          onTap: () {
          Navigator.pushNamed(context, '/emergency');
        },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              // boxShadow: [
              //   BoxShadow(
              //     color: ColorStyle.primaryColor,
              //     offset: const Offset(0, 6),
              //   ),
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Service',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
          
                /// ✅ Action Buttons with dynamic uuid
                Row(
                  children: [
                    Expanded(
                      child: CustomBottomSheetButton(
                        label: 'Edit',
                        icon: Icons.edit,
                        bottomSheet: Builder(
                          builder:
                              (context) => EditMaintenanceSheet(
                                maintenance: maintenance,
                                onUpdate: () {
                                  setState(() {
                                    _loadMaintenance();
                                  });
                                },
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomBottomSheetButton(
                        label: 'Complete',
                        icon: Icons.check_circle,
                        bottomSheet: MaintenanceComplete(uuid: uuid),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 12),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabeledText(
                      'Vehicle',
                      maintenance.vehicleDetails.identity ?? 'N/A',
                    ),
                    _buildLabeledText('Cost', costText),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabeledText('Start Date', formattedDateTime),
                    _buildLabeledText('End Date', endDateTime),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabeledText(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
