import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:quality_control/entity/request_item.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/extension/datetime_extension.dart';
import 'package:quality_control/util/utils.dart';

class StatusBloc extends IBloc {
  StatusBloc(
      {@required Repository repository, @required ScreenBuilder screenBuilder})
      : _repository = repository,
        _screenBuilder = screenBuilder {
    initialize();
    _log.i('create');
  }

  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  RequestItem requestItem; // заявка, выбранный элемент списка
  RequestIntervalItem requestIntervalItem; // интервал, выбранный элемент списка
  List<DateTime> intervalDates; // даты из интервалов по заявке
  List<WorkInterval> intervalsByDate; // интервалы по текущей дате
  DateTime selectedDate;
  WorkInterval selectedInterval;
  List<Status> statusReferences;
  Status selectedStatus;
  DateTime selectedFactDate;
  TimeOfDay selectedFactTime;
  String inputtedComments;
  AppState _appState;
  bool isUpdateMode = false; // режим корректировки
  Event parentEvent; // корректируемое событие

  final int bottomNavigationBarIndex = 2;
  BuildContext context;
  final FimberLog _log = FimberLog('StatusBloc');

  bool initialize() {
    _appState = _repository.appState;
    requestItem = _appState.requestItem;
    requestIntervalItem = _appState.requestIntervalItem;
    statusReferences = _repository.statusReferences;

    if (_appState.event != null) {
      // режим корректировки
      isUpdateMode = true;
      parentEvent = _appState.event;
      selectedDate = parentEvent.dateRequest;
      selectedInterval = parentEvent.workInterval;
      selectedStatus = statusReferences
          .firstWhere((e) => e.label == parentEvent.statusLabel);
      if (parentEvent.userDate != null) {
        selectedFactDate = parentEvent.userDate.trunc();
        selectedFactTime = TimeOfDay(
            hour: parentEvent.userDate.hour,
            minute: parentEvent.userDate.minute);
      }
      inputtedComments = parentEvent.comment ?? '';
    } else {
      // режим добавления
      intervalDates = requestItem.getDatesFromIntervals(withoutFuture: true);
      if (requestIntervalItem != null) {
        // если перешли со списка интервалов
        var now = DateTime.now();
        selectedDate = requestIntervalItem.interval.dateBegin.trunc();
        if (selectedDate.isAfter(now)) {
          selectedDate = intervalDates.last; // ближайшая дата снизу
        }
        intervalsByDate = requestItem.getIntervalsByDate(date: selectedDate);
        selectedInterval = requestIntervalItem.interval;
        if (selectedInterval.dateBegin.isAfter(now)) {
          selectedInterval =
              Utils.getNearestInterval(intervals: intervalsByDate);
        }
      } else {
        selectedDate = intervalDates.last; // ближайшая дата снизу
        intervalsByDate = requestItem.getIntervalsByDate(date: selectedDate);
        selectedInterval = Utils.getNearestInterval(intervals: intervalsByDate);
      }
      inputtedComments = '';
    }

    return true;
  }

  void onTapBottomNavigationBar(int index) {
    if (index != bottomNavigationBarIndex) {
      Widget Function() nextScreen;
      if (index == 0) {
        nextScreen = _screenBuilder.getInfoScreenBuilder();
      } else if (index == 1) {
        nextScreen = _screenBuilder.getHistoryScreenBuilder();
      } else if (index == 2) {
        nextScreen = _screenBuilder.getStatusScreenBuilder();
      } else if (index == 3) {
        nextScreen = _screenBuilder.getQualityScreenBuilder();
      }
      _repository.setAppState(
          newAppState: AppState(bottomNavigationBarIndex: index));

      Navigator.pushReplacement(
          context,
          PageRouteBuilder<Widget>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) =>
                  nextScreen()));
    }
  }

  void updateIntervalList({DateTime date}) {
    selectedDate = date;
    if (date == null) {
      intervalsByDate = [];
      selectedInterval = null;
    } else {
      intervalsByDate = requestItem.getIntervalsByDate(date: selectedDate);
      selectedInterval = intervalsByDate[0];
    }
    _log.i('updateIntervalList currentDate = $selectedDate');
  }

  void onTapAddButton() {
    DateTime userDate;
    if (selectedFactDate != null && selectedFactTime != null) {
      userDate = selectedFactDate.trunc().add(Duration(
          hours: selectedFactTime.hour, minutes: selectedFactTime.minute));
    }

    var newEvent = Event(
        rootId: isUpdateMode ? parentEvent.rootId ?? parentEvent.id : null,
        systemDate: DateTime.now(),
        userDate: userDate,
        user: _repository.appState.user,
        dateRequest: selectedDate,
        workInterval: selectedInterval,
        eventType: EventType.SET_STATUS,
        statusLabel: selectedStatus.label,
        comment: inputtedComments);

    _repository.addEvent(
        requestId: requestItem.id,
        newEvent: newEvent,
        parentEvent: isUpdateMode ? parentEvent : null);

    onTapBottomNavigationBar(1);
    //    Navigator.pop(context);
  }

  @override
  void dispose() {
    // сбрасываем режим корректировки, если он был
    if (isUpdateMode) {
      _repository.setAppState(newAppState: AppState(event: null));
    }
    _log.i('dispose');
  }
}
