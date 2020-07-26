import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/base_bloc.dart';
import 'package:quality_control/di/screen_builder.dart';

class StartupBloc extends BlocBase {
  StartupBloc({@required ScreenBuilder screenBuilder})
      : _screenBuilder = screenBuilder {
    isInitComplete = Future<bool>.delayed(Duration(seconds: 2), () => true);
    _log.i('create');
  }

  final ScreenBuilder _screenBuilder;
  final FimberLog _log = FimberLog('StartupBloc');
  Future<bool> isInitComplete;
  BuildContext context;

  @override
  void dispose() {
    _log.i('dispose');
  }

  void gotoNextScreen() {
    Widget Function() nextScreen = _screenBuilder.getRequestScreenBuilder();
    Navigator.pushReplacement<Widget, Widget>(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => nextScreen()));
  }
}
