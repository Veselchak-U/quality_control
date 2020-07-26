import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/request_bloc.dart';

class RequestScreenIntervalItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestScreenIntervalItemState();
}

class _RequestScreenIntervalItemState extends State<RequestScreenIntervalItem> {
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
        height: 200,
        color: Colors.white,
        child: Center(
            child: Text(
          'RequestScreenIntervalItem',
          style: TextStyle(fontSize: 24, color: Colors.black38),
        )));
  }
}
