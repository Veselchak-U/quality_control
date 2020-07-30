import 'package:fimber/fimber.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/interval.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class StreamService {
  StreamService() {
    _requestFilterByDate = FilterByDate.TODAY;
    _requestFilterByText = '';
    listRequests.map(_filterRequests).listen(listRequestItems.add);
    listRequests
        .map(_convertRequestToRequestIntervalItem)
        .map(_filterRequestsIntervalItem)
        .listen(listRequestIntervalItems.add);
//    listRequests.listen(toRequestItems);
//    listRequests.listen(toIntervalItems);
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

  // События о необходимости обновления данных
  final PublishSubject<RefreshDataEvent> refreshData =
      PublishSubject<RefreshDataEvent>();

  final FimberLog _log = FimberLog('StreamService');

  // фильтр заявок по-умолчанию (дата)
  FilterByDate _requestFilterByDate;

  FilterByDate get requestFilterByDate => _requestFilterByDate;

  set requestFilterByDate(FilterByDate value) {
    _requestFilterByDate = value;
    refreshData.add(RefreshDataEvent.REFRESH_REQUESTS);
  }

  // фильтр заявок по-умолчанию (текст)
  String _requestFilterByText;

  String get requestFilterByText => _requestFilterByText;

  set requestFilterByText(String value) {
    _requestFilterByText = value;
    refreshData.add(RefreshDataEvent.REFRESH_REQUESTS);
  }

/*  void toRequestItems(List<Request> inRequests) {
//    listRequests.map(_filterRequests).listen(listRequestItems.add);
    var out = _filterRequests(inRequests);
    listRequestItems.add(out);
    _log.d('listRequestItems.add(out) ${out.length} request');
  }*/

/*  void toIntervalItems(List<Request> inRequests) {
//    listRequests
//        .map(_convertRequestToRequestIntervalItem)
//        .map(_filterRequestsIntervalItem)
//        .listen(listRequestIntervalItems.add);
    listRequestIntervalItems.add(_filterRequestsIntervalItem(
        _convertRequestToRequestIntervalItem(inRequests)));
  }*/

  List<Request> _filterRequests(List<Request> inRequests) {
    // Сначала фильтруем заявки по дате
    List<Request> filteredByDate = [];
    var today = DateTime.now().trunc();

    if (_requestFilterByDate == FilterByDate.TODAY) {
      inRequests.forEach((Request request) {
        var index = request.intervals
            .indexWhere((Interval i) => i.dateBegin.trunc() == today);
        if (index != -1) {
          filteredByDate.add(request);
        }
      });
    } else if (_requestFilterByDate == FilterByDate.BEFORE) {
      inRequests.forEach((Request request) {
        var index = request.intervals
            .indexWhere((Interval i) => i.dateBegin.trunc().isBefore(today));
        if (index != -1) {
          filteredByDate.add(request);
        }
      });
    } else if (_requestFilterByDate == FilterByDate.AFTER) {
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

    if (_requestFilterByText.isEmpty) {
      filteredByText = filteredByDate;
    } else {
      var searchString = _requestFilterByText.toLowerCase();
      var d = String.fromCharCode(0); // delimiter
      filteredByDate.forEach((Request r) {
        var data1 =
            '${r.number}$d${r.dateFrom.toStringForHuman()}$d${r.dateTo.toStringForHuman()}$d${r.intervalsToString()}$d';
        var data2 = '${r.routeFrom}$d${r.routeTo}$d';
        var data3 =
            '${r.customer}$d${r.customerDelegat.lastName}$d${r.customerDelegat.firstName}$d${r.customerDelegat.middleName}$d';
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

    if (_requestFilterByDate == FilterByDate.TODAY) {
      inItems.forEach((RequestIntervalItem item) {
        if (item.interval.dateBegin.trunc() == today) {
          filteredByDate.add(item);
        }
      });
    } else if (_requestFilterByDate == FilterByDate.BEFORE) {
      inItems.forEach((RequestIntervalItem item) {
        if (item.interval.dateBegin.trunc().isBefore(today)) {
          filteredByDate.add(item);
        }
      });
    } else if (_requestFilterByDate == FilterByDate.AFTER) {
      inItems.forEach((RequestIntervalItem item) {
        if (item.interval.dateBegin.trunc().isAfter(today)) {
          filteredByDate.add(item);
        }
      });
    }

    // Затем фильтруем интервалы по тексту поиска
    List<RequestIntervalItem> filteredByText = [];

    if (_requestFilterByText.isEmpty) {
      filteredByText = filteredByDate;
    } else {
      var searchString = _requestFilterByText.toLowerCase();
      var d = String.fromCharCode(0); // delimiter
      filteredByDate.forEach((RequestIntervalItem i) {
        var data1 =
            '${i.number}$d${i.interval.dateBegin.toStringForHuman()}$d${i.intervalTimes()}$d';
        var data2 = '${i.routeFrom}$d${i.routeTo}$d';
        var data3 =
            '${i.customer}$d${i.customerDelegat.lastName}$d${i.customerDelegat.firstName}$d${i.customerDelegat.middleName}$d';
        var dataString = '$data1$data2$data3'.toLowerCase();
        if (dataString.contains(searchString)) {
          filteredByText.add(i);
        }
      });
    }

    return filteredByText;
  }

  void dispose() {
    listRequests.close();
    listRequestItems.close();
    listRequestIntervalItems.close();
    listEvents.close();
    refreshData.close();
    _log.i('dispose');
  }

}

enum FilterByDate { BEFORE, TODAY, AFTER }

enum RefreshDataEvent { REFRESH_REQUESTS }
