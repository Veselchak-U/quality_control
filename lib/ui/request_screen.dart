
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/request_bloc.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:quality_control/ui/request_screen_interval_item.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('Список интервалов'),),
      body: StreamBuilder(
        stream: _bloc.outRequestIntervalItems,
        builder: (BuildContext context,
            AsyncSnapshot<List<RequestIntervalItem>> snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(
                child: Text(
                  'Заявок нет',
                  style: TextStyle(fontSize: 20, color: Colors.black38),
                ));
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(0),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    RequestScreenIntervalItem(snapshot.data[index], _bloc),
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  thickness: 2,
                  color: Colors.black12,
                ));
          }
        },
      ),
    );
  }
}




