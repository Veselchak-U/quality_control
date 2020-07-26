import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/base_bloc.dart';

class RequestBloc extends BlocBase {
  RequestBloc() {
    _log.i('create');
  }

  BuildContext context;
  final _log = FimberLog('RequestBloc');


  @override
  void dispose() {
    _log.i('dispose');
  }
}
