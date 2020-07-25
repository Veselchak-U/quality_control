
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: Text(
              'LoginScreen',
              style: TextStyle(fontSize: 24, color: Colors.black38),
            )));
  }
}




