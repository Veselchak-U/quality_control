import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/interval.dart';
import 'package:quality_control/entity/user.dart';

// Заявка
class Request {
  Request(
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
  List<Interval> intervals; // список интервалов работы
  String routeFrom; // маршрут откуда
  String routeTo; // маршрут куда
  String routeDescription; // маршрут доп. описание
  String customer; // заказчик
  User customerDelegat; // представитель заказчика
  String comment; // последний комментарий к заявке
  String note; // примечание к заявке
  List<Event> events; // события по заявке
  bool isReadOnly; // чужая заявка, только на чтение

  String intervalsToString() {
    String result = '';
    // TODO(dyv): доделать
    return result;
  }
}
