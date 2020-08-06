import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/quality_bloc.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class QualityScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QualityScreenState();
}

class _QualityScreenState extends State<QualityScreen> {
  QualityBloc _bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//  final Color _fillColor = Color(0xfff0f0f0);
  final Color _fillColor = Color(0xffe5e5e5);
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
    var primaryColor = Theme.of(context).primaryColor;

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
      key: _scaffoldKey,
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
                        padding: EdgeInsets.only(right: 32),
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: DropdownButtonFormField<DateTime>(
                            hint: Text('Дата работы'),
                            value: _bloc.selectedDate,
                            elevation: 4,
                            isExpanded: true,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                filled: _bloc.selectedDate == null,
                                fillColor: _fillColor,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            items: _bloc.intervalDates
                                .map((DateTime e) => DropdownMenuItem<DateTime>(
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          e.dateForHuman(),
                                        )),
                                    value: e))
                                .toList(),
                            onChanged: (DateTime value) {
                              setState(() {
                                _bloc.updateIntervalList(date: value);
                              });
                            },
                            validator: (DateTime value) {
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
                          padding: EdgeInsets.only(right: 32),
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: DropdownButtonFormField<WorkInterval>(
                              hint: Text('Интервал работы'),
                              value: _bloc.selectedInterval,
                              elevation: 4,
                              isExpanded: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  filled: _bloc.selectedInterval == null,
                                  fillColor: _fillColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                              items: _bloc.intervalsByDate
                                  .map((WorkInterval e) =>
                                      DropdownMenuItem<WorkInterval>(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text(e.toString())),
                                          value: e))
                                  .toList(),
                              onChanged: (WorkInterval value) {
                                setState(() {
                                  _bloc.selectedInterval = value;
                                });
                              },
                              validator: (WorkInterval value) {
                                return null;
                              },
                            ),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Оценка выполнения:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBar(
                              itemCount: 5,
                              unratedColor: primaryColor.withAlpha(50),
                              glowColor: primaryColor,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4),
                              itemBuilder: (BuildContext context, _) => Icon(
                                Icons.star,
                                color: primaryColor,
                              ),
                              onRatingUpdate: (double value) {
                                setState(() {
                                  _bloc.onSelectRating(value);
                                });
                                print(value);
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              _bloc.selectedRating?.name ?? '',
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Комментарий к оценке:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
//                        padding: EdgeInsets.only(right: 32),
                        child: FractionallySizedBox(
                            widthFactor: 1,
                            child: DropdownButtonFormField<String>(
                              value: _bloc.selectedPresetComment,
                              elevation: 4,
                              isExpanded: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: _bloc.selectedPresetComment == null,
                                  fillColor: _fillColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                              items: _bloc.presetComments
                                  .map((String e) => DropdownMenuItem<String>(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(e)),
                                      value: e))
                                  .toList(),
                              onChanged: (String value) {
                                setState(() {
                                  _bloc.selectedPresetComment = value;
                                });
                              },
                              validator: (String value) {
                                if (_bloc.isPresetCommentRequared &&
                                    value == null) {
                                  return 'Обязательное поле';
                                }
                                return null;
                              },
                            )),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Дополнение к комментарию:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        autofocus: false,
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            filled: _bloc.inputedComments.isEmpty,
                            fillColor: _fillColor,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        controller: commentFieldController,
                        onFieldSubmitted: (String value) {
                          setState(() {
                            _bloc.inputedComments = value;
                          });
                        },
                        validator: (String value) {
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
                          color: primaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate() &&
                                _bloc.selectedRating != null) {
                              _bloc.onTapAddButton();
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Container(
                                  width: 100,
                                  child: Text(
                                    _bloc.selectedRating == null
                                        ? 'Выставьте оценку'
                                        : 'Заполните обязательные поля',
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
}
