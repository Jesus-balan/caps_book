import 'dart:io';

import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/core/utils/snackbar_utils.dart';
import 'package:caps_book/features/data/model/customer_details.dart';
import 'package:caps_book/features/data/repositories/customer_repository.dart';
import 'package:caps_book/features/data/repositories/image_upload_repository.dart';
import 'package:caps_book/features/data/repositories/update_customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:caps_book/features/presentation/widgets/logout_widget.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: ColorStyle.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<UserModel>(
        future: CustomerService.fetchDriverDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          final user = snapshot.data!;
          final driver = user.data.driver;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildHeader(
                          driver.identity,
                          driver.driverId,
                          driver.profilePhoto?.file ??
                              'https://i.pinimg.com/736x/f4/da/2e/f4da2e4e4bbff668b24b17f68eabeb72.jpg',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              EditableSection(
                                address: driver.address,
                                email: driver.email,
                              ),
                              buildEditableField(
                                "📞 Phone Number",
                                user.data.phoneNumber,
                              ),
                              buildEditableField(
                                "🎂 Date of Birth",
                                driver.dob,
                              ),
                              buildEditableField(
                                "🪪 License Number",
                                driver.licenseNo,
                              ),
                              buildEditableField(
                                "🆔 Aadhar Number",
                                driver.aadharNo,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: buildImageViewer(
                                      context,
                                      "License",
                                      driver.licensePhoto.file,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: buildImageViewer(
                                      context,
                                      "Aadhar",
                                      driver.aadharPhoto.file,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    settingsTile(
                      () {
                        Navigator.pushNamed(context, '/resetPass');
                      },
                      Icons.lock,
                      "Change Password",
                    ),
                    settingsTile(
                      () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => LogoutConfirmationDialog(),
                        );
                      },
                      Icons.logout,
                      "Logout",
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildHeader(String name, String id, String profilePath) {
    final String imageUrl = "https://cabs.zenvicsoft.com$profilePath";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: ColorStyle.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          // Profile Image with camera icon
          Stack(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://i.pinimg.com/736x/f4/da/2e/f4da2e4e4bbff668b24b17f68eabeb72.jpg',
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (pickedFile != null) {
                      File imageFile = File(pickedFile.path);
                      await uploadAndUpdateProfileImage(imageFile);
                    } else {
                      print('⚠️ No image selected.');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: ColorStyle.primaryColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Name & ID
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF1FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "ID: $id",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildImageViewer(
    BuildContext context,
    String label,
    String imagePath,
  ) {
    final String fullImageUrl = "https://cabs.zenvicsoft.com$imagePath";

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullImageView(imageUrl: fullImageUrl),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              fullImageUrl,
              height: screenHeight * 0.15,
              width: screenWidth * 0.50,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget settingsTile(
    VoidCallback onPressed,
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onPressed,
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageUrl;

  const FullImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          // Zoom & Pan support
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class EditableSection extends StatefulWidget {
  final String address;
  final String email;

  const EditableSection({
    super.key,
    required this.address,
    required this.email,
  });

  @override
  State<EditableSection> createState() => _EditableSectionState();
}

class _EditableSectionState extends State<EditableSection> {
  late TextEditingController emailController;
  late TextEditingController addressController;
  bool isEditing = false;
  bool isSaving = false;
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
    addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Edit Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                icon: Icon(
                  isEditing ? Icons.close : Icons.edit,
                  color: ColorStyle.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: emailController,
            enabled: isEditing,
            decoration: InputDecoration(
              labelText: "📧 Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: addressController,
            maxLines: 2,
            enabled: isEditing,
            decoration: InputDecoration(
              labelText: "🏠 Address",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isEditing)
            ElevatedButton.icon(
              onPressed:
                  isSaving
                      ? null
                      : () async {
                        setState(() => isSaving = true);

                        String email = emailController.text.trim();
                        String addr = addressController.text.trim();
                        String? token = await HiveService().getToken();
                        if (token == null) return;

                        bool success = await DriverService.updateDriverDetails(
                          token: token,
                          email: email,
                          dob: "2007-03-01", // Replace with actual DOB
                          address: addr,
                        );

                        setState(() => isSaving = false);

                        if (success) {
                          AppUtils.showSnackbar(
                            context,
                            "Profile updated successfully",
                          );
                          setState(() => isEditing = false);
                        } else {
                          AppUtils.showSnackbar(
                            context,
                            "Failed to update profile",
                            isError: true,
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyle.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              icon:
                  isSaving
                      ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(Icons.save, color: Colors.white),
              label: Text(
                isSaving ? "Saving..." : "Save",
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
