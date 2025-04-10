import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatefulWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  State<LogoutConfirmationDialog> createState() => _LogoutConfirmationDialogState();
}

class _LogoutConfirmationDialogState extends State<LogoutConfirmationDialog> {
  bool isLoggingOut = false;

  void handleLogout() async {
    setState(() {
      isLoggingOut = true;
    });

    await HiveService().clearAuthData();

    Navigator.of(context).pop(); // close dialog

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
      content: isLoggingOut
          ? SizedBox(
              height: 60,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ),
              ),
            )
          : const Text("Are you sure you want to logout?"),
      actions: isLoggingOut
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
