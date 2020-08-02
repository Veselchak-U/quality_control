import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/status_bloc.dart';
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
  var dateFieldController = TextEditingController();
  var timeFieldController = TextEditingController();
  var commentFieldController = TextEditingController();

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
          'Заявка № ${_bloc.request.number}',
          textAlign: TextAlign.center,
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: Container(
            color: Colors.white30,
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Дата работы:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: DropdownButtonFormField<DateTime>(
                            hint: Text('Дата работы'),
                            value: _bloc.selectedDate,
                            elevation: 4,
                            isExpanded: true,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                filled: true,
                                fillColor: Colors.black12,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            items: _bloc.intervalDates
                                .map((DateTime e) => DropdownMenuItem<DateTime>(
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          e.toStringForHuman(),
                                        )),
                                    value: e))
                                .toList(),
                            onChanged: (DateTime value) {
                              setState(() {
//                            _bloc.currentDate = value;
                                _bloc.updateIntervalList(date: value);
                              });
                            },
                            validator: (DateTime value) {
//                          if (_currentDate == null) {
//                            return 'Укажите марку авто';
//                          }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Интервал работы:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: DropdownButtonFormField<WorkInterval>(
                              hint: Text('Интервал работы'),
                              value: _bloc.selectedInterval,
                              elevation: 4,
                              isExpanded: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                              items: _bloc.intervalsByDate
                                  .map((WorkInterval e) =>
                                      DropdownMenuItem<WorkInterval>(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text(e.intervalTimes())),
                                          value: e))
                                  .toList(),
                              onChanged: (WorkInterval value) {
                                setState(() {
//                            _currentInterval = value;
                                  _bloc.selectedInterval = value;
                                });
                              },
                              validator: (WorkInterval value) {
//                          if (_currentDate == null) {
//                            return 'Укажите марку авто';
//                          }
                                return null;
                              },
                            ),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Статус:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                        child: FractionallySizedBox(
                            widthFactor: 0.7,
                            child: DropdownButtonFormField<Status>(
                              hint: Text('Статус'),
                              elevation: 4,
                              isExpanded: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                              items: _bloc.statusReferences
                                  .map((Status e) => DropdownMenuItem<Status>(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(e.name)),
                                      value: e))
                                  .toList(),
                              onChanged: (Status value) {
                                setState(() {
//                            _currentInterval = value;
                                  _bloc.selectedStatus = value;
                                });
                              },
                              validator: (Status value) {
//                          if (_currentDate == null) {
//                            return 'Укажите марку авто';
//                          }
                                return null;
                              },
                            )),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Фактическое выполнение:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('дата'),
                            SizedBox(width: 8,),
                            Container(
                              width: 100,
                              child: TextFormField(
                                decoration: InputDecoration(
//                                    labelText: 'Дата',
                                    contentPadding: EdgeInsets.only(left: 8),
                                    filled: true,
                                    fillColor: Colors.black12,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)))),
                                readOnly: true,
                                controller: dateFieldController,
//                            focusNode: releaseDateFocusNode,
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
                                      _bloc.selectedFactDate = value;
                                      dateFieldController.text =
                                          value.toStringForHuman();
                                    }
                                  });
//                                FocusScope.of(context)
//                                    .requestFocus(odometerFocusNode);
                                },
                                validator: (String value) {
//                              if (releaseDate == null) {
//                                return 'Укажите дату события';
//                              }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text('время'),
                            SizedBox(width: 8,),
                            Container(
                              width: 70,
                              child: TextFormField(
                                decoration: InputDecoration(
//                                    labelText: 'Время',
                                    contentPadding: EdgeInsets.only(left: 8),
                                    filled: true,
                                    fillColor: Colors.black12,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)))),
                                readOnly: true,
                                controller: timeFieldController,
//                            focusNode: releaseDateFocusNode,
                                onTap: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((TimeOfDay value) {
                                    if (value != null) {
                                      _bloc.selectedFactTime = value;
                                      timeFieldController.text =
                                          '${value.hour < 10 ? '0' : ''}${value.hour}:${value.minute < 10 ? '0' : ''}${value.minute}';
                                    }
                                  });
                                },
                                validator: (String value) {
//                              if (releaseDate == null) {
//                                return 'Укажите дату события';
//                              }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Комментарий к статусу',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        autofocus: false,
                        maxLines: 5,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
//                            filled: true,
//                            fillColor: Colors.black12,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        controller: commentFieldController,
//                            focusNode: releaseDateFocusNode,
                        onFieldSubmitted: (String value) {
                          _bloc.inputedComments = value;
//                          FocusScope.of(context)
//                              .requestFocus(stateNumberFocusNode);
                        },
                        validator: (String value) {
//                              if (releaseDate == null) {
//                                return 'Укажите дату события';
//                              }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: MaterialButton(
                          child: Text(
                            'Добавить',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            _bloc.onTapAddButton();
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
}
