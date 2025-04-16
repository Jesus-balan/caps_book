import 'dart:convert';
import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/repositories/vechicle_filter_repository.dart';
import 'package:caps_book/features/presentation/widgets/common_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:caps_book/features/data/model/maintenance_response_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditMaintenanceSheet extends StatefulWidget {
  final TodayMaintenanceResult maintenance;
  final VoidCallback onUpdate;

  const EditMaintenanceSheet({super.key, required this.maintenance,required this.onUpdate,});

  @override
  State<EditMaintenanceSheet> createState() => _EditMaintenanceSheetState();
}

class _EditMaintenanceSheetState extends State<EditMaintenanceSheet> {
  late TextEditingController endKmController;
  late TextEditingController descriptionController;

  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;

  List<DropdownMenuItem<int>> vehicleItems = [];

  int? selectedVehicleId;

  Future<String?> fetchTodayUnplannedUuid() async {
    try {
      final token = await HiveService().getToken();
      final response = await http.get(
        Uri.parse(
          'https://cabs.zenvicsoft.com/driver/today-Unplanned/',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data']['results'];

        if (results != null && results.isNotEmpty) {
          final firstResult = results[0];
          final uuid = firstResult['uuid'];
          return uuid;
        } else {
          debugPrint('No unplanned maintenance found.');
        }
      } else {
        debugPrint('Failed to fetch UUID: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching UUID: $e');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    endKmController = TextEditingController(
      text: widget.maintenance.endKm ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.maintenance.description ?? '',
    );

    startDate = DateTime.tryParse(widget.maintenance.startDate ?? '');
    endDate =
        widget.maintenance.endDate != null
            ? DateTime.tryParse(widget.maintenance.endDate!)
            : null;

    loadFilterData();
  }

  // Load vehicle and workshop data
  Future<void> loadFilterData() async {
    final response = await VehicleFilterService().fetchVehicleFilters();
    if (response != null) {
      setState(() {
        vehicleItems =
            response.filterData.vehicles
                .map(
                  (v) => DropdownMenuItem(value: v.id, child: Text(v.identity)),
                )
                .toList();
        selectedVehicleId =
            response.filterData.vehicles.isNotEmpty
                ? response.filterData.vehicles.first.id
                : null;
      });
    } else {
      showSnackbar("Failed to fetch filter data", isError: true);
    }
  }

  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : ColorStyle.primaryColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandle(),
            Text(
              'Edit Maintenance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),

            /// Vehicle Dropdown
            /// Form Fields
            CommonDropdownField<int>(
              key: ValueKey('vehicle_$selectedVehicleId'),
              label: "Vehicle Name",
              items: vehicleItems,
              value: selectedVehicleId,
              onChanged: (val) => setState(() => selectedVehicleId = val),
              validator:
                  (val) => val == null ? 'Please select a vehicle' : null,
            ),

            /// Start Date
            _buildDatePickerField('Start Date', startDate, (picked) {
              setState(() => startDate = picked);
            }),

            /// End Date
            _buildDatePickerField('End Date', endDate, (picked) {
              setState(() => endDate = picked);
            }),

            const SizedBox(height: 12),

            /// End KM
            TextField(
              controller: endKmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'End KM',
                filled: true, // ✅ Make the field filled
                fillColor: Colors.white, // ✅ White background
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// Description
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// Save Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.070,
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            setState(() {
                              isLoading = true;
                            });

                            final uuid = await fetchTodayUnplannedUuid();
                            if (uuid == null) {
                              setState(() {
                                isLoading = false;
                              });
                              showSnackbar(
                                "Failed to get maintenance UUID",
                                isError: true,
                              );
                              return;
                            }

                            final uri = Uri.parse(
                              'https://cabs.zenvicsoft.com/driver/maintenance/cud/$uuid/',
                            );
                            final token = await HiveService().getToken();

                            final body = {
                              "vehicle": selectedVehicleId,
                              "start_date": startDate?.toIso8601String(),
                              "end_date": endDate?.toIso8601String(),
                              "end_km": endKmController.text,
                              "description": descriptionController.text,
                              "maintenance_status": "Unplanned",
                            };

                            try {
                              final response = await http.patch(
                                uri,
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization': 'Bearer $token',
                                },
                                body: jsonEncode(body),
                              );

                              setState(() {
                                isLoading = false;
                              });

                              if (response.statusCode == 200 ||
                                  response.statusCode == 204) {
                                showSnackbar(
                                  "Maintenance updated successfully",
                                );
                                widget.onUpdate(); // 👈 Refresh the parent list
                                Navigator.pop(context);
                              } else {
                                showSnackbar(
                                  "Failed: ${response.statusCode}",
                                  isError: true,
                                );
                              }
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              showSnackbar("Error: $e", isError: true);
                            }
                          },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyle.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      height: 5,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildDatePickerField(
    String label,
    DateTime? selectedDate,
    void Function(DateTime) onPicked,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onPicked(picked);
      },
      child: _buildReadOnlyField(
        label,
        selectedDate != null
            ? DateFormat('MMM dd, yyyy').format(selectedDate)
            : 'Select $label',
        isEditable: true,
      ),
    );
  }

  Widget _buildReadOnlyField(
    String label,
    String value, {
    bool isEditable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: isEditable ? Colors.white : Colors.grey[100],
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    endKmController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
