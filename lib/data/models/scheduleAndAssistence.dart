// ignore_for_file: file_names
import 'package:time_track/data/models/employeeRecord.dart';
import 'package:time_track/data/models/employeeSchedule.dart';

class ScheduleAndAssistence {
  final String nameSchedule;
  final EmployeeSchedule currenteSchedule;
  EmployeeRecord? lastRecord;

  ScheduleAndAssistence({
    required this.nameSchedule,
    required this.currenteSchedule,
    this.lastRecord,
  });

  factory ScheduleAndAssistence.fromJson(Map<String, dynamic> json) {
    return ScheduleAndAssistence(
      nameSchedule: json['nameSchedule'],
      currenteSchedule: EmployeeSchedule.fromJson(json['currentSchedule']),
      lastRecord: json['lastRecord'] == null
          ? null
          : EmployeeRecord.fromJson(json['lastRecord']),
    );
  }
}
