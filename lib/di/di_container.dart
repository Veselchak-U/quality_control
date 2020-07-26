import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/login_bloc.dart';
import 'package:quality_control/bloc/request_bloc.dart';
import 'package:quality_control/bloc/startup_bloc.dart';
import 'package:quality_control/data/base_data_source.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/service/stream_service.dart';
import 'package:quality_control/ui/login_screen.dart';
import 'package:quality_control/ui/request_screen.dart';
import 'package:quality_control/ui/startup_screen.dart';

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
    _injector.map<ScreenBuilder>((i) => ScreenBuilder(injector: i),
        isSingleton: true);

    _injector.map<StreamService>((i) => StreamService(), isSingleton: true);

        _injector.map<Repository>(
            (i) => Repository(
            dataSource: i.get<BaseDataSource>(),
            streamService: i.get<StreamService>()),
        isSingleton: true);

    _injector.map<BaseDataSource>(
            (i) => DummyDataSource(streamService: i.get<StreamService>()),
        isSingleton: true);

//    _injector.map<CurrentUserService>(
//            (i) => CurrentUserService(dataSource: i.get<IDataSource>()),
//        isSingleton: true);
//
//
  }

  static void _registerScreenBuilders() {
    // Startup screen
    _injector.map<StartupScreenBuilder>(
        (i) => () => BlocProvider<StartupBloc>(
            child: StartupScreen(),
            bloc: StartupBloc(screenBuilder: i.get<ScreenBuilder>())),
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
              bloc: RequestBloc(),
            ),
        isSingleton: true);
  }
}
