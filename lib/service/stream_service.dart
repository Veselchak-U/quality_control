import 'package:fimber/fimber.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/interval.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:rxdart/rxdart.dart';

class StreamService {
  StreamService() {
    listRequests.listen(_convertRequestToRequestIntervalItem);
    _log.i('create');
  }

  // Заявки
  final BehaviorSubject<List<Request>> listRequests =
      BehaviorSubject<List<Request>>();

  // Элементы списка: интервалы заявок
  final BehaviorSubject<List<RequestIntervalItem>> listRequestIntervalItems =
      BehaviorSubject<List<RequestIntervalItem>>();

  // Элементы списка: события по заявке
  final BehaviorSubject<List<Event>> listEvents =
      BehaviorSubject<List<Event>>();

  final FimberLog _log = FimberLog('StreamService');

  void _convertRequestToRequestIntervalItem(List<Request> requests) {
    var result = <RequestIntervalItem>[];
    RequestIntervalItem item;

    requests.forEach((Request request) {
      request.intervals.forEach((Interval interval) {
        item = RequestIntervalItem(
            requestId: request.id,
            number: request.number,
            interval: interval,
            routeFrom: request.routeFrom,
            routeTo: request.routeTo,
            customer: request.customer,
            customerDelegat: request.customerDelegat);
        result.add(item);
      });
    });

    listRequestIntervalItems.add(result);
    _log.d('listRequestIntervalItem.add ${result.length} items');
  }
}
