import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/repositories/unplaned_response_repository.dart';
import 'package:caps_book/features/data/repositories/vechicle_filter_repository.dart';
import 'package:caps_book/features/presentation/widgets/common_datefield.dart';
import 'package:caps_book/features/presentation/widgets/common_dropdown.dart';
import 'package:caps_book/features/presentation/widgets/common_input_field.dart';
import 'package:flutter/material.dart';

class UnplannedMaintenanceSheet extends StatefulWidget {
  const UnplannedMaintenanceSheet({super.key});

  @override
  State<UnplannedMaintenanceSheet> createState() =>
      _UnplannedMaintenanceSheetState();
}

class _UnplannedMaintenanceSheetState extends State<UnplannedMaintenanceSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<int>> vehicleItems = [];

  int? selectedVehicleId;
  bool isLoading = false;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController endKmController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFilterData();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    endKmController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    costController.dispose();
    super.dispose();
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

  String formatDateToIso(String inputDate) {
    final parts = inputDate.split('/');
    if (parts.length != 3) return inputDate;
    return '${parts[2]}-${parts[1]}-${parts[0]}T00:00:00+05:30';
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


  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final body = {
      "vehicle": selectedVehicleId,
      "start_date": formatDateToIso(startDateController.text),
      "end_date": formatDateToIso(endDateController.text),
      "end_km": int.tryParse(endKmController.text) ?? 0,
      "description": descriptionController.text.trim(),
      "maintenance_status": "Unplanned",
      "cost": costController.text.trim(),
    };

    final result = await MaintenanceService().createMaintenance(body);

    setState(() => isLoading = false);

    if (result != null && result.status == "success") {
      showSnackbar("✅ Maintenance added successfully");
      Navigator.pop(context);
    } else {
      showSnackbar("❌ Failed to submit maintenance", isError: true);
    }
  }

  String? fieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    return Padding(
      padding: EdgeInsets.only(
        top: 0.02 * screenHeight,
        left: 0.05 * screenWidth,
        right: 0.05 * screenWidth,
        bottom: media.viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Maintenance Sheet',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),

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
              SizedBox(height: screenHeight * 0.015),

              CommonDatePickerField(
                label: 'Start Date',
                controller: startDateController,
              ),
              SizedBox(height: screenHeight * 0.015),

              CommonDatePickerField(
                label: 'End Date',
                controller: endDateController,
              ),
              SizedBox(height: screenHeight * 0.015),

              CommonTextField(
                label: 'End Km',
                controller: endKmController,
                validator: fieldValidator,
              ),
              SizedBox(height: screenHeight * 0.015),

              CommonTextField(
                label: 'Cost',
                controller: costController,
                validator: fieldValidator,
              ),
              SizedBox(height: screenHeight * 0.015),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                validator: fieldValidator,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                ),
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.03),

              /// Submit Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.070,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleSubmit,
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
      ),
    );
  }
}
