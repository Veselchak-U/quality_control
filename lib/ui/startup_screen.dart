import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/startup_bloc.dart';

class StartupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  StartupBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Контроль\nкачества',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 40.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
        ),
        FutureBuilder<bool>(
          future: _bloc.isInitComplete,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data) {
              Future.microtask(() => _bloc.gotoNextScreen());
            }
            return Align(
                alignment: Alignment(0.0, 0.3),
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ));
          },
        ),
      ],
    );
  }
}
