import 'dart:async';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:quality_control/service/stream_service.dart';

class RequestBloc extends IBloc {
  RequestBloc(
      {@required StreamService streamService, @required Repository repository})
      : _streamService = streamService,
        _repository = repository {
    outRequestsItems = streamService.listRequestItems.stream;
    outRequestIntervalItems = streamService.listRequestIntervalItems.stream;
    currentListPresentation = ListPresentation.INTERVAL;
    currentFilterByDate = streamService.requestFilterByDate;
    currentFilterByText = streamService.requestFilterByText;
    isSearchMode = currentFilterByText.isNotEmpty;
    _log.i('create');
  }

  final StreamService _streamService;
  final Repository _repository;
  Stream<List<Request>> outRequestsItems;
  Stream<List<RequestIntervalItem>> outRequestIntervalItems;

  ListPresentation currentListPresentation;
  FilterByDate currentFilterByDate;
  String currentFilterByText;
  bool isSearchMode;

  BuildContext context;
  final FimberLog _log = FimberLog('RequestBloc');

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

  void onTapListItem({String requestId, String intervalId}) {
    _log.d('onTapListItem requestId = $requestId, intervalId = $intervalId');
  }

  @override
  void dispose() {
    _log.i('dispose');
  }
}

enum ListPresentation { INTERVAL, REQUEST }
