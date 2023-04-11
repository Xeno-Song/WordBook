import 'package:intl/intl.dart';

class DateTimeFormatter {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');

  static String? format(DateTime? dateTime) {
    if (dateTime == null) return null;
    return _dateFormat.format(dateTime!);
  }

  static DateTime? parse(String? dateTime) {
    if (dateTime == null || dateTime == "") return null;
    return _dateFormat.parse(dateTime!);
  }
}
