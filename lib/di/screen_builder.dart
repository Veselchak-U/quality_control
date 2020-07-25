import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/login_bloc.dart';
import 'package:quality_control/bloc/startup_bloc.dart';

typedef StartupScreenBuilder = BlocProvider<StartupBloc> Function();
typedef LoginScreenBuilder = BlocProvider<LoginBloc> Function();

class ScreenBuilder {
  ScreenBuilder({@required Injector injector}) : _injector = injector;

  final Injector _injector;

  Widget Function() getLoginScreenBuilder() =>
      _injector.get<LoginScreenBuilder>();
}
