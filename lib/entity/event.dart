import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/entity/user.dart';

// Событие по заявке
class Event {
  Event(
      {this.id,
      this.parentId,
      this.systemDate,
      this.userDate,
      this.user,
      this.dateRequest,
      this.intervalRequest,
      this.eventType,
      this.statusLabel,
      this.ratingLabel,
      this.ratingComment,
      this.comment});

  String id;
  String parentId; // id корректируемого (первого в цепочке) события
  DateTime systemDate; // время системное
  DateTime userDate; // время указанное пользователем
  User user; // пользователь, создавший событие
  DateTime dateRequest; // дата из заявки, может не указываться
  WorkInterval intervalRequest; // интервал из заявки, может не указываться
  EventType eventType; // тип события
  String statusLabel; // метка установленного статуса, для события SET_STATUS
  String ratingLabel; // метка выставленной оценки, для события SET_RATING
  String ratingComment; // выбранный комментарий, для события SET_RATING
  String comment; // комментарий к событию
}

// Тип события: установка статуса, выставление оценки
enum EventType { SET_STATUS, SET_RATING }
