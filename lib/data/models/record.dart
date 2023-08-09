class Record {
  String checkIn;
  String checkOut;
  String date;

  Record({
    required this.checkIn,
    required this.checkOut,
    required this.date,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      date: formatdDate(json['date']),
    );
  }
}

String formatdDate(String date) {
  final dayOfWeek = ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'];
  final monthOfYear = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembew',
    'Diciembre'
  ];

  final format = DateTime.parse(date);
  final weekDay = dayOfWeek[format.weekday];
  String day = format.day.toString();
  day = day.length == 1 ? '0$day' : day;

  final month = monthOfYear[format.month - 1];
  final year = format.year;
  return '$weekDay$day $month $year $day/$month/$year';
}
