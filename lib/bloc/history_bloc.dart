import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/service/stream_service.dart';

class HistoryBloc extends IBloc {
  HistoryBloc(
      {@required Repository repository,
      @required ScreenBuilder screenBuilder,
      @required StreamService streamService})
      : _repository = repository,
        _screenBuilder = screenBuilder,
        outEventItems = streamService.eventItemsStream.stream,
        statuses = repository.statusReferences,
        ratings = repository.ratingReferences {
    initialize();
    _log.i('create');
  }

  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  final Stream<List<EventItem>> outEventItems;
  final List<Status> statuses;
  final List<Rating> ratings;
  Request currentRequest;
  AppState _appState;
  bool isChainShow;

  final int bottomNavigationBarIndex = 1;
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;
  final FimberLog _log = FimberLog('HistoryBloc');

  void initialize() {
    _appState = _repository.appState;
    var rootId = _appState.eventFilterByChain;
    isChainShow = rootId != null && rootId.isNotEmpty;
    currentRequest = _repository.getRequestById(requestId: _appState.requestId);
  }

  void onTapEditBottomMenu({Event event}) {
    _repository.setAppState(newAppState: AppState(event: event));

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
    if (isChainShow) {
      _repository.setAppState(newAppState: AppState(eventFilterByChain: ''));
    } else {
      _repository.setAppState(
          newAppState: AppState(eventFilterByChain: event.rootId ?? event.id));
    }
    isChainShow = !isChainShow;
    Navigator.pop(context);
  }

  void onTapExitBottomMenu() {
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
          newAppState: AppState(bottomNavigationBarIndex: index));

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
    _repository.setAppState(newAppState: AppState(eventFilterByChain: ''));
    _log.i('dispose');
  }
}
