import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/bloc/history_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/service/stream_service.dart';

class HistoryChainBloc extends IBloc {
  HistoryChainBloc(
      {@required Repository repository,
      @required ScreenBuilder screenBuilder,
      @required StreamService streamService})
      : _repository = repository,
        historyBloc = HistoryBloc(
            repository: repository,
            screenBuilder: screenBuilder,
            streamService: streamService) {
    _log.i('create');
  }

  final Repository _repository;
  final HistoryBloc historyBloc;
  GlobalKey<ScaffoldState> scaffoldKey;
  final FimberLog _log = FimberLog('HistoryChainBloc');

  @override
  void dispose() {
    _repository.setAppState(newAppState: AppState(eventFilterByChain: ''));
    historyBloc.dispose();
    _log.i('dispose');
  }
}
