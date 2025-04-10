import 'package:caps_book/features/presentation/widgets/logout_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF3366FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(), // Use this instead of the previous header Container
            // Options List
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildEditableSection(context),
                        buildEditableField("📞 Phone Number", "9876543210"),
                        const SizedBox(height: 16),
                        buildEditableField("🪪 License Number", "TN01XXXXXX"),
                        buildEditableField(
                          "🆔 Aadhar Number",
                          "1234 5678 9012",
                        ),                        
                        buildImageViewer(
                          "License Photo",
                          "assets/images/license_sample.png",
                        ),
                        buildImageViewer(
                          "Aadhar Photo",
                          "assets/images/aadhar_sample.png",
                        ),
                      ],
                    ),
                  ),
                  // settingsTile(() {}, Icons.description, "Terms of Service"),
                  // settingsTile(() {}, Icons.privacy_tip, "Privacy Policy"),
                  settingsTile(() {}, Icons.lock, "Change Password"),
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
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Blue Curve
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Color(0xFF3366FF),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),

        // Profile Info Card
        Positioned(
          top: 50, // floats below the blue curve
          left: 20,
          right: 20,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // Circle Avatar
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage(
                    'assets/images/user.png',
                  ), // or NetworkImage
                ),
                SizedBox(width: 16),
                // Name and ID
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "David Arnold",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFEDF1FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "ID: 1259623",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Optional AppBar Icon (like settings / notification)
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            "Profile",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

 Widget buildEditableField(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Text(
          value,
          style: TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ),
      const SizedBox(height: 12),
    ],
  );
}

  Widget buildImageViewer(String label, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildEditableSection(BuildContext context) {
  final TextEditingController emailController = TextEditingController(text: "david@example.com");
  final TextEditingController addressController = TextEditingController(text: "123, Main Street, City");

  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Edit Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "📧 Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: addressController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: "🏠 Address",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            String email = emailController.text.trim();
            String address = addressController.text.trim();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3366FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: Size(double.infinity, 48),
          ),
          icon: Icon(Icons.save),
          label: Text("Save"),
        )
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
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onPressed,
    );
  }
}
