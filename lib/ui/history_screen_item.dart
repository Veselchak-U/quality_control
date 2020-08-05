import 'package:flutter/material.dart';
import 'package:quality_control/bloc/history_bloc.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class HistoryScreenItem extends StatelessWidget {
  HistoryScreenItem(this.eventItem, this.bloc);

  final EventItem eventItem;
  final HistoryBloc bloc;

  @override
  Widget build(BuildContext context) {
    Widget result;

    if (eventItem.type == EventItemType.EVENT) {
      result = Container(
          alignment:
              eventItem.isAlien ? Alignment.centerLeft : Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              decoration: BoxDecoration(
                  color: eventItem.isAlien
                      ? Colors.yellow[100]
                      : Colors.green[100],
                  border: Border.all(),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: eventItem.isAlien
                          ? Radius.circular(0)
                          : Radius.circular(8),
                      bottomRight: eventItem.isAlien
                          ? Radius.circular(8)
                          : Radius.circular(0))),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${eventItem.event.user.getUserRoleName()} ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(
                          eventItem.event.user.toShortFIO(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Spacer(),
                        Text(
                            eventItem.event.systemDate
                                .formatDate('dd.MM.yy HH:mm'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(_getEventText(), style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ));
    } else if (eventItem.type == EventItemType.DATE_LABEL) {
      result = Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(eventItem.labelText,
                          style: TextStyle(fontSize: 14))))));
    } else if (eventItem.type == EventItemType.UNREAD_LABEL) {
      result = Text('Метка непрочитано: ${eventItem.labelText}');
    } else {
      result = Text('Неизвестный тип сообщения');
    }
    return result;
  }

  String _getEventText() {
    String result = '';
    Event event = eventItem.event;
    EventType eventType = event.eventType;

    var userDate = '';
    if (event.userDate != null) {
      userDate = event.userDate.formatDate('dd.MM.yy HH:mm');
    }

    if (eventType == EventType.SET_STATUS) {
      var statusName = bloc.statuses
          .firstWhere((Status e) => e.label == event.statusLabel)
          .name;
      var comment = '';
      if (event.comment != null && event.comment.isNotEmpty) {
        comment = ', комментарий: "${event.comment}"';
      }
      result = 'установил статус "$statusName" $userDate$comment';
    } else if (eventType == EventType.SET_RATING) {
      var ratingName = bloc.ratings
          .firstWhere((Rating e) => e.label == event.ratingLabel)
          .name;
      var presetComment = '';
      if (event.ratingComment != null && event.ratingComment.isNotEmpty) {
        presetComment = '"${event.ratingComment}"';
      }
      var comment = '';
      if (event.comment != null && event.comment.isNotEmpty) {
        comment = '"${event.comment}"';
      }
      var unionComment = '';
      if (presetComment.isNotEmpty || comment.isNotEmpty) {
        unionComment = ', комментарий: $presetComment $comment';
      }
      result = 'выставил оценку "$ratingName" $userDate$unionComment';
    } else if (eventType == EventType.UPDATE) {}
    return result;
  }
}
