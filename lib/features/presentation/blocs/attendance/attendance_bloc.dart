import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  DateTime? _punchInTime;
  DateTime? _punchOutTime;

  AttendanceBloc() : super(AttendanceInitial()) {
    on<PunchInEvent>((event, emit) {
      if (_punchInTime == null) {
        _punchInTime = DateTime.now();
        emit(PunchInSuccess(_punchInTime!));
      }
    });

    on<PunchOutEvent>((event, emit) {
      if (_punchInTime != null && _punchOutTime == null) {
        _punchOutTime = DateTime.now();
        emit(PunchOutSuccess(punchInTime: _punchInTime!, punchOutTime: _punchOutTime!));
      } else if (_punchInTime == null) {
        emit(AttendanceError("Please Punch In first!"));
      }
    });

    on<SelectDateEvent>((event, emit) {
      _punchInTime = null;
      _punchOutTime = null;
      emit(AttendanceInitial());
    });
  }
}
