part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class PunchInSuccess extends AttendanceState {
  final DateTime punchInTime;
  PunchInSuccess(this.punchInTime);
}

class PunchOutSuccess extends AttendanceState {
  final DateTime punchInTime;
  final DateTime punchOutTime; // Ensure this is present

  PunchOutSuccess({required this.punchInTime, required this.punchOutTime});
}


class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);
}
