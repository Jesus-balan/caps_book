import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatefulWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  State<LogoutConfirmationDialog> createState() =>
      _LogoutConfirmationDialogState();
}

class _LogoutConfirmationDialogState extends State<LogoutConfirmationDialog> {
  bool isLoggingOut = false;

  Future<void> handleLogout() async {
    setState(() {
      isLoggingOut = true;
    });

    await HiveService().clearAuthData();

    if (mounted) {
      Navigator.of(context).pop(); // Close dialog
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.logout, color: Colors.redAccent),
          SizedBox(width: 8),
          Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content:
          isLoggingOut
              ? const SizedBox(
                height: 60,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.redAccent),
                ),
              )
              : const Text("Are you sure you want to logout?"),
      actions:
          isLoggingOut
              ? []
              : [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: handleLogout,
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
    );
  }
}
