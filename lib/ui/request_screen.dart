
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/request_bloc.dart';

class RequestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  RequestBloc _bloc;

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
          'RequestScreen',
          style: TextStyle(fontSize: 24, color: Colors.black38),
        )));
  }
}




