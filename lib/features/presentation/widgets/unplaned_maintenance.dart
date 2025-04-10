import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/common_datefield.dart';
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
            CommonTextField(
              label: 'Vehicle Name',
              controller: vehicleNameController,
              validator: fieldValidator,
            ),
            const SizedBox(height: 10),

            CommonTextField(
              label: 'Workshop Name',
              controller: workShopNameController,
              validator: fieldValidator,
            ),
            const SizedBox(height: 10),

            CommonTextField(
              label: 'Start Km',
              controller: startKmController,
              validator: fieldValidator,
            ),
            const SizedBox(height: 10),
            CommonDatePickerField(
                label: 'Start Date', controller: startDateController),
            const SizedBox(height: 10),
            /// 📎 Bill Upload Field
            Text(
              'Issue photo',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: pickFile,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        selectedFile != null
                            ? selectedFile!.name
                            : 'Choose a file',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Icon(Icons.upload_file, color: Colors.grey),
                  ],
                ),
              ),
            ),
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
                      // You can validate here and upload the file
                      if (selectedFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please upload a bill")),
                        );
                      } else {
                        // Submit logic here
                      }
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
