import 'dart:async';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:quality_control/entity/request_item.dart';
import 'package:quality_control/service/stream_service.dart';

class RequestBloc extends IBloc {
  RequestBloc(
      {@required StreamService streamService,
      @required Repository repository,
      @required ScreenBuilder screenBuilder})
      : _streamService = streamService,
        _repository = repository,
        _screenBuilder = screenBuilder {
    outRequestsItems = streamService.requestItemsStream.stream;
//    outRequestsItems.listen(_debugListenRequestsItems);
    outRequestIntervalItems = streamService.requestIntervalItemsStream.stream;
    currentListPresentation = ListPresentation.INTERVAL;
    currentFilterByDate = streamService.requestFilterByDate;
    currentFilterByText = streamService.requestFilterByText;
    isSearchMode = currentFilterByText.isNotEmpty;
    _appState = _repository.appState;
//    streamService.appState.listen((AppState value) { _appState = value; });
    _log.i('create');
  }

  final StreamService _streamService;
  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  Stream<List<RequestItem>> outRequestsItems;
  Stream<List<RequestIntervalItem>> outRequestIntervalItems;

  ListPresentation currentListPresentation;
  FilterByDate currentFilterByDate;
  String currentFilterByText;
  bool isSearchMode;
  AppState _appState;

  BuildContext context;
  final FimberLog _log = FimberLog('RequestBloc');

  bool get isRequestPresentation =>
      currentListPresentation == ListPresentation.REQUEST;

//  void _debugListenRequestsItems(List<Request> inRequests) {
//    print('ku');
//  }

  void changeListPresentation() {
    if (currentListPresentation == ListPresentation.INTERVAL) {
      currentListPresentation = ListPresentation.REQUEST;
    } else {
      currentListPresentation = ListPresentation.INTERVAL;
    }
  }

  void onTapFilterByDateBar(int index) {
    FilterByDate newFilter;
    if (index == 0) {
      newFilter = FilterByDate.BEFORE;
    } else if (index == 1) {
      newFilter = FilterByDate.TODAY;
    } else if (index == 2) {
      newFilter = FilterByDate.AFTER;
    }
    if (newFilter != currentFilterByDate) {
      currentFilterByDate = newFilter;
      _streamService.requestFilterByDate = currentFilterByDate;
    }
  }

  void changeSearchMode() {
    if (isSearchMode) {
      currentFilterByText = '';
      _streamService.requestFilterByText = currentFilterByText;
    }
    isSearchMode = !isSearchMode;
  }

  void onChangeSearchString(String text) {
    currentFilterByText = text;
    _streamService.requestFilterByText = currentFilterByText;
    _log.d('onChangeSearchString text = $text');
  }

  void onTapListItem(
      {RequestItem requestItem, RequestIntervalItem intervalItem}) {
    if (requestItem == null && intervalItem != null) {
      requestItem = _repository
          .getRequestById(requestId: intervalItem.requestId)
          .toRequestItem();
    }
    _repository.setAppState(
        newAppState:
            AppState(requestItem: requestItem, requestIntervalItem: intervalItem));
    _streamService.refreshDataEventsStream
        .add(RefreshDataEvent.REFRESH_REQUESTS);

    var index = _appState.bottomNavigationBarIndex;
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
    Navigator.push(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => nextScreen()));
  }

  @override
  void dispose() {
    _log.i('dispose');
  }
}
