import 'dart:convert';
import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/core/network/hive_service.dart';
import 'package:caps_book/features/data/model/check_record.dart';
import 'package:caps_book/features/presentation/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLoading = false;
  bool isPunchedIn = false;
  List<CheckRecord> history = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  List<CheckRecord> _selectedDateRecords = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Set today initially
    _loadPunchState();
    _loadHistory().then((_) {
      _filterRecordsForSelectedDate(); // optional filter after loading
    });
  }

  void _filterRecordsForSelectedDate() {
    setState(() {
      _selectedDateRecords =
          history.where((record) {
            return record.checkDate ==
                DateFormat('yyyy-MM-dd').format(_selectedDate!);
          }).toList();
    });
  }

  Future<void> _loadPunchState() async {
    final box = Hive.box('attendanceBox');
    final punchedInState = box.get('isPunchedIn', defaultValue: false);
    setState(() {
      isPunchedIn = punchedInState;
    });
  }

  String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return 'N/A';
    try {
      final time = DateFormat(
        'HH:mm:ss',
      ).parse(timeString); // if your time is like "14:10:00"
      return DateFormat('hh:mm a').format(time); // "02:10 PM"
    } catch (e) {
      return timeString; // fallback in case of format mismatch
    }
  }

  Future<void> _loadHistory() async {
    try {
      final fetched = await fetchAttendanceHistory();
      setState(() {
        history = fetched;
      });
    } catch (e) {
      print("Error loading history: $e");
    }
  }

  Future<List<CheckRecord>> fetchAttendanceHistory() async {
    final token = await HiveService().getToken();
    final url = Uri.parse(
      'https://h5r5msdk-1111.inc1.devtunnels.ms/driver/checkin/retrieve/',
    );
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List<dynamic> records = data['data']['check_data'];
        return records.map((item) => CheckRecord.fromJson(item)).toList();
      }
    }
    throw Exception("Failed to load attendance history");
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

  Future<void> handlePunch() async {
    setState(() => isLoading = true);

    final token = await HiveService().getToken();
    final url = Uri.parse(
      'https://h5r5msdk-1111.inc1.devtunnels.ms/driver/check/in/out/',
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
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final box = Hive.box('attendanceBox');
        await box.put('isPunchedIn', !isPunchedIn);
        setState(() {
          isPunchedIn = !isPunchedIn;
        });
        await _loadHistory(); // Refresh after punch

        showCustomSnackbar(
          context: context,
          title: isPunchedIn ? "Check-In Successful" : "Check-Out Successful",
          message: "Your attendance has been recorded.",
          isSuccess: true,
        );
      } else if (responseData['status'] == "error") {
        showCustomSnackbar(
          context: context,
          title: "Error",
          message:
              isPunchedIn
                  ? "You have already punched out today."
                  : "You have already punched in today.",
          isSuccess: false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Network error! Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error! Please try again.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildCalendar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
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
        lastDay: DateTime.now(),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
            _focusedDay = focusedDay;
            _selectedDateRecords =
                history.where((record) {
                  return record.checkDate ==
                      DateFormat('yyyy-MM-dd').format(selectedDay);
                }).toList();
          });
        },
        enabledDayPredicate: (date) {
          return !date.isAfter(DateTime.now()); // 👈 disables future taps
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: ColorStyle.primaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: isPunchedIn ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          weekendTextStyle: TextStyle(color: Colors.red[400]),
        ),
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

        // 💡 Add this part bro 👇
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final formattedDay = DateFormat('yyyy-MM-dd').format(day);
            final recordList =
                history.where((r) => r.checkDate == formattedDay).toList();

            final CheckRecord? record =
                recordList.isNotEmpty ? recordList.first : null;

            if (record != null) {
              final bool punched = record.checkIn != null;
              return Container(
                decoration: BoxDecoration(
                  color: punched ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    if (_selectedDate == null) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text("Please select a date to view attendance."),
      );
    }

    if (_selectedDateRecords.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "No records found for ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}",
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _selectedDateRecords.length,
      itemBuilder: (context, index) {
        final record = _selectedDateRecords[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: ColorStyle.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    "Date: ${record.checkDate}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.login, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    "Check-In: ${formatTime(record.checkIn) ?? '--'}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.logout, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    "Check-Out: ${formatTime(record.checkOut) ?? '--'}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Attendance"),
        backgroundColor: ColorStyle.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCalendar(context),
            const SizedBox(height: 10),
            _buildHistoryList(),
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
                    backgroundColor:
                        isPunchedIn ? Colors.green : ColorStyle.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
