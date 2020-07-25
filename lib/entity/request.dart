import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/interval.dart';
import 'package:quality_control/entity/user.dart';

// Заявка
class Request {
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
}
