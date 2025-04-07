import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/widgets/common_dropdown.dart';
import 'package:caps_book/features/presentation/widgets/common_input_field.dart';
import 'package:flutter/material.dart';

class MaintenanceStatusSheet extends StatefulWidget {
  const MaintenanceStatusSheet({super.key});

  @override
  State<MaintenanceStatusSheet> createState() => _MaintenanceStatusSheetState();
}

class _MaintenanceStatusSheetState extends State<MaintenanceStatusSheet> {

  // validation
  String? fieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field is required';
    } 
    return null;
  }
  // Selected dropdown values
  String? enquiryStatus;
  final TextEditingController costController = TextEditingController();
  final TextEditingController endKmController = TextEditingController();

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

          /// Dropdown for Status
          CommonDropdownField(
            label: 'Enquiry Status',
            items: ['Completed', 'In-Progress'],
            value: enquiryStatus,
            onChanged: (val) => setState(() => enquiryStatus = val),
            validator: (val) => val == null ? 'Please select status' : null,
          ),
          const SizedBox(height: 10),

          /// Cost Field
          CommonTextField(label: 'Amount', controller: costController, validator: fieldValidator,),

          const SizedBox(height: 10),

          /// Cost Field
          CommonTextField(label: 'End km', controller: endKmController, validator: fieldValidator,),

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
