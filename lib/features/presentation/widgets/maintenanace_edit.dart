import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/common_datefield.dart';
import 'package:caps_book/features/presentation/widgets/common_input_field.dart';
import 'package:flutter/material.dart';

class MaintenanceEdit extends StatefulWidget {
  const MaintenanceEdit({super.key});

  @override
  State<MaintenanceEdit> createState() => _MaintenanceEditState();
}

class _MaintenanceEditState extends State<MaintenanceEdit> {
  // validation
  String? fieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field is required';
    }
    return null;
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
            label: 'Driver Name',
            controller: driverNameController,
            validator: fieldValidator,
          ),

          const SizedBox(height: 10),
          CommonTextField(
            label: 'Workshop Name',
            controller: workshopNameController,
            validator: fieldValidator,
          ),
          const SizedBox(height: 10),
          CommonDatePickerField(label: 'Date', controller: dateController),
          const SizedBox(height: 10),

          /// Cost Field
          CommonTextField(
            label: 'Start KM',
            controller: startKmController,
            validator: fieldValidator,
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
