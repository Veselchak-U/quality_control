import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/i_bloc.dart';
import 'package:quality_control/data/repository.dart';
import 'package:quality_control/di/screen_builder.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/request.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoBloc extends IBloc {
  InfoBloc(
      {@required Repository repository,
      @required ScreenBuilder screenBuilder,
      @required AppState appState})
      : _repository = repository,
        _screenBuilder = screenBuilder,
        request = repository.getRequestById(requestId: appState.requestId) {
    _log.i('create');
  }

  final Repository _repository;
  final ScreenBuilder _screenBuilder;
  final Request request;
  final int bottomNavigationBarIndex = 0;
  BuildContext context;
  final FimberLog _log = FimberLog('InfoBloc');

  void onTapBottomNavigationBar(int index) {
    if (index != bottomNavigationBarIndex) {
      Widget Function() nextScreen;
      if (index == 0) {
        nextScreen = _screenBuilder.getInfoScreenBuilder();
      } else if (index == 1) {
        nextScreen = _screenBuilder.getHistoryScreenBuilder();
      } else if (index == 2) {
        nextScreen = _screenBuilder.getStatusScreenBuilder();
      } else if (index == 3) {
        nextScreen = _screenBuilder.getQualityScreenBuilder();
      }
      _repository.setAppState(
          newAppState: AppState(bottomNavigationBarIndex: index));

      Navigator.pushReplacement(
          context,
          PageRouteBuilder<Widget>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) =>
                  nextScreen()));

//      Navigator.pushReplacement(
//          context,
//          MaterialPageRoute<Widget>(
//              builder: (BuildContext context) => nextScreen()));
    }
  }

  Future<void> callToCustomerDelegat() async {
    String phone = 'tel:${request.customerDelegat.phone}';
    _log.d('callToCustomerDelegat() $phone');

    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not launch $phone';
    }
  }

  @override
  void dispose() {
    _log.i('dispose');
  }
}
