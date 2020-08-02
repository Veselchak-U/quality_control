import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/entity/user.dart';

class RequestIntervalItem {
  RequestIntervalItem(
      {this.requestId,
      this.number,
      this.interval,
      this.routeFrom,
      this.routeTo,
      this.customer,
      this.customerDelegat});

  String requestId; // id заявки
  int number; // номер заявки
  WorkInterval interval; // интервал
  String routeFrom; // маршрут откуда
  String routeTo; // маршрут куда
  String customer; // заказчик
  User customerDelegat; // представитель заказчика

  String intervalTimes() => interval.intervalTimes();
}
