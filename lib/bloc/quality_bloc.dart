import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/extension/datetime_extension.dart';
import 'package:quality_control/service/stream_service.dart';

class QualityBloc extends IBloc {
  QualityBloc(
      {@required Repository repository,
      @required ScreenBuilder screenBuilder})
      : _repository = repository,
        _screenBuilder = screenBuilder {
    _appState = _repository.appState;
    request = repository.getRequestById(requestId: _appState.requestId);
    intervalDates = request.getDatesFromIntervals();
    selectedDate = DateTime.now().trunc();
    intervalsByDate = request.getIntervalsByDate(date: selectedDate);
    selectedInterval = intervalsByDate[0];
    ratingReferences = _repository.ratingReferences;
    presetComments = [];
    isPresetCommentRequared = false;
    selectedPresetComment = null;
    inputedComments = '';

    _log.i('create');
  }

  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  Request request;
  List<DateTime> intervalDates; // даты из интервалов по заявке
  List<WorkInterval> intervalsByDate; // интервалы по текущей дате
  DateTime selectedDate;
  WorkInterval selectedInterval;
  List<Rating> ratingReferences;
  Rating selectedRating;
  List<String> presetComments;
  bool isPresetCommentRequared;
  String selectedPresetComment;
  String inputedComments;
  AppState _appState;

  final int bottomNavigationBarIndex = 3;
  BuildContext context;
  final FimberLog _log = FimberLog('QualityBloc');

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

  void onSelectRating(double value) {
    if (value == 0.0) {
      selectedRating = null;
      presetComments = [];
      isPresetCommentRequared = false;
    } else {
      selectedRating = ratingReferences[value.toInt() - 1];
      presetComments = selectedRating.presetComments ?? [];
      isPresetCommentRequared = selectedRating.isCommentRequired ?? false;
    }
    selectedPresetComment = null;
    _log.i('onSelectRating = ${selectedRating?.name}');
  }

  void onTapAddButton() {
    var event = Event(
        systemDate: DateTime.now(),
        user: _appState.user,
        dateRequest: selectedDate,
        intervalRequest: selectedInterval,
        eventType: EventType.SET_RATING,
        ratingLabel: selectedRating.label,
        ratingComment: selectedPresetComment,
        comment: inputedComments);
    _repository.addEvent(requestId: request.id, event: event);

    onTapBottomNavigationBar(1);
    //    Navigator.pop(context);
  }

  @override
  void dispose() {
    _log.i('dispose');
  }
}
