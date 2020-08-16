import 'package:flutter/material.dart';
import 'package:quality_control/bloc/request_bloc.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class RequestScreenIntervalItem extends StatelessWidget {
  RequestScreenIntervalItem(this.intervalItem, this.bloc);

  final RequestIntervalItem intervalItem;
  final RequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        bloc.onTapListItem(intervalItem: intervalItem);
      },
      splashColor: Theme.of(context).accentColor,
      child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: _getStatusColor(),
                      ),
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Text(
                        'Заявка: ${intervalItem.number}',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      alignment: WrapAlignment.end,
                      children: [
                        Text(intervalItem.interval.dateBegin.formatDate('dd.MM.yy')),
                        Text(intervalItem.intervalTimes(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      'Маршрут:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(child: Text('${intervalItem.routeFrom} - ${intervalItem.routeTo}')),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      'Заказчик:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                      child: Text(
                          '${intervalItem.customer} - ${intervalItem.customerDelegat.toFullFIO()}')),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Divider(
                thickness: 2,
                color: Colors.black12,
              )
            ],
          )),
    );
  }

  Color _getStatusColor() {
    var color = Colors.green;
//    if (_requestItem.status == RequestStatus.ACTIVE) {
//      color = Colors.green;
//    } else if (_requestItem.status == RequestStatus.WORK) {
//      color = Colors.orange;
//    } else if (_requestItem.status == RequestStatus.DONE) {
//      color = bDazzledBlueColor;
//    } else if (_requestItem.status == RequestStatus.CANCEL) {
//      color = Colors.black38;
//    }
    return color;
  }
}
