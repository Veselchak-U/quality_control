import 'package:flutter/foundation.dart';
import 'package:quality_control/entity/event.dart';

class EventItem {
  EventItem(
      {@required this.type,
      this.event,
      this.isAlien,
      this.isReadOnly,
      this.isHaveHistory,
      this.labelText});

  EventItemType type;
  Event event;
  bool isAlien; // чужое событие
  bool isReadOnly; // согласно настроек справочника оценок
  bool isHaveHistory; // имеет историю изменений
  String labelText; // текст для служебных элементов
}

enum EventItemType { EVENT, DATE_LABEL, UNREAD_LABEL }
