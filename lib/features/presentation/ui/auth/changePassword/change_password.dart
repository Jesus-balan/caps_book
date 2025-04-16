import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/presentation/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final String apiUrl =
      "https://cabs.zenvicsoft.com/customer/change/password/";

  Future<void> changePassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!_formKey.currentState!.validate()) {
      return; // Skip API call if validation fails
    }

    // Validate password match (this validator is also in the Form, but reinforcing here)
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final token = await HiveService().getToken();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Show success message and clear text fields
      showCustomSnackbar(
        context: context,
        title: "Success",
        message: "Password changed successfully",
        isSuccess: true,
      );

      // Navigate to Home screen after short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/bottombar');
      });

      // Clear both text fields
      newPasswordController.clear();
      confirmPasswordController.clear();
    } else {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final errorMessage =
            responseData['message'] ??
            'Unexpected error occurred. Please try again later.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected error occurred. Please try again later.'),
          ),
        );
      }
    }
  }

  void showCustomSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => SnackbarWidget(
            title: title,
            message: message,
            isSuccess: isSuccess,
            onClose: () => overlayEntry.remove(),
          ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Change Password"),
          backgroundColor: ColorStyle.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.03,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [              
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Image.asset(
                    'assets/images/changePass.png',
                    height: screenHeight * 0.22,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
      
                // New Password
                Text(
                  "New Password",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: !isNewPasswordVisible,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
      
                  decoration: InputDecoration(
                    hintText: "Enter new password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isNewPasswordVisible = !isNewPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
      
                const SizedBox(height: 20),
      
                // Confirm Password
                Text(
                  "Confirm Password",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
      
                  obscureText: !isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Re-enter password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible =
                              !isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
      
                SizedBox(height: screenHeight * 0.05),
      
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      backgroundColor: ColorStyle.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: changePassword,
                    child:
                        _isLoading
                            ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              "Change Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
