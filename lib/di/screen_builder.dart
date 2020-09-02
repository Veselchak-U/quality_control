import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/history_bloc.dart';
import 'package:quality_control/bloc/history_chain_bloc.dart';
import 'package:quality_control/bloc/info_bloc.dart';
import 'package:quality_control/bloc/login_bloc.dart';
import 'package:quality_control/bloc/quality_bloc.dart';
import 'package:quality_control/bloc/request_bloc.dart';
import 'package:quality_control/bloc/startup_bloc.dart';
import 'package:quality_control/bloc/status_bloc.dart';
import 'package:quality_control/entity/event.dart';

typedef StartupScreenBuilder = BlocProvider<StartupBloc> Function();
typedef LoginScreenBuilder = BlocProvider<LoginBloc> Function();
typedef RequestScreenBuilder = BlocProvider<RequestBloc> Function();
typedef InfoScreenBuilder = BlocProvider<InfoBloc> Function();
typedef HistoryScreenBuilder = BlocProvider<HistoryBloc> Function();
typedef HistoryChainScreenBuilder = BlocProvider<HistoryChainBloc> Function(Event);
typedef StatusScreenBuilder = BlocProvider<StatusBloc> Function();
typedef QualityScreenBuilder = BlocProvider<QualityBloc> Function();

class ScreenBuilder {
  ScreenBuilder({@required Injector injector}) : _injector = injector;

  final Injector _injector;

  Widget Function() getLoginScreenBuilder() =>
      _injector.get<LoginScreenBuilder>();

  Widget Function() getRequestScreenBuilder() =>
      _injector.get<RequestScreenBuilder>();

  Widget Function() getInfoScreenBuilder() =>
      _injector.get<InfoScreenBuilder>();

  Widget Function() getHistoryScreenBuilder() =>
      _injector.get<HistoryScreenBuilder>();

  Widget Function(Event) getHistoryChainScreenBuilder(Event event) =>
      _injector.get<HistoryChainScreenBuilder>();

  Widget Function() getStatusScreenBuilder() =>
      _injector.get<StatusScreenBuilder>();

  Widget Function() getQualityScreenBuilder() =>
      _injector.get<QualityScreenBuilder>();
}
