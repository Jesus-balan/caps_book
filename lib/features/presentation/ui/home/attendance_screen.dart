import 'package:caps_book/features/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceBloc(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Attendance"),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: Column(
          children: [
            // Calendar
            Container(
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
                onDaySelected: (selectedDay, focusedDay) {
                  if (selectedDay.isAfter(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Future date not allowed'),
                        backgroundColor: Colors.amber,
                      ),
                    );
                  } else {
                    context.read<AttendanceBloc>().add(
                      SelectDateEvent(selectedDay),
                    );
                  }
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Status Display
            BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is PunchInSuccess) {
                  return _statusCard(
                    title: "Punch In Time",
                    time: state.punchInTime,
                    color: Colors.green,
                    icon: Icons.access_time,
                  );
                } else if (state is PunchOutSuccess) {
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
                } else if (state is AttendanceError) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const SizedBox();
              },
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<AttendanceBloc, AttendanceState>(
                  builder: (context, state) {
                    return _customButton(
                      title: "Punch In",
                      color: Colors.green,
                      icon: Icons.login,
                      onPressed:
                          (state is PunchInSuccess || state is PunchOutSuccess)
                              ? null
                              : () {
                                context.read<AttendanceBloc>().add(
                                  PunchInEvent(),
                                );
                              },
                    );
                  },
                ),
                const SizedBox(width: 15),
                BlocBuilder<AttendanceBloc, AttendanceState>(
                  builder: (context, state) {
                    return _customButton(
                      title: "Punch Out",
                      color: Colors.red,
                      icon: Icons.logout,
                      onPressed:
                          (state is PunchOutSuccess)
                              ? null
                              : () {
                                context.read<AttendanceBloc>().add(
                                  PunchOutEvent(),
                                );
                              },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard({required String title, required DateTime time, required Color color, required IconData icon}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                )),
            const SizedBox(height: 4),
            Text(formatTime(time),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
          ],
        ),
      ],
    ),
  );
}

  Widget _customButton({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
