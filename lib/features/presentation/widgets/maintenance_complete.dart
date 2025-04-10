import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/common_dropdown.dart';
import 'package:caps_book/features/presentation/widgets/common_input_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MaintenanceComplete extends StatefulWidget {
  const MaintenanceComplete({super.key});

  @override
  State<MaintenanceComplete> createState() => _MaintenanceCompleteState();
}

class _MaintenanceCompleteState extends State<MaintenanceComplete> {
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
  String? enquiryStatus;
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController workshopNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startKmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          const SizedBox(height: 15),
          /// Cost Field
          CommonTextField(
            label: 'End KM',
            controller: startKmController,
            validator: fieldValidator,
          ),
          const SizedBox(height: 15),
          CommonDropdownField(
            label: 'Enquiry Status',
            items: ['Completed', 'In-Progress'],
            value: enquiryStatus,
            onChanged: (val) => setState(() => enquiryStatus = val),
            validator: (val) => val == null ? 'Please select status' : null,
          ),
          const SizedBox(height: 15),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: ColorStyle.primaryColor,
                  ),
                  child: const Text(
                    'Sumit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
