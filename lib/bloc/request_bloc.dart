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
      : _repository = repository {
    outRequests = streamService.listRequests.stream;
    outRequestIntervalItems = streamService.listRequestIntervalItems.stream;
    _log.i('create');
  }

  Stream<List<Request>> outRequests;
  Stream<List<RequestIntervalItem>> outRequestIntervalItems;
  final Repository _repository;

  BuildContext context;
  final FimberLog _log = FimberLog('RequestBloc');

  @override
  void dispose() {
    _log.i('dispose');
  }
}
