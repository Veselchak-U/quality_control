
// Интервал работы по заявке
class WorkInterval {
  WorkInterval({this.id, this.dateBegin, this.dateEnd});

  String id;
  DateTime dateBegin;
  DateTime dateEnd;

  String intervalTimes() {
    String result;
    if (this != null) {
      var hh1 = _withLeadZero(dateBegin.hour);
      var mm1 = _withLeadZero(dateBegin.minute);
      var hh2 = _withLeadZero(dateEnd.hour);
      var mm2 = _withLeadZero(dateEnd.minute);
      result = '$hh1:$mm1 - $hh2:$mm2';
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
