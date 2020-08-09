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

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  RequestBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
    _searchFieldController.addListener(_onUpdateSearchField);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Tab>[
      Tab(child: Text('РАНЕЕ', overflow: TextOverflow.ellipsis)),
      Tab(child: Text('СЕГОДНЯ', overflow: TextOverflow.ellipsis)),
      Tab(child: Text('ДАЛЕЕ', overflow: TextOverflow.ellipsis)),
    ];

    final tabBar = TabBar(
      tabs: tabs,
      onTap: (int index) {
        setState(() {
          _bloc.onTapFilterByDateBar(index);
        });
      },
    );

    var normalAppBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: _openDrawer,
      ),
      title: _bloc.isRequestPresentation
          ? Text('Заявки')
          : Text('Интервалы работы'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _bloc.changeSearchMode();
            });
          },
        ),
        IconButton(
          icon: _bloc.isRequestPresentation
              ? Icon(Icons.format_list_numbered)
              : Icon(Icons.format_list_numbered_rtl),
          onPressed: () {
            setState(() {
              _bloc.changeListPresentation();
            });
          },
        ),
      ],
      bottom: tabBar,
    );

    final double appBarFontSize =
        Theme.of(context).textTheme.headline6.fontSize;

    var searchAppBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            _clearSearchField();
            _bloc.changeSearchMode();
          });
        },
      ),
      title: TextField(
        controller: _searchFieldController,
        autofocus: true,
        cursorColor: Colors.white,
        textInputAction: TextInputAction.search,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          hintText: 'Поиск...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white70, fontSize: appBarFontSize),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _clearSearchField();
              });
            },
          ),
        ),
        style: TextStyle(color: Colors.white, fontSize: appBarFontSize),
      ),
      actions: <Widget>[
        IconButton(
          icon: _bloc.isRequestPresentation
              ? Icon(Icons.format_list_numbered)
              : Icon(Icons.format_list_numbered_rtl),
          onPressed: () {
            setState(() {
              _bloc.changeListPresentation();
            });
          },
        ),
      ],
      bottom: tabBar,
    );

    var requestList = StreamBuilder(
      stream: _bloc.outRequestsItems,
      builder: (BuildContext context, AsyncSnapshot<List<Request>> snapshot) {
        if (snapshot.data == null || snapshot.data.isEmpty) {
          return Center(
              child: Text(
            'Заявок нет',
            style: TextStyle(fontSize: 20, color: Colors.black38),
          ));
        } else {
          return Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) =>
                  RequestScreenItem(snapshot.data[index], _bloc),
            ),
          );
        }
      },
    );

    var requestIntervalList = StreamBuilder(
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
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) =>
                  RequestScreenIntervalItem(snapshot.data[index], _bloc),
            ),
          );
        }
      },
    );

    var drawer = Drawer(
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
    );

    return DefaultTabController(
        length: tabs.length,
        initialIndex: 1,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: _bloc.isSearchMode ? searchAppBar : normalAppBar,
            drawer: drawer,
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                if (_bloc.isRequestPresentation)
                  requestList
                else
                  requestIntervalList,
                if (_bloc.isRequestPresentation)
                  requestList
                else
                  requestIntervalList,
                if (_bloc.isRequestPresentation)
                  requestList
                else
                  requestIntervalList,
              ],
            )));
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  void _onUpdateSearchField() {
    _bloc.onChangeSearchString(_searchFieldController.text);
  }

  void _clearSearchField() {
    _searchFieldController.clear();
    _onUpdateSearchField();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
