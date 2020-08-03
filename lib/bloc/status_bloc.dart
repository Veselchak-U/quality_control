import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class StatusBloc extends IBloc {
  StatusBloc(
      {@required Repository repository,
      @required ScreenBuilder screenBuilder,
      @required AppState appState})
      : _repository = repository,
        _screenBuilder = screenBuilder,
        request = repository.getRequestById(requestId: appState.requestId) {
    intervalDates = request.getDatesFromIntervals();
    selectedDate = DateTime.now().trunc();
    intervalsByDate = request.getIntervalsByDate(date: selectedDate);
    selectedInterval = intervalsByDate[0];
    statusReferences = _repository.statusReferences;
    inputedComments = '';
    _log.i('create');
  }

  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  final Request request; // заявка
  List<DateTime> intervalDates; // даты из интервалов по заявке
  List<WorkInterval> intervalsByDate; // интервалы по текущей дате
  DateTime selectedDate;
  WorkInterval selectedInterval;
  List<Status> statusReferences;
  Status selectedStatus;
  DateTime selectedFactDate;
  TimeOfDay selectedFactTime;
  String inputedComments;

  final int bottomNavigationBarIndex = 2;
  BuildContext context;
  final FimberLog _log = FimberLog('StatusBloc');

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
    intervalsByDate = request.getIntervalsByDate(date: selectedDate);
    selectedInterval = intervalsByDate[0];
    _log.i('updateIntervalList currentDate = $selectedDate');
  }

  void onTapAddButton() {
    DateTime userDate;
    if (selectedFactDate != null && selectedFactTime != null) {
      userDate = selectedFactDate.trunc().add(Duration(
          hours: selectedFactTime.hour, minutes: selectedFactTime.minute));
    }

    var event = Event(
        systemDate: DateTime.now(),
        userDate: userDate,
        user: _repository.appState.user,
        dateRequest: selectedDate,
        intervalRequest: selectedInterval,
        eventType: EventType.SET_STATUS,
        statusLabel: selectedStatus.label,
        comment: inputedComments);
    _repository.addEvent(requestId: request.id, event: event);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _log.i('dispose');
  }

}
