import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/status_bloc.dart';

class StatusScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StatusBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBar = BottomNavigationBar(
      currentIndex: _bloc.bottomNavigationBarIndex,
      onTap: (int index) => _bloc.onTapBottomNavigationBar(index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).accentColor,
      unselectedItemColor: Colors.black54,
      selectedIconTheme: IconThemeData(size: 28),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          title: Text('Информация'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          title: Text('История'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_turned_in),
          title: Text('Статусы'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          title: Text('Оценки'),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Заявка № ${_bloc.currentRequest.number}',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
          color: Colors.white,
          child: Center(
              child: Text(
            'StatusScreen',
            style: TextStyle(fontSize: 24, color: Colors.black38),
          ))),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
