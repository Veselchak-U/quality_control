import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:quality_control/entity/request_item.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/service/stream_service.dart';

class HistoryBloc extends IBloc {
  HistoryBloc(
      {@required Repository repository,
      @required ScreenBuilder screenBuilder,
      @required StreamService streamService})
      : _repository = repository,
        _screenBuilder = screenBuilder,
        outEventItems = streamService.eventItemsStream.stream {
    initialize();
    _log.i('create');
  }

  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  final Stream<List<EventItem>> outEventItems;
  List<Status> statusReferences;
  List<Rating> ratingReferences;
  RequestItem requestItem; // заявка, выбранный элемент списка
  RequestIntervalItem requestIntervalItem; // интервал, выбранный элемент списка
  AppState _appState;
  bool isChainShow;
  int itemIndex;

  final int bottomNavigationBarIndex = 1;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;
  final FimberLog _log = FimberLog('HistoryBloc');

  void initialize() {
    _appState = _repository.appState;
    requestItem = _appState.requestItem;
    requestIntervalItem = _appState.requestIntervalItem;
    statusReferences = _repository.statusReferences;
    ratingReferences = _repository.ratingReferences;
    var rootId = _appState.eventFilterByChain;
    isChainShow = rootId != null && rootId.isNotEmpty;
    itemIndex = _appState.historyItemIndex ?? 0;
  }

  void onTapEditBottomMenu({Event event}) {
    _repository.setAppState(
        newAppState: AppState(event: event, historyItemIndex: itemIndex));

    Widget Function() nextScreen;
    if (event.eventType == EventType.SET_STATUS) {
      nextScreen = _screenBuilder.getStatusScreenBuilder();
    } else if (event.eventType == EventType.SET_RATING) {
      nextScreen = _screenBuilder.getQualityScreenBuilder();
    }

    Navigator.pushReplacement(
        context,
        PageRouteBuilder<Widget>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                nextScreen()));
  }

  void onTapShowChainBottomMenu({Event event}) {
    closeBottomMenu();
    _repository.setAppState(newAppState: AppState(historyItemIndex: itemIndex));

    Widget Function(Event event) nextScreen;
    nextScreen = _screenBuilder.getHistoryChainScreenBuilder(event);

    Navigator.push(
        context,
        PageRouteBuilder<Widget>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                nextScreen(event)));
  }

  void closeBottomMenu() {
    Navigator.pop(context);
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
          newAppState: AppState(
              bottomNavigationBarIndex: index, historyItemIndex: itemIndex));

      Navigator.pushReplacement(
          context,
          PageRouteBuilder<Widget>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) =>
                  nextScreen()));
    }
  }

  @override
  void dispose() {
    _log.i('dispose');
  }
}
