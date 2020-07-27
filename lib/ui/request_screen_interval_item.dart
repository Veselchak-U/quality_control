import 'package:flutter/material.dart';
import 'package:quality_control/bloc/request_bloc.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:quality_control/util/utils.dart';

class RequestScreenIntervalItem extends StatelessWidget {
  RequestScreenIntervalItem(this.item, this.bloc);

  final RequestIntervalItem item;
  final RequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('№${item.number}')),
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(Utils.extractDate(item.interval.dateBegin))),
                Text(Utils.extractIntervalTime(item.interval)),
              ],
            ),
            Row(
              children: [],
            ),
            Row(
              children: [],
            ),
          ],
        ));
  }
}
