import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/history_bloc.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/ui/history_screen_item.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryBloc _bloc;

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
      body: StreamBuilder(
        stream: _bloc.outEventItems,
        builder: (BuildContext context, AsyncSnapshot<List<EventItem>> snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(
                child: Text(
                  'Событий нет',
                  style: TextStyle(fontSize: 20, color: Colors.black38),
                ));
          } else {
            return Scrollbar(
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    HistoryScreenItem(snapshot.data[index], _bloc),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
