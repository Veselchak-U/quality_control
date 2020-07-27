import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/user.dart';
import 'package:quality_control/service/current_user_service.dart';

class StartupBloc extends IBloc {
  StartupBloc(
      {@required CurrentUserService currentUserService,
      @required Repository repository,
      @required ScreenBuilder screenBuilder})
      : _repository = repository,
        _currentUserService = currentUserService,
        _screenBuilder = screenBuilder {
    isInitComplete = initialize();
    _log.i('create');
  }

  final CurrentUserService _currentUserService;
  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  Future<bool> isInitComplete;
  User currentUser;
  BuildContext context;
  final FimberLog _log = FimberLog('StartupBloc');

  Future<bool> initialize() async {
    _log.d('initialize() start');

    await _currentUserService.initialize();
    currentUser = _currentUserService.getCurrentUser();
    if (currentUser != null) {
      await _repository.initialize(user: currentUser);
    }

    _log.d('initialize() end');
    return true;
  }

  void gotoNextScreen() {
    Widget Function() nextScreen;
    if (currentUser == null) {
      nextScreen = _screenBuilder.getLoginScreenBuilder();
    } else {
      nextScreen = _screenBuilder.getRequestScreenBuilder();
    }
    Navigator.pushReplacement<Widget, Widget>(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => nextScreen()));
  }

  @override
  void dispose() {
    _log.i('dispose');
  }
}
