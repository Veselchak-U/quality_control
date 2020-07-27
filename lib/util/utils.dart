import 'package:quality_control/entity/interval.dart';

class Utils {
  static String extractDate(DateTime date) {
    String result;
    if (date != null) {
      result =
          '${withLeadingZero(date.day)}.${withLeadingZero(date.month)}.${date.year}';
    }
    return result;
  }

  static String extractIntervalTime(Interval interval) {
    String result;
    if (interval != null) {
      var hh1 = withLeadingZero(interval.dateBegin.hour);
      var mm1 = withLeadingZero(interval.dateBegin.minute);
      var hh2 = withLeadingZero(interval.dateEnd.hour);
      var mm2 = withLeadingZero(interval.dateEnd.minute);
      result = '$hh1:$mm1 - $hh2:$mm2';
    }
    return result;
  }

  static String withLeadingZero(int number) {
    String result;
    if (number != null) {
      result = '${number < 10 ? 0 : ''}$number';
    }
    return result;
  }
}
