part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {}

class PunchInEvent extends AttendanceEvent {}

class PunchOutEvent extends AttendanceEvent {}

class SelectDateEvent extends AttendanceEvent{
  final DateTime selectedDate;
 SelectDateEvent(this.selectedDate);
}