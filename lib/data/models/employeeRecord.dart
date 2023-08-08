// ignore_for_file: file_names
class EmployeeRecord {
  String date;
  String check;
  String recordType;

  EmployeeRecord({
    required this.date,
    required this.check,
    required this.recordType,
  });

  factory EmployeeRecord.fromJson(Map<String, dynamic> json) {
    return EmployeeRecord(
      date: json['date'],
      check: json['check'],
      recordType: json['recordType'],
    );
  }
}
