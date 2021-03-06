import 'package:flutter/foundation.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/user.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/extension/datetime_extension.dart';

// Заявка - элемент списка
class RequestItem {
  RequestItem(
      {this.id,
      this.number,
      this.dateFrom,
      this.dateTo,
      this.intervals,
      this.routeFrom,
      this.routeTo,
      this.routeDescription,
      this.customer,
      this.customerDelegat,
      this.comment,
      this.note,
      this.events,
      this.isReadOnly});

  String id;
  int number;
  DateTime dateFrom; // дата работы "с"
  DateTime dateTo; // дата работы "по"
  List<WorkInterval> intervals; // список интервалов работы
  String routeFrom; // маршрут откуда
  String routeTo; // маршрут куда
  String routeDescription; // маршрут доп. описание
  String customer; // заказчик
  User customerDelegat; // представитель заказчика
  String comment; // последний комментарий к заявке
  String note; // примечание к заявке
  List<Event> events; // события по заявке
  bool
      isReadOnly; // чужая заявка, только на чтение (своё подразделение, но другой представитель)

  String allIntervalsToString() {
    String result = '';
    if (intervals != null && intervals.isNotEmpty) {
      Set<String> set = <String>{};
      intervals.forEach((WorkInterval i) {
        set.add(i.toString());
      });
      var sortList = set.toList();
      sortList.sort();
      result = sortList.join(', ');
    }

    return result;
  }

  List<DateTime> getDatesFromIntervals({bool withoutFuture}) {
    // признак фильтра дат по "не далее чем сегодня"
    withoutFuture ??= false;
    List<DateTime> result = [];

    if (intervals != null && intervals.isNotEmpty) {
      Set<DateTime> set = <DateTime>{};
      if (withoutFuture) {
        var today = DateTime.now().trunc();
        intervals.forEach((WorkInterval i) {
          if (i.dateBegin.trunc().compareTo(today) <= 0) {
            set.add(i.dateBegin.trunc());
          }
        });
      } else {
        intervals.forEach((WorkInterval i) {
          set.add(i.dateBegin.trunc());
        });
      }

      List<DateTime> sortedList = set.toList();
      sortedList.sort();
      result = sortedList;
    }

    return result;
  }

  List<WorkInterval> getIntervalsByDate({@required DateTime date}) {
    List<WorkInterval> result = [];

    if (date != null && intervals != null && intervals.isNotEmpty) {
      List<WorkInterval> shortList = intervals
          .where((WorkInterval e) => e.dateBegin.trunc() == date.trunc())
          .toList();

      if (shortList.isNotEmpty) {
        result = shortList;
      }
    }
    return result;
  }
}
