import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/history_bloc.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/ui/history_screen_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HistoryBloc _bloc;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    print('HistoryScreen initState()');
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
    _bloc.scaffoldKey = _scaffoldKey;
    // saver scroll position
    _itemPositionsListener.itemPositions.addListener(() {
      Iterable<ItemPosition> positions =
          _itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty/* && !_bloc.isChainShow*/) {
        // min full-visible item
        _bloc.itemIndex = positions
            .where((ItemPosition position) => position.itemLeadingEdge >= 0)
            .reduce((ItemPosition min, ItemPosition position) =>
                position.itemTrailingEdge < min.itemTrailingEdge
                    ? position
                    : min)
            .index;
        // _bloc.itemIndex = positions.first.index;
        print('new itemIndex = ${_bloc.itemIndex}');
      }
    });
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

    var body = StreamBuilder(
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
            child: ScrollablePositionedList.builder(
              padding: EdgeInsets.all(0),
              itemCount: snapshot.data.length,
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              initialScrollIndex: /*_bloc.isChainShow ? 0 : */_bloc.itemIndex,
              itemBuilder: (BuildContext context, int index) =>
                  HistoryScreenItem(snapshot.data[index], _bloc, index),
            ),
          );
        }
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Заявка № ${_bloc.requestItem.number}'),
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
