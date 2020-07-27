import 'package:quality_control/entity/interval.dart';
import 'package:quality_control/entity/user.dart';

// Событие по заявке
class Event {
  Event(
      {this.systemDate,
      this.userDate,
      this.user,
      this.dateRequest,
      this.intervalRequest,
      this.eventType,
      this.statusLabel,
      this.ratingLabel,
      this.ratingComment,
      this.comment});

  DateTime systemDate; // время системное
  DateTime userDate; // время указанное пользователем
  User user; // пользователь, создавший событие
  DateTime dateRequest; // дата из заявки, может не указываться
  Interval intervalRequest; // интервал из заявки, может не указываться
  EventType eventType; // тип события
  String statusLabel; // метка установленного статуса для события SET_STATUS
  String ratingLabel; // метка выставленной оценки для события SET_RATING
  String ratingComment; // комметарий из предустановленных к выставленной оценке
  String comment; // комментарий к событию
}

// Тип события: создание, корректировка, установка статуса, выставление оценки
enum EventType { CREATE, UPDATE, SET_STATUS, SET_RATING }
