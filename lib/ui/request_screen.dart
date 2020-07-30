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
  TabController _tabController;
  final List<Tab> _tabs = <Tab>[
    Tab(text: 'РАНЕЕ'),
    Tab(text: 'ТЕКУЩИЕ'),
    Tab(text: 'ДАЛЕЕ'),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
    _searchFieldController.addListener(_onUpdateSearchField);
    _tabController =
        TabController(vsync: this, length: _tabs.length, initialIndex: 1);
//    _tabController = DefaultTabController.of(context);
//    _tabController.addListener(() {
//      var index = _tabController.index;
//      setState(() {
//        _bloc.onTapFilterByDateBar(index);
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
//    final tabBar = TabBar(
//      tabs: tabs,
//      onTap: (int index) {
//        setState(() {
//          _bloc.onTapFilterByDateBar(index);
//        });
//      },
//    );

    var normalAppBar = AppBar(
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
          onPressed: () {
            setState(() {
              _bloc.changeSearchMode();
            });
          },
        ),
        IconButton(
          icon: _bloc.currentListPresentation == ListPresentation.REQUEST
              ? Icon(Icons.format_list_numbered)
              : Icon(Icons.format_list_numbered_rtl),
          onPressed: () {
            setState(() {
              _bloc.changeListPresentation();
            });
          },
        ),
      ],
//      bottom: tabBar,
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
          icon: _bloc.currentListPresentation == ListPresentation.REQUEST
              ? Icon(Icons.format_list_numbered)
              : Icon(Icons.format_list_numbered_rtl),
          onPressed: () {
            setState(() {
              _bloc.changeListPresentation();
            });
          },
        ),
      ],
//      bottom: tabBar,
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

    return Scaffold(
        key: _scaffoldKey,
        appBar: _bloc.isSearchMode ? searchAppBar : normalAppBar,
        drawer: drawer,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
//              pinned: true,
              floating: true,
              delegate: _SliverTabBarDelegate(
                  tabBar: TabBar(
                    tabs: _tabs,
                    controller: _tabController,
                    labelColor: Colors.blue,
                  ),
                  backColor: Colors.white),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                if (_bloc.currentListPresentation == ListPresentation.REQUEST)
                  requestList
                else
                  requestIntervalList
              ]),
            )

//            SliverFillRemaining(
//              child: _bloc.currentListPresentation == ListPresentation.REQUEST
//                  ? requestList
//                  : requestIntervalList,
//            )

//            SliverFillRemaining(
//              child: TabBarView(
//                controller: _tabController,
//                physics: NeverScrollableScrollPhysics(),
//                children: [
//                  if (_bloc.currentListPresentation == ListPresentation.REQUEST)
//                    requestList
//                  else
//                    requestIntervalList,
//                  if (_bloc.currentListPresentation == ListPresentation.REQUEST)
//                    requestList
//                  else
//                    requestIntervalList,
//                  if (_bloc.currentListPresentation == ListPresentation.REQUEST)
//                    requestList
//                  else
//                    requestIntervalList,
//                ],
//              ),
//            )
          ],
        ));

//    return DefaultTabController(
//        length: tabs.length,
//        initialIndex: 1,
//        child: Scaffold(
//          key: _scaffoldKey,
//          appBar: _bloc.isSearchMode ? searchAppBar : normalAppBar,
//          drawer: drawer,
//          body: _bloc.currentListPresentation == ListPresentation.REQUEST
//              ? requestList
//              : requestIntervalList,
//        ));
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
    _tabController.dispose();
    super.dispose();
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate({@required TabBar tabBar, Color backColor})
      : _tabBar = tabBar,
        _backColor = backColor;

  final TabBar _tabBar;
  final Color _backColor;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: _backColor ?? Theme.of(context).primaryColor, child: _tabBar);
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
