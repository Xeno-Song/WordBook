import 'package:intl/intl.dart';

class DateTimeFormatter {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');

  static String format(DateTime dateTime) => _dateFormat.format(dateTime);
  static DateTime parse(String dateTime) => _dateFormat.parse(dateTime);
}
