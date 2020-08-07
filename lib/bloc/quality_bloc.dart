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

class QualityBloc extends IBloc {
  QualityBloc(
      {@required Repository repository, @required ScreenBuilder screenBuilder})
      : _repository = repository,
        _screenBuilder = screenBuilder {
    initialize();
    _log.i('create');
  }

  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  Request request; // заявка
  List<DateTime> intervalDates; // даты из интервалов по заявке
  List<WorkInterval> intervalsByDate; // интервалы по текущей дате
  DateTime selectedDate;
  WorkInterval selectedInterval;
  List<Rating> ratingReferences;
  Rating selectedRating;
  double selectedRatingIndex;
  List<String> presetComments;
  bool isPresetCommentRequired;
  String selectedPresetComment;
  String inputtedComments;
  AppState _appState;
  bool isUpdateMode = false; // режим корректировки
  Event event; // корректируемое событие

  final int bottomNavigationBarIndex = 3;
  BuildContext context;
  final FimberLog _log = FimberLog('QualityBloc');

  bool initialize() {
    _appState = _repository.appState;
    request = _repository.getRequestById(requestId: _appState.requestId);
    ratingReferences = _repository.ratingReferences;

    if (_appState.event != null) {
      // режим корректировки
      isUpdateMode = true;
      event = _appState.event;
//      intervalDates = <DateTime>[event.dateRequest];
      selectedDate = event.dateRequest;
//      intervalsByDate = <WorkInterval>[event.workInterval];
      selectedInterval = event.workInterval;
      selectedRating =
          ratingReferences.firstWhere((e) => e.label == event.ratingLabel);
      selectedRatingIndex = ratingReferences.indexOf(selectedRating).toDouble();
      presetComments = selectedRating.presetComments ?? [];
      isPresetCommentRequired = selectedRating.isCommentRequired ?? false;
      selectedPresetComment = event.ratingComment;
      inputtedComments = event.comment ?? '';
    } else {
      // режим добавления
      intervalDates = request.getDatesFromIntervals();
      selectedDate = DateTime.now().trunc(); // TODO(dyv): брать ближайшую дату
      intervalsByDate = request.getIntervalsByDate(date: selectedDate);
      selectedInterval =
          intervalsByDate[0]; // TODO(dyv): брать ближайший интервал
      presetComments = [];
      isPresetCommentRequired = false;
      selectedPresetComment = null;
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
    intervalsByDate = request.getIntervalsByDate(date: selectedDate);
    selectedInterval = intervalsByDate[0];
    _log.i('updateIntervalList currentDate = $selectedDate');
  }

  void onSelectRating(double value) {
    if (value == 0.0) {
      selectedRating = null;
      presetComments = [];
      isPresetCommentRequired = false;
    } else {
      selectedRating = ratingReferences[value.toInt() - 1];
      presetComments = selectedRating.presetComments ?? [];
      isPresetCommentRequired = selectedRating.isCommentRequired ?? false;
    }
    selectedPresetComment = null;
    _log.i('onSelectRating = ${selectedRating?.name}');
  }

  void onTapAddButton() {
    var newEvent = Event(
        parentId: isUpdateMode ? event.id : null,
        systemDate: DateTime.now(),
        user: _appState.user,
        dateRequest: selectedDate,
        workInterval: selectedInterval,
        eventType: EventType.SET_RATING,
        ratingLabel: selectedRating.label,
        ratingComment: selectedPresetComment,
        comment: inputtedComments);
    _repository.addEvent(requestId: request.id, event: newEvent);

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
