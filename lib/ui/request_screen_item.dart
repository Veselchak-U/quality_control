import 'package:flutter/material.dart';
import 'package:quality_control/bloc/request_bloc.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class RequestScreenItem extends StatelessWidget {
  RequestScreenItem(this.request, this.bloc);

  final Request request;
  final RequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        bloc.onTapListItem(requestId: request.id);
      },
      splashColor: Theme.of(context).accentColor,
      child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
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
                        'Заявка: ${request.number}',
                        style: TextStyle(color: Colors.white),
                      )),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        '${request.dateFrom.toStringForHuman()} - ${request.dateTo.toStringForHuman()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                  Flexible(child: Text(request.intervalsToString())),
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
                      child: Text('${request.routeFrom} - ${request.routeTo}')),
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
                          '${request.customer} - ${request.customerDelegat.toFullFIO()}')),
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
