import 'package:quality_control/entity/work_interval.dart';

class Utils {
  static int _nextEventId = 1000;

  static int get nextEventId => _nextEventId++;

  static WorkInterval getNearestInterval({List<WorkInterval> intervals}) {
    var now = DateTime.now();
    WorkInterval nearestInterval = intervals[0];
    int minDifference = 999999;
    int differenceDateBegin;
    int differenceDateEnd;

    intervals.forEach((currInterval) {
      differenceDateBegin = currInterval.dateBegin.difference(now).inSeconds.abs();
      if (differenceDateBegin < minDifference) {
        minDifference = differenceDateBegin;
        nearestInterval = currInterval;
      }
      differenceDateEnd = currInterval.dateEnd.difference(now).inSeconds.abs();
      if (differenceDateEnd < minDifference) {
        minDifference = differenceDateEnd;
        nearestInterval = currInterval;
      }
    });
    return nearestInterval;
  }
}
