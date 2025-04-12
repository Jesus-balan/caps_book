import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/common_datefield.dart';
import 'package:caps_book/features/presentation/widgets/common_dropdown.dart';
import 'package:caps_book/features/presentation/widgets/common_input_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UnplannedMaintenanceSheet extends StatefulWidget {
  const UnplannedMaintenanceSheet({super.key});

  @override
  State<UnplannedMaintenanceSheet> createState() =>
      _UnplannedMaintenanceSheetState();
}

class _UnplannedMaintenanceSheetState
    extends State<UnplannedMaintenanceSheet> {
  // validation
  String? fieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field is required';
    }
    return null;
  }

  // File Picker
  PlatformFile? selectedFile;

 Future<void> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    print("File picked: ${result.files.single.name}");
  } else {
    print("No file selected");
  }
}

  // Selected dropdown values
  String? vehicleName;
  String? WorkshopName;

  // Controllers
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController workShopNameController = TextEditingController();
  final TextEditingController startKmController = TextEditingController();
  final TextEditingController endKmController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Maintenance Sheet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// Form Fields
            CommonDropdownField(
              label: "Vehicle Name", items: ['None', 'r15', 'honda'], 
             onChanged: (val) => setState(() => vehicleName = val),
            validator: (val) => val == null ? 'Please select status' : null,
            ),
            const SizedBox(height: 10),

             CommonDropdownField(
              label: "Workshop Name", items: ['None','bajaj', 'yamaha', 'hero'], 
             onChanged: (val) => setState(() => WorkshopName = val),
            validator: (val) => val == null ? 'Please select status' : null,
            ),
            const SizedBox(height: 10),

            CommonTextField(
              label: 'Start Km',
              controller: startKmController,
              validator: fieldValidator,
            ),
            const SizedBox(height: 10),

            CommonTextField(
              label: 'End Km',
              controller: endKmController,
              validator: fieldValidator,
            ),
            const SizedBox(height: 10),
            CommonDatePickerField(
                label: 'Start Date', controller: startDateController),
            const SizedBox(height: 10),
            CommonDatePickerField(
                label: 'End Date', controller: endDateController),
            const SizedBox(height: 25),
            /// Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                     
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: ColorStyle.primaryColor,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
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
}
