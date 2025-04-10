import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/presentation/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLoading = false;
  bool isPunchedIn = false;

  @override
  void initState() {
    super.initState();
    _loadPunchState();
  }

  Future<void> _loadPunchState() async {
    final box = Hive.box('attendanceBox');
    final punchedInState = box.get('isPunchedIn', defaultValue: false);
    setState(() {
      isPunchedIn = punchedInState;
    });
  }

  // snackbar
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
            onClose: () {
              overlayEntry.remove();
            },
          ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  Future<void> handlePunch() async {
    setState(() {
      isLoading = true;
    });

    final token = await HiveService().getToken();
    final url = Uri.parse(
      'https://39jjhf8l-1000.inc1.devtunnels.ms/driver/check/in/out/',
    );
    final now = DateTime.now();

    final body = {
      "latitude": "8.509175",
      "longitude": "77.558198",
      "check_date": DateFormat('yyyy-MM-dd').format(now),
      isPunchedIn ? "check_out" : "check_in": DateFormat(
        'HH:mm:ss',
      ).format(now),
    };

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body); // ✅ Important fix

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final box = Hive.box('attendanceBox');
        await box.put('isPunchedIn', !isPunchedIn);

        setState(() {
          isPunchedIn = !isPunchedIn;
        });

        showCustomSnackbar(
          context: context,
          title: isPunchedIn ? "Check-Out Successful" : "Check-In Successful",
          message: "Your attendance has been recorded.",
          isSuccess: true,
        );
      } else if (responseData['status'] == "error") {
        final errorMsg =
            responseData['data']['error'] ?? "Something went wrong.";
        showCustomSnackbar(
          context: context,
          title: "Error",
          message: "Something went wrong. Please try again.",
          isSuccess: false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Network error! Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error! Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildCalendar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      width: screenWidth * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorStyle.primaryColor,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: ColorStyle.primaryColor,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: ColorStyle.primaryColor,
          ),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: ColorStyle.primaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: ColorStyle.primaryColor,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          weekendTextStyle: TextStyle(color: Colors.red[400]),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(day, DateTime.now());
        },
        onDaySelected: (_, __) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Attendance"),
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: 25,
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {},
            iconSize: 25,
            icon: const Icon(Icons.person),
          ),
        ],
        backgroundColor: ColorStyle.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCalendar(context),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : handlePunch,
                  icon:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Icon(
                            isPunchedIn ? Icons.logout : Icons.login,
                            size: 20,
                          ),
                  label: Text(
                    isLoading
                        ? "Loading..."
                        : (isPunchedIn ? "Punch Out" : "Punch In"),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
