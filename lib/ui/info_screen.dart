import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/info_bloc.dart';
import 'package:quality_control/entity/request_item.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class InfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  InfoBloc _bloc;
  RequestItem _requestItem;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
    _requestItem = _bloc.requestItem;
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
        title: Text('Заявка № ${_requestItem.number}'),
      ),
      body: Container(
        color: Colors.white30,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textBlock(
                  header: 'Даты:',
                  body:
                      '${_requestItem.dateFrom.dateForHuman()} - ${_requestItem.dateTo.dateForHuman()}'),
              _textBlock(
                  header: 'Интервалы работы:',
                  body: _requestItem.allIntervalsToString()),
              _textBlock(header: 'Откуда:', body: _requestItem.routeFrom),
              _textBlock(header: 'Куда:', body: _requestItem.routeTo),
              _textBlock(header: 'Описание:', body: _requestItem.routeDescription),
              _textBlock(header: 'Подразделение:', body: _requestItem.customer),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Представитель:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(_requestItem.customerDelegat.toFullFIO()))
                      ],
                    ),
                  ),
                  if (_requestItem.customerDelegat.phone.isEmpty)
                    SizedBox.shrink()
                  else
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(Icons.phone),
                        color: Colors.white,
                        onPressed: _bloc.callToCustomerDelegat,
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              _textBlock(header: 'Комментарий:', body: _requestItem.comment),
              _textBlock(header: 'Примечание:', body: _requestItem.note)
            ],
          ),
        )),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _textBlock({String header, String body}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(padding: EdgeInsets.only(left: 16), child: Text(body)),
        SizedBox(height: 8),
      ],
    );
  }
}
