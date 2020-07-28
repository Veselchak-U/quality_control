import 'package:fimber/fimber.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/interval.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quality_control/extention/datetime_extension.dart';

class StreamService {
  StreamService() {
    requestFilterByDate =
        FilterByDate.TODAY; // фильтр заявок по-умолчанию (дата)
    requestFilterByText = ''; // фильтр заявок по-умолчанию (текст)
    listRequests.map(_filterRequests).listen(listRequestItems.add);
    listRequests
        .map(_convertRequestToRequestIntervalItem)
        .map(_filterRequestsIntervalItem)
        .listen(listRequestIntervalItems.add);
    _log.i('create');
  }

  // Заявки - входящий поток
  final BehaviorSubject<List<Request>> listRequests =
      BehaviorSubject<List<Request>>();

  // Элементы списка: заявки
  final BehaviorSubject<List<Request>> listRequestItems =
      BehaviorSubject<List<Request>>();

  // Элементы списка: интервалы заявок
  final BehaviorSubject<List<RequestIntervalItem>> listRequestIntervalItems =
      BehaviorSubject<List<RequestIntervalItem>>();

  // Элементы списка: события по заявке
  final BehaviorSubject<List<Event>> listEvents =
      BehaviorSubject<List<Event>>();

  FilterByDate requestFilterByDate;
  String requestFilterByText;
  final FimberLog _log = FimberLog('StreamService');

  List<Request> _filterRequests(List<Request> inRequests) {
    // Сначала фильтруем заявки по дате
    List<Request> filteredByDate = [];
    var today = DateTime.now().trunc();

    if (requestFilterByDate == FilterByDate.TODAY) {
      inRequests.forEach((Request request) {
        var index = request.intervals
            .indexWhere((Interval i) => i.dateBegin.trunc() == today);
        if (index != -1) {
          filteredByDate.add(request);
        }
      });
    } else if (requestFilterByDate == FilterByDate.BEFORE) {
      inRequests.forEach((Request request) {
        var index = request.intervals
            .indexWhere((Interval i) => i.dateBegin.trunc().isBefore(today));
        if (index != -1) {
          filteredByDate.add(request);
        }
      });
    } else if (requestFilterByDate == FilterByDate.AFTER) {
      inRequests.forEach((Request request) {
        var index = request.intervals
            .indexWhere((Interval i) => i.dateBegin.trunc().isAfter(today));
        if (index != -1) {
          filteredByDate.add(request);
        }
      });
    }

    // Затем фильтруем заявки по тексту поиска
    List<Request> filteredByText = [];

    if (requestFilterByText.isEmpty) {
      filteredByText = filteredByDate;
    } else {
      var searchString = requestFilterByText.toLowerCase();
      filteredByDate.forEach((Request r) {
        var data1 =
            '${r.number}${r.dateFrom.toStringForHuman()}${r.dateTo.toStringForHuman()}${r.intervalsToString()}';
        var data2 = '${r.routeFrom}${r.routeTo}';
        var data3 =
            '${r.customer}${r.customerDelegat.lastName}${r.customerDelegat.firstName}${r.customerDelegat.middleName}';
        var dataString = '$data1$data2$data3'.toLowerCase();
        if (dataString.contains(searchString)) {
          filteredByText.add(r);
        }
      });
    }

    return filteredByText;
  }

  List<RequestIntervalItem> _convertRequestToRequestIntervalItem(
      List<Request> requests) {
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
    _log.d('_convertRequestToRequestIntervalItem ${result.length} items');
    return result;
  }

  List<RequestIntervalItem> _filterRequestsIntervalItem(
      List<RequestIntervalItem> inItems) {
    // Сначала фильтруем интервалы по дате
    List<RequestIntervalItem> filteredByDate = [];
    var today = DateTime.now().trunc();

    if (requestFilterByDate == FilterByDate.TODAY) {
      inItems.forEach((RequestIntervalItem item) {
        if (item.interval.dateBegin.trunc() == today) {
          filteredByDate.add(item);
        }
      });
    } else if (requestFilterByDate == FilterByDate.BEFORE) {
      inItems.forEach((RequestIntervalItem item) {
        if (item.interval.dateBegin.trunc().isBefore(today)) {
          filteredByDate.add(item);
        }
      });
    } else if (requestFilterByDate == FilterByDate.AFTER) {
      inItems.forEach((RequestIntervalItem item) {
        if (item.interval.dateBegin.trunc().isAfter(today)) {
          filteredByDate.add(item);
        }
      });
    }

    // Затем фильтруем интервалы по тексту поиска
    List<RequestIntervalItem> filteredByText = [];

    if (requestFilterByText.isEmpty) {
      filteredByText = filteredByDate;
    } else {
      var searchString = requestFilterByText.toLowerCase();
      filteredByDate.forEach((RequestIntervalItem i) {
        var data1 =
            '${i.number}${i.interval.dateBegin.toStringForHuman()}'; // TODO(dyv): добавить поиск по времени интервала
        var data2 = '${i.routeFrom}${i.routeTo}';
        var data3 =
            '${i.customer}${i.customerDelegat.lastName}${i.customerDelegat.firstName}${i.customerDelegat.middleName}';
        var dataString = '$data1$data2$data3'.toLowerCase();
        if (dataString.contains(searchString)) {
          filteredByText.add(i);
        }
      });
    }

    return filteredByText;
  }
}

enum FilterByDate { BEFORE, TODAY, AFTER }
