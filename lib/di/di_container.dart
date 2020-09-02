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
import 'package:quality_control/data/i_data_source.dart';
import 'package:quality_control/data/dummy_data_source.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/service/current_user_service.dart';
import 'package:quality_control/service/stream_service.dart';
import 'package:quality_control/ui/history_chain_screen.dart';
import 'package:quality_control/ui/history_screen.dart';
import 'package:quality_control/ui/info_screen.dart';
import 'package:quality_control/ui/login_screen.dart';
import 'package:quality_control/ui/quality_screen.dart';
import 'package:quality_control/ui/request_screen.dart';
import 'package:quality_control/ui/startup_screen.dart';
import 'package:quality_control/ui/status_screen.dart';

class DiContainer {
  static Injector _injector;

  static void initialize() {
    _injector = Injector.getInjector();
    _registerServices();
    _registerScreenBuilders();
  }

  static Widget getStartupScreen() {
    return (_injector.get<StartupScreenBuilder>())();
  }

  static void _registerServices() {
    _injector.map<IDataSource>(
        (i) => DummyDataSource(streamService: i.get<StreamService>()),
        isSingleton: true);

    _injector.map<ScreenBuilder>((i) => ScreenBuilder(injector: i),
        isSingleton: true);

    _injector.map<StreamService>((i) => StreamService(), isSingleton: true);

    _injector.map<Repository>(
        (i) => Repository(
            dataSource: i.get<IDataSource>(),
            streamService: i.get<StreamService>(),
            appState: i.get<AppState>()),
        isSingleton: true);

    _injector.map<AppState>((i) => AppState(), isSingleton: true);

    _injector.map<CurrentUserService>((i) => CurrentUserService(),
        isSingleton: true);
  }

  static void _registerScreenBuilders() {
    // Startup screen
    _injector.map<StartupScreenBuilder>(
        (i) => () => BlocProvider<StartupBloc>(
            child: StartupScreen(),
            bloc: StartupBloc(
                currentUserService: i.get<CurrentUserService>(),
                repository: i.get<Repository>(),
                screenBuilder: i.get<ScreenBuilder>())),
        isSingleton: true);

    // Login screen
    _injector.map<LoginScreenBuilder>(
        (i) => () => BlocProvider<LoginBloc>(
              child: LoginScreen(),
              bloc: LoginBloc(),
            ),
        isSingleton: true);

    // Request screen
    _injector.map<RequestScreenBuilder>(
        (i) => () => BlocProvider<RequestBloc>(
              child: RequestScreen(),
              bloc: RequestBloc(
                  streamService: i.get<StreamService>(),
                  repository: i.get<Repository>(),
                  screenBuilder: i.get<ScreenBuilder>()),
            ),
        isSingleton: true);

    // Info screen
    _injector.map<InfoScreenBuilder>(
        (i) => () => BlocProvider<InfoBloc>(
              child: InfoScreen(),
              bloc: InfoBloc(
                  repository: i.get<Repository>(),
                  screenBuilder: i.get<ScreenBuilder>()),
            ),
        isSingleton: true);

    // History screen
    _injector.map<HistoryScreenBuilder>(
        (i) => () => BlocProvider<HistoryBloc>(
              child: HistoryScreen(),
              bloc: HistoryBloc(
                  repository: i.get<Repository>(),
                  screenBuilder: i.get<ScreenBuilder>(),
                  streamService: i.get<StreamService>()),
            ),
        isSingleton: true);

    // History chain screen
    _injector.map<HistoryChainScreenBuilder>(
        (i) => (Event event) => BlocProvider<HistoryChainBloc>(
              child: HistoryChainScreen(),
              bloc: HistoryChainBloc(
                  event: event,
                  repository: i.get<Repository>(),
                  screenBuilder: i.get<ScreenBuilder>(),
                  streamService: i.get<StreamService>()),
            ),
        isSingleton: true);

    // Status screen
    _injector.map<StatusScreenBuilder>(
        (i) => () => BlocProvider<StatusBloc>(
              child: StatusScreen(),
              bloc: StatusBloc(
                  repository: i.get<Repository>(),
                  screenBuilder: i.get<ScreenBuilder>()),
            ),
        isSingleton: true);

    // Quality screen
    _injector.map<QualityScreenBuilder>(
        (i) => () => BlocProvider<QualityBloc>(
              child: QualityScreen(),
              bloc: QualityBloc(
                  repository: i.get<Repository>(),
                  screenBuilder: i.get<ScreenBuilder>()),
            ),
        isSingleton: true);
  }
}
