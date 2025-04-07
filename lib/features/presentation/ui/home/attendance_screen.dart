import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Format time to AM/PM
  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  // Check if user is within 100 meters of the target location
 Future<bool> isWithinRange() async {
  // Check if Location Services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return false;
  }

  // Check for Permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }

  if (permission == LocationPermission.deniedForever) return false;

  try {
    // Fetch Updated Location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // Optimized for Android
      timeLimit: Duration(seconds: 10), // Avoids outdated location
    );

    debugPrint("Updated Location: ${position.latitude}, ${position.longitude}");

    // Your Office Coordinates
    const double targetLatitude = 8.509175;
    const double targetLongitude = 77.558198;

    // Calculate Distance
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      targetLatitude,
      targetLongitude,
    );

    debugPrint("Current Distance: $distanceInMeters meters");
    debugPrint("Current Location: ${position.latitude}, ${position.longitude}");

    return distanceInMeters <= 200; // Returns true if within range
  } catch (e) {
    debugPrint("Error fetching location: $e");
    return false;
  }
}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceBloc(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Attendance"),
          centerTitle: true,
          backgroundColor: ColorStyle.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: Column(
          children: [
            // 📅 Calendar
            _buildCalendar(),

            const SizedBox(height: 10),

            // ⏰ Attendance Status
            BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is PunchOutSuccess) {
                  return Column(
                    children: [
                      _statusCard(
                        title: "Punch In Time",
                        time: state.punchInTime,
                        color: Colors.green,
                        icon: Icons.access_time,
                      ),
                      _statusCard(
                        title: "Punch Out Time",
                        time: state.punchOutTime,
                        color: Colors.red,
                        icon: Icons.logout,
                      ),
                    ],
                  );
                } else if (state is PunchInSuccess) {
                  return _statusCard(
                    title: "Punch In Time",
                    time: state.punchInTime,
                    color: Colors.green,
                    icon: Icons.access_time,
                  );
                } else if (state is AttendanceError) {
                  return Text(state.message, style: const TextStyle(color: Colors.red));
                }
                return const SizedBox();
              },
            ),

            const SizedBox(height: 10),

            // 📍 Punch Button
            BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                final bool isPunchedIn = state is PunchInSuccess;
                final bool isPunchedOut = state is PunchOutSuccess;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: isPunchedOut
                          ? null
                          : () async {
                              final bool inRange = await isWithinRange();
                              if (!inRange) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("You must be within 200 meters of the office to punch in/out."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final bloc = context.read<AttendanceBloc>();
                              if (!isPunchedIn) {
                                bloc.add(PunchInEvent());
                              } else {
                                bloc.add(PunchOutEvent());
                              }
                            },
                      icon: Icon(isPunchedIn ? Icons.logout : Icons.login, size: 20),
                      label: Text(
                        isPunchedIn ? "Punch Out" : "Punch In",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPunchedOut
                            ? Colors.grey
                            : (isPunchedIn ? Colors.red : Colors.deepPurpleAccent),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 📅 Table Calendar Widget
  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        onDaySelected: (selectedDay, _) {
          if (selectedDay.isAfter(DateTime.now())) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You cannot select a future date'),
                backgroundColor: Colors.amber,
              ),
            );
          } else {
            context.read<AttendanceBloc>().add(SelectDateEvent(selectedDay));
          }
        },
      ),
    );
  }

  // ⏰ Attendance Status Card Widget
  Widget _statusCard({
    required String title,
    required DateTime time,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(formatTime(time),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
        ],
      ),
    );
  }
}
