import 'package:flutter/foundation.dart';
import 'package:quality_control/entity/event.dart';

class EventItem {
  EventItem(
      {@required this.type,
      this.event,
      this.rootDate,
      this.isAlien,
      this.isReadOnly,
      this.isHaveHistory,
      this.labelText});

  EventItemType type;
  Event event;
  DateTime rootDate; // системное время первого события в цепочке
  bool isAlien; // чужое событие
  bool isReadOnly; // согласно настроек справочника оценок
  bool isHaveHistory; // имеет историю изменений
  String labelText; // текст для служебных элементов
}

enum EventItemType { EVENT, DATE_LABEL, UNREAD_LABEL }
