import 'package:flutter/foundation.dart';
import 'package:quality_control/entity/event.dart';

class EventItem {
  EventItem({@required this.type, this.event, this.isAlien, this.labelText});

  EventItemType type;
  Event event;
  bool isAlien; // чужое сообщение
  String labelText;
}

enum EventItemType { EVENT, DATE_LABEL, UNREAD_LABEL }
