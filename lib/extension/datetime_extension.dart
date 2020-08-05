import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toStringForJson() {
    return '$year${_withLeadZero(month)}${_withLeadZero(day)}';
  }

  String formatDate(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String dateForHuman() {
    String result; // sample = '01.02.2020'
    if (this == null) {
      result = null;
    } else {
      result = '${_withLeadZero(day)}.${_withLeadZero(month)}.$year';
    }
    return result;
  }

  String dateTimeForHuman() {
    String result; // sample = '01.02.20 19:09'
    if (this == null) {
      result = null;
    } else {
      result =
          '${_withLeadZero(day)}.${_withLeadZero(month)}.$year ${_withLeadZero(hour)}:${_withLeadZero(minute)}';
    }
    return result;
  }

  DateTime trunc() {
    DateTime result;
    if (this != null) {
      result = DateTime(year, month, day);
    }
    return result;
  }

  String _withLeadZero(int number) {
    String result;
    if (number != null) {
      result = '${number < 10 ? 0 : ''}$number';
    }
    return result;
  }
}
