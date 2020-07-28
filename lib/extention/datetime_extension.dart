extension DateTimeExtension on DateTime {
  String toStringForJson() {
    return '$year${_withLeadingZero(month)}${_withLeadingZero(day)}';
  }

  String toStringForHuman() {
    String result; // sample = '01.02.2020'
    if (this == null) {
      result = null;
    } else {
      result = '${_withLeadingZero(day)}.${_withLeadingZero(month)}.$year';
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

  String _withLeadingZero(int number) {
    String result;
    if (number != null) {
      result = '${number < 10 ? 0 : ''}$number';
    }
    return result;
  }

}
