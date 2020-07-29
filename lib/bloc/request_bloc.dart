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
    outRequests = streamService.listRequests.stream;
    outRequestIntervalItems = streamService.listRequestIntervalItems.stream;
    currentListPresentation = ListPresentation.INTERVAL;
    currentFilterByDate = streamService.requestFilterByDate;
    _log.i('create');
  }

  final StreamService _streamService;
  final Repository _repository;
  Stream<List<Request>> outRequests;
  Stream<List<RequestIntervalItem>> outRequestIntervalItems;

  ListPresentation currentListPresentation;
  FilterByDate currentFilterByDate;
  BuildContext context;
  final FimberLog _log = FimberLog('RequestBloc');

  void changeDisplayPresentation() {
    if (currentListPresentation == ListPresentation.INTERVAL) {
      currentListPresentation = ListPresentation.REQUEST;
    } else {
      currentListPresentation = ListPresentation.INTERVAL;
    }
  }

  void onTapTabBar(int index) {
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

    _log.i('onTapTabBar index = $index');
  }

  @override
  void dispose() {
    _log.i('dispose');
  }
}

enum ListPresentation { INTERVAL, REQUEST }
