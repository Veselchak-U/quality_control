import 'package:flutter/material.dart';
import 'package:quality_control/bloc/request_bloc.dart';
import 'package:quality_control/entity/request_item.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class RequestScreenItem extends StatelessWidget {
  RequestScreenItem(this.requestItem, this.bloc);

  final RequestItem requestItem;
  final RequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        bloc.onTapListItem(requestItem: requestItem);
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
                        'Заявка: ${requestItem.number}',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(width: 8),
                  Expanded(
                      child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
//                    spacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      Text(
                        requestItem.dateFrom.formatDate('dd.MM.yy'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
//                      Text(
//                        ' - ',
//                        style: TextStyle(fontWeight: FontWeight.bold),
//                      ),
                      Text(
                        ' - ${requestItem.dateTo.formatDate('dd.MM.yy')}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
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
                      'Интервалы:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(child: Text(requestItem.allIntervalsToString())),
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
                      'Маршрут:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                      child: Text('${requestItem.routeFrom} - ${requestItem.routeTo}')),
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
                          '${requestItem.customer} - ${requestItem.customerDelegat.toFullFIO()}')),
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
