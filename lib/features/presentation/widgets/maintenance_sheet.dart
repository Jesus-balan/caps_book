import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/repositories/today_maintenance_repository.dart';
import 'package:caps_book/features/presentation/widgets/common_input_field.dart';
import 'package:flutter/material.dart';

class MaintenanceStatusSheet extends StatefulWidget {
  final String maintenanceUuid;

  const MaintenanceStatusSheet({super.key, required this.maintenanceUuid});

  @override
  State<MaintenanceStatusSheet> createState() => _MaintenanceStatusSheetState();
}

class _MaintenanceStatusSheetState extends State<MaintenanceStatusSheet> {
  String? fieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  final completedAt = DateTime.now().toIso8601String();
  bool isLoading = false;

  final TextEditingController costController = TextEditingController();
  final TextEditingController endKmController = TextEditingController();

 @override
Widget build(BuildContext context) {
  return Wrap(
    children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Maintenance Sheet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 15),
  
            CommonTextField(
              keyboardType: TextInputType.number,
              label: 'Amount',
              controller: costController,
              validator: fieldValidator,
            ),
            const SizedBox(height: 10),
  
            CommonTextField(
              label: 'End km',
              controller: endKmController,
              validator: fieldValidator,
            ),
            const SizedBox(height: 20),
  
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text("Loading...", style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


  Future<void> _handleSubmit() async {
    final costText = costController.text.trim();
    final endKmText = endKmController.text.trim();

    if (costText.isEmpty || endKmText.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    final cost = double.tryParse(costText);
    final endKm = double.tryParse(endKmText);

    if (cost == null || endKm == null) {
      _showMessage("Please enter valid numbers");
      return;
    }

    setState(() => isLoading = true);

    try {
      await MaintenanceRepository().markMaintenanceComplete(
        uuid: widget.maintenanceUuid,
        endKm: endKm,
        cost: cost,
        completedAt: completedAt,
      );

      if (!mounted) return;

      setState(() => isLoading = false);
      _showSuccess("Maintenance completed successfully!");
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMessage("Failed to complete maintenance. Please try again.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text("Maintenance completed successfully!"),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
