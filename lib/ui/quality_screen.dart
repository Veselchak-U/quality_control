import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quality_control/bloc/common/bloc_provider.dart';
import 'package:quality_control/bloc/quality_bloc.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/extension/datetime_extension.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

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
      event = _bloc.event;
      if (_bloc.inputtedComments.isNotEmpty) {
        commentFieldController.text = _bloc.inputtedComments;
      }
    }
  }

  @override
  void dispose() {
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

    if (_bloc.ratingReferences == null || _bloc.ratingReferences.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Заявка № ${_bloc.request.number}',
              textAlign: TextAlign.center,
            ),
          ),
          body: Container(
              color: Colors.white,
              child: Center(
                  child: Text('Не заполнен справочник оценок',
                      style: TextStyle(fontSize: 24, color: Colors.black38)))),
          bottomNavigationBar: bottomNavigationBar);
    }

    var deviceInfo = MediaQuery.of(context);
    var screenHPadding = 32.0;
    var ratingStarSize = 36.0;
    var ratingStarSpacing = (deviceInfo.size.width -
            (screenHPadding * 2) -
            (ratingStarSize * _bloc.ratingReferences.length)) /
        (_bloc.ratingReferences.length - 1);
    ratingStarSpacing = ratingStarSpacing > 16 ? 16 : ratingStarSpacing;
    ratingStarSpacing = ratingStarSpacing < 0 ? 0 : ratingStarSpacing;

    var primaryColor = Theme.of(context).primaryColor;

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
                  padding:
                      EdgeInsets.fromLTRB(screenHPadding, 8, screenHPadding, 8),
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
                          child: Center(
                            child: DropdownButtonFormField<DateTime>(
                              hint: isUpdateMode
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          _bloc.selectedDate.dateForHuman()))
                                  : Align(
                                      alignment: Alignment.center,
                                      child: Text('Дата работы')),
                              value: _bloc.selectedDate,
                              elevation: 4,
                              isExpanded: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  filled: _bloc.selectedDate == null,
                                  fillColor: _fillColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                              items: isUpdateMode
                                  ? null
                                  : _bloc.intervalDates
                                      .map((DateTime e) =>
                                          DropdownMenuItem<DateTime>(
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
                              hint: isUpdateMode
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          _bloc.selectedInterval.toString()))
                                  : Align(
                                      alignment: Alignment.center,
                                      child: Text('Интервал работы')),
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
                              items: isUpdateMode
                                  ? null
                                  : _bloc.intervalsByDate
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
                      rowDivider,
                      Text(
                        'Оценка выполнения:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (double value) {
                                  setState(() {
                                    _bloc.onSelectRating(value);
                                  });
                                },
                                starCount: _bloc.ratingReferences.length,
                                rating: isUpdateMode
                                    ? _bloc.selectedRatingIndex + 1
                                    : 0,
                                size: ratingStarSize,
                                isReadOnly: false,
                                defaultIconData: Icons.star_border,
                                filledIconData: Icons.star,
                                color: primaryColor,
                                borderColor: primaryColor,
                                spacing:
                                    ratingStarSpacing /*isThinDisplay ? 0 : 16*/),
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
                      rowDivider,
                      Text(
                        'Комментарий к оценке:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      headerDivider,
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
                                          child: Text(
                                            e,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      value: e))
                                  .toList(),
                              onChanged: (String value) {
                                setState(() {
                                  _bloc.selectedPresetComment = value;
                                });
                              },
                              validator: (String value) {
                                if (_bloc.isPresetCommentRequired &&
                                    value == null) {
                                  return 'Обязательное поле';
                                }
                                return null;
                              },
                            )),
                      ),
                      rowDivider,
                      Text(
                        'Дополнение к комментарию:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      headerDivider,
                      TextFormField(
                        autofocus: false,
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            filled: _bloc.inputtedComments.isEmpty,
                            fillColor: _fillColor,
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
                          child: Text(
                            isUpdateMode ? 'Корректировать' : 'Добавить',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: primaryColor,
                          elevation: 8,
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
