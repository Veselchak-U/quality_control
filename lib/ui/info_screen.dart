import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/info_bloc.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class InfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  InfoBloc _bloc;
  Request _request;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
    _request = _bloc.request;
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
          'Заявка № ${_request.number}',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: Colors.white30,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Даты:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                      '${_request.dateFrom.dateForHuman()} - ${_request.dateTo.dateForHuman()}')),
              SizedBox(
                height: 8,
              ),
              Text(
                'Интервалы работы:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(_request.allIntervalsToString())),
              SizedBox(
                height: 8,
              ),
              Text(
                'Откуда:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(_request.routeFrom)),
              SizedBox(
                height: 8,
              ),
              Text(
                'Куда:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(_request.routeTo)),
              SizedBox(
                height: 8,
              ),
              Text(
                'Описание:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(_request.routeDescription)),
              SizedBox(
                height: 8,
              ),
              Text(
                'Подразделение:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(_request.customer)),
              SizedBox(
                height: 8,
              ),
              Text(
                'Представитель:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(_request.customerDelegat.toFullFIO())),
                  Spacer(),
                  if (_request.customerDelegat.phone.isEmpty)
                    SizedBox.shrink()
                  else
                    MaterialButton(
                      minWidth: 50,
                      color: Theme.of(context).accentColor,
                      onPressed: _bloc.callToCustomerDelegat,
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Комментарий:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(_request.comment)),
              SizedBox(
                height: 8,
              ),
              Text(
                'Примечание:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(_request.note)),
            ],
          ),
        )),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
