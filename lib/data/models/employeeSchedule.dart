// ignore_for_file: file_names
class EmployeeSchedule {
  String day;
  String startHour;
  String endHour;

  EmployeeSchedule({
    required this.day,
    required this.startHour,
    required this.endHour,
  });

  factory EmployeeSchedule.fromJson(Map<String, dynamic> json) {
    return EmployeeSchedule(
      day: json['day'],
      startHour: json['startHour'],
      endHour: json['endHour'],
    );
  }
}
