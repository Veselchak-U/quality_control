import 'package:flutter/material.dart';
import 'package:quality_control/bloc/history_bloc.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class HistoryScreenItem extends StatelessWidget {
  HistoryScreenItem(this.item, this.bloc);

  final EventItem item;
  final HistoryBloc bloc;
  final TextStyle headerTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    Widget result;

    if (item.type == EventItemType.EVENT) {
      result = _getEventItem();
    } else if (item.type == EventItemType.DATE_LABEL) {
      result = _getDateLabelItem(bgColor: primaryColor);
    } else if (item.type == EventItemType.UNREAD_LABEL) {
      // TODO(dyv): допилить
      result = Text('Метка непрочитано: ${item.labelText}');
    } else {
      print('Unknown EventItemType');
    }
    return result;
  }

  Widget _getEventItem() {
    return Container(
      alignment: item.isAlien ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: GestureDetector(
          onTap:
              /*bloc.isChainShow && item.isHaveHistory ? null :*/ _showBottomSheet,
          child: Container(
            decoration: BoxDecoration(
                color: item.isAlien ? Colors.yellow[50] : Colors.green[50],
                border: Border.all(),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft:
                        item.isAlien ? Radius.circular(0) : Radius.circular(8),
                    bottomRight: item.isAlien
                        ? Radius.circular(8)
                        : Radius.circular(0))),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          alignment: WrapAlignment.start,
                          children: [
                            if (item.isHaveHistory)
                              Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.black38,
                              )
                            else
                              SizedBox.shrink(),
                            Text(item.event.user.getUserRoleName(),
                                style: headerTextStyle),
                            Text(item.event.user.toShortFIO(),
                                style: headerTextStyle)
                          ],
                        ),
                      ),
                      Text(item.event.systemDate.formatDate('HH:mm'),
//                            overflow: TextOverflow.ellipsis,
                          style: headerTextStyle),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(_getPeriodText(), style: TextStyle(fontSize: 14)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(_getEventText(), style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getPeriodText() {
    String result = '';
    DateTime date = item.event.dateRequest;
    WorkInterval interval = item.event.workInterval;

    if (date == null && interval == null) {
      result = 'Для всей заявки';
    } else {
      if (date != null) {
        var andInterval =
            interval == null ? '' : ' и интервала: ${interval.toString()}';
        result = 'Для даты: ${date.dateForHuman()}$andInterval';
      } else {
        result = 'Для интервала: ${interval.toString()}';
      }
    }
    return result;
  }

  String _getEventText() {
    String result = '';
    Event event = item.event;
    EventType eventType = event.eventType;

    if (eventType == EventType.SET_STATUS) {
      //
      // УСТАНОВКА СТАТУСА
      //
      String statusName;
      if (bloc.statusReferences == null || bloc.statusReferences.isEmpty) {
        statusName = event.statusLabel;
      } else {
        statusName = bloc.statusReferences
            .firstWhere((Status e) => e.label == event.statusLabel)
            .name;
      }
      var userDate = '';
      if (event.userDate != null) {
        userDate =
            ', пользовательское время: ${event.userDate.formatDate('dd.MM.yy HH:mm')}';
      }
      var comment = '';
      if (event.comment != null && event.comment.isNotEmpty) {
        comment = ', комментарии: ${event.comment}';
      }
      String action;
      if (bloc.isChainShow) {
        action = event.rootId == null ? 'установил' : 'внёс изменения:';
      } else {
        action = 'установил';
      }
      result = '$action статус "$statusName"$userDate$comment';
    } else if (eventType == EventType.SET_RATING) {
      //
      // ВЫСТАВЛЕНИЕ ОЦЕНКИ
      //
      String ratingName;
      if (bloc.ratingReferences == null || bloc.ratingReferences.isEmpty) {
        ratingName = event.ratingLabel;
      } else {
        ratingName = bloc.ratingReferences
            .firstWhere((Rating e) => e.label == event.ratingLabel)
            .name;
      }
      var presetComment = '';
      if (event.ratingComment != null) {
        presetComment = event.ratingComment;
      }
      var comment = '';
      if (event.comment != null) {
        comment = event.comment;
      }
      var unionComment = '';
      if (presetComment.isNotEmpty || comment.isNotEmpty) {
        if (presetComment.isNotEmpty) {
          var commentString = comment.isNotEmpty ? ', $comment' : '';
          unionComment = ', комментарии: $presetComment$commentString';
        } else {
          unionComment = ', комментарии: $comment';
        }
      }
      String action;
      if (bloc.isChainShow) {
        action =
            event.rootId == null ? 'выставил оценку' : 'внёс изменения: оценка';
      } else {
        action = 'выставил оценку';
      }
      result = '$action "$ratingName"$unionComment';
    }
    return result;
  }

  void _showBottomSheet() {
    Widget editListTile;
    if (item.isAlien ||
        item.isReadOnly ||
        (bloc.isChainShow && item.isHaveHistory)) {
      String textRefusal;
      if (item.isAlien) {
        textRefusal = 'Недоступно: чужая заявка';
      } else if (item.isReadOnly) {
        textRefusal = 'Недоступно: запрет изменения оценки';
      } else if (bloc.isChainShow && item.isHaveHistory) {
        textRefusal = 'Недоступно: не последнее событие';
      }
      editListTile = ListTile(
        leading: Icon(Icons.edit, color: Colors.black38),
        title: Text(textRefusal, style: TextStyle(color: Colors.black38)),
      );
    } else {
      editListTile = ListTile(
        leading: Icon(Icons.edit),
        title: Text('Корректировка события'),
        onTap: () {
          bloc.onTapEditBottomMenu(event: item.event);
        },
      );
    }

    bloc.scaffoldKey.currentState.showBottomSheet<void>(
      (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
//        color: Colors.yellow[50],
            border: Border.all(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Wrap(
            children: [
              editListTile,
              if (item.isHaveHistory && !bloc.isChainShow)
                ListTile(
                  leading: Icon(Icons.linear_scale),
                  title: Text('Цепочка изменений'),
                  onTap: () {
                    bloc.onTapShowChainBottomMenu(event: item.event);
                  },
                )
              else
                SizedBox.shrink(),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black12,
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('Отмена'),
                onTap: bloc.onTapExitBottomMenu,
              ),
            ],
          ),
        );
      },
//          elevation: 25,
    );
  }

  Widget _getDateLabelItem({Color bgColor}) {
    bgColor ??= Colors.blue;
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Center(
            child: Container(
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(item.labelText,
                        style: TextStyle(fontSize: 14))))));
  }
}
