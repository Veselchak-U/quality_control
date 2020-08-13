import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/status_bloc.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class StatusScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StatusBloc _bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//  final Color _fillColor = Color(0xfff0f0f0);
  final Color _fillColor = Color(0xffe5e5e5);
  var dateFieldController = TextEditingController();
  var timeFieldController = TextEditingController();
  var commentFieldController = TextEditingController();
  bool isUpdateMode;
  Event event;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.context = context;
    isUpdateMode = _bloc.isUpdateMode;
    if (isUpdateMode) {
      event = _bloc.parentEvent;
      if (_bloc.selectedFactDate != null) {
        dateFieldController.text = _bloc.selectedFactDate.dateForHuman() ?? '';
      }
      if (_bloc.selectedFactTime != null) {
        var time = _bloc.selectedFactTime;
        timeFieldController.text =
            '${time.hour < 10 ? '0' : ''}${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}';
      }
      if (_bloc.inputtedComments.isNotEmpty) {
        commentFieldController.text = _bloc.inputtedComments;
      }
    }
  }

  @override
  void dispose() {
    dateFieldController.dispose();
    timeFieldController.dispose();
    commentFieldController.dispose();
    super.dispose();
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

    if (_bloc.statusReferences == null || _bloc.statusReferences.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Заявка № ${_bloc.request.number}'),
          ),
          body: Container(
              color: Colors.white,
              child: Center(
                  child: Text('Не заполнен справочник статусов',
                      style: TextStyle(fontSize: 24, color: Colors.black38)))),
          bottomNavigationBar: bottomNavigationBar);
    }

    var rowDivider = SizedBox(
      height: 8,
    );
    var headerDivider = SizedBox(
      height: 4,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isUpdateMode
              ? 'Корректировка события'
              : 'Заявка № ${_bloc.request.number}',
          textAlign: TextAlign.center,
        ),
      ),
      body: Form(
        key: _formKey,
//        autovalidate: true,
        child: Container(
            color: Colors.white30,
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Дата работы:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      headerDivider,
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 32),
                        child: Container(
                          width: 140,
                          /*FractionallySizedBox(
                          widthFactor: 0.5,*/
                          child: DropdownButtonFormField<DateTime>(
                            hint: _getDateHint(),
                            value: _bloc.selectedDate,
                            elevation: 4,
                            isExpanded: true,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                filled: isUpdateMode,
                                fillColor: _fillColor,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            items: _getDateItems(),
                            onChanged: (DateTime value) {
                              if (!isUpdateMode) {
                                setState(() {
                                  _bloc.updateIntervalList(date: value);
                                });
                              }
                            },
                            validator: (DateTime value) {
                              return null;
                            },
                          ),
                        ),
                      ),
                      rowDivider,
                      Text(
                        'Интервал работы:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      headerDivider,
                      Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 32),
                          child: Container(
                            width: 140,
                            /*FractionallySizedBox(
                            widthFactor: 0.5,*/
                            child: DropdownButtonFormField<WorkInterval>(
                              hint: _getIntervalHint(),
                              value: _bloc.selectedInterval,
                              elevation: 4,
                              isExpanded: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  filled: isUpdateMode,
                                  fillColor: _fillColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                              items: _getIntervalItems(),
                              onChanged: (WorkInterval value) {
                                if (!isUpdateMode) {
                                  setState(() {
                                    _bloc.selectedInterval = value;
                                  });
                                }
                              },
                              validator: (WorkInterval value) {
                                return null;
                              },
                            ),
                          )),
                      rowDivider,
                      Text(
                        'Статус:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      headerDivider,
                      Container(
                        alignment: Alignment.center,
//                        padding: EdgeInsets.only(right: 32),
                        child: Container(
                            width: 200,
                            /*FractionallySizedBox(
                            widthFactor: 0.7,*/
                            child: DropdownButtonFormField<Status>(
                              value: _bloc.selectedStatus,
                              elevation: 4,
                              isExpanded: true,
                              decoration: InputDecoration(
                                  helperText: _bloc.selectedStatus == null
                                      ? 'Обязательное поле'
                                      : '',
                                  contentPadding: EdgeInsets.only(left: 8),
//                                  filled: _bloc.selectedStatus == null,
//                                  fillColor: _fillColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                              items: _bloc.statusReferences
                                  .map((Status e) => DropdownMenuItem<Status>(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            e.name,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      value: e))
                                  .toList(),
                              onChanged: (Status value) {
                                setState(() {
                                  _bloc.selectedStatus = value;
                                });
                              },
                              validator: (Status value) {
                                if (value == null) {
                                  return 'Обязательное поле';
                                }
                                return null;
                              },
                            )),
                      ),
                      rowDivider,
                      Text(
                        'Пользовательское время:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      headerDivider,
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
//                            Text('дата'),
//                            SizedBox(width: 8),
                            Container(
                              width: 100,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Дата',
                                    contentPadding: EdgeInsets.only(left: 8),
//                                    filled: _bloc.selectedFactDate == null,
//                                    fillColor: _fillColor,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)))),
                                readOnly: true,
                                controller: dateFieldController,
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: _bloc.selectedFactDate ??
                                              DateTime.now(),
                                          firstDate: DateTime.now()
                                              .subtract(Duration(days: 30)),
                                          lastDate: DateTime.now())
                                      .then((DateTime value) {
                                    if (value != null) {
                                      setState(() {
                                        _bloc.selectedFactDate = value;
                                        dateFieldController.text =
                                            value.dateForHuman();
                                      });
                                    }
                                  });
                                },
                                validator: (String value) {
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
//                            Text('время'),
//                            SizedBox(
//                              width: 8,
//                            ),
                            Container(
                              width: 70,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Время',
                                    contentPadding: EdgeInsets.only(left: 8),
//                                    filled: _bloc.selectedFactTime == null,
//                                    fillColor: _fillColor,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)))),
                                readOnly: true,
                                controller: timeFieldController,
                                onTap: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((TimeOfDay value) {
                                    if (value != null) {
                                      setState(() {
                                        _bloc.selectedFactTime = value;
                                        timeFieldController.text =
                                            '${value.hour < 10 ? '0' : ''}${value.hour}:${value.minute < 10 ? '0' : ''}${value.minute}';
                                      });
                                    }
                                  });
                                },
                                validator: (String value) {
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      rowDivider,
                      Text(
                        'Комментарий к статусу:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      headerDivider,
                      TextFormField(
                        autofocus: false,
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
//                            filled: _bloc.inputtedComments.isEmpty,
//                            fillColor: _fillColor,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        controller: commentFieldController,
                        onChanged: (String value) {
                          setState(() {
                            _bloc.inputtedComments = value;
                          });
                        },
                        validator: (String value) {
                          return null;
                        },
                      ),
                      rowDivider,
                      Center(
                        child: MaterialButton(
                          elevation: 8,
                          child: Text(
                            isUpdateMode ? 'Корректировать' : 'Добавить',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _bloc.onTapAddButton();
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Container(
                                  width: 100,
                                  child: Text(
                                    'Заполните обязательные поля',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        /*color: Theme.of(context).errorColor*/),
                                  ),
                                ),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.fixed,
//                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
//                                backgroundColor:
//                                    Theme.of(context).primaryColorDark,
                              ));
                            }
                          },
                        ),
                      )
                    ],
                  )),
            )),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _getDateHint() {
    Widget result;
//    if (isUpdateMode) {
      var isNullDate = _bloc.selectedDate == null;
      result = Align(
          alignment: Alignment.center,
          child: Text(
              isNullDate ? 'Не задано' : _bloc.selectedDate.dateForHuman()));
//    }
    return result;
  }

  Widget _getIntervalHint() {
    Widget result;
//    if (isUpdateMode) {
      var isNullInterval = _bloc.selectedInterval == null;
      result = Align(
          alignment: Alignment.center,
          child: Text(isNullInterval
              ? 'Не задано'
              : _bloc.selectedInterval.toString()));
//    }
    return result;
  }

  List<DropdownMenuItem<DateTime>> _getDateItems() {
    if (_bloc.intervalDates == null || _bloc.intervalDates.isEmpty) {
      return null;
    }

    var result = <DropdownMenuItem<DateTime>>[];

    var firstItem = DropdownMenuItem<DateTime>(
        child: Align(alignment: Alignment.center, child: Text('Не задано')),
        value: null);
    result.add(firstItem);

    if (!isUpdateMode) {
      var anotherItems = _bloc.intervalDates
          .map((DateTime e) => DropdownMenuItem<DateTime>(
              child: Align(
                  alignment: Alignment.center, child: Text(e.dateForHuman())),
              value: e))
          .toList();
      result.addAll(anotherItems);
    }
    return result;
  }

  List<DropdownMenuItem<WorkInterval>> _getIntervalItems() {
    if (_bloc.intervalsByDate == null || _bloc.intervalsByDate.isEmpty) {
      return null;
    }

    var result = <DropdownMenuItem<WorkInterval>>[];

    var firstItem = DropdownMenuItem<WorkInterval>(
        child: Align(alignment: Alignment.center, child: Text('Не задано')),
        value: null);
    result.add(firstItem);

    if (!isUpdateMode) {
      var anotherItems = _bloc.intervalsByDate
          .map((WorkInterval e) => DropdownMenuItem<WorkInterval>(
              child:
                  Align(alignment: Alignment.center, child: Text(e.toString())),
              value: e))
          .toList();
      result.addAll(anotherItems);
    }
    return result;
  }
}
