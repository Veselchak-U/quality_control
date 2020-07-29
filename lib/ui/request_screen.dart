import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/request_bloc.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:quality_control/ui/request_screen_interval_item.dart';
import 'package:quality_control/ui/request_screen_item.dart';

class RequestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  RequestBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      Tab(text: 'РАНЕЕ'),
      Tab(text: 'ТЕКУЩИЕ'),
      Tab(text: 'ДАЛЕЕ'),
    ];

    return DefaultTabController(
        length: myTabs.length,
        initialIndex: 1,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: _openDrawer,
            ),
            title: _bloc.currentListPresentation == ListPresentation.REQUEST
                ? Text('Список заявок')
                : Text('Список интервалов'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: _bloc.currentListPresentation == ListPresentation.REQUEST
                    ? Icon(Icons.format_list_numbered)
                    : Icon(Icons.format_list_numbered_rtl),
                onPressed: () {
                  setState(() {
                    _bloc.changeDisplayPresentation();
                  });
                },
              ),
            ],
            bottom: TabBar(
              tabs: myTabs,
              onTap: (int index) {
                setState(() {
                  _bloc.onTapTabBar(index);
                });
              },
            ),
          ),
          drawer: Drawer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Тут будет меню'),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: _closeDrawer,
                    child: const Text(
                      'Понятно',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          body: _bloc.currentListPresentation == ListPresentation.REQUEST
              ? StreamBuilder(
                  stream: _bloc.outRequests,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Request>> snapshot) {
                    if (snapshot.data == null || snapshot.data.isEmpty) {
                      return Center(
                          child: Text(
                        'Заявок нет',
                        style: TextStyle(fontSize: 20, color: Colors.black38),
                      ));
                    } else {
                      return Scrollbar(
                        child: ListView.separated(
                            padding: EdgeInsets.all(0),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) =>
                                RequestScreenItem(snapshot.data[index], _bloc),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                                      thickness: 2,
                                      color: Colors.black12,
                                    )),
                      );
                    }
                  },
                )
              : StreamBuilder(
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
                      return Scrollbar(
                        child: ListView.separated(
                            padding: EdgeInsets.all(0),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) =>
                                RequestScreenIntervalItem(
                                    snapshot.data[index], _bloc),
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                                      thickness: 2,
                                      color: Colors.black12,
                                    )),
                      );
                    }
                  },
                ),
        ));
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }
}
