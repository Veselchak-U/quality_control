import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/history_bloc.dart';
import 'package:quality_control/bloc/history_chain_bloc.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/ui/history_screen_item.dart';

class HistoryChainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryChainScreenState();
}

class _HistoryChainScreenState extends State<HistoryChainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HistoryChainBloc _myBloc;
  HistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _myBloc = BlocProvider.of(context);
    _bloc = _myBloc.historyBloc;
    _bloc.context = context;
    _bloc.scaffoldKey = _scaffoldKey;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Цепочка изменений'),
      ),
      body: StreamBuilder(
        stream: _bloc.outEventItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<EventItem>> snapshot) {
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
                    HistoryScreenItem(snapshot.data[index], _bloc, index),
              ),
            );
          }
        },
      ),
    );
  }
}
