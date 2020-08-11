import 'package:fimber/fimber.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/request_interval_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class StreamService {
  StreamService() {
    initialize();
    _log.i('create');
  }

  // Текущее состояние приложения
  final BehaviorSubject<AppState> appStateStream = BehaviorSubject<AppState>();

  // Заявки - входящий поток
  final BehaviorSubject<List<Request>> requestsStream =
      BehaviorSubject<List<Request>>();

  // Элементы списка: заявки
  final BehaviorSubject<List<Request>> requestItemsStream =
      BehaviorSubject<List<Request>>();

  // Элементы списка: интервалы заявок
  final BehaviorSubject<List<RequestIntervalItem>> requestIntervalItemsStream =
      BehaviorSubject<List<RequestIntervalItem>>();

  // Элементы списка: события по заявке
  final BehaviorSubject<List<EventItem>> eventItemsStream =
      BehaviorSubject<List<EventItem>>();

  // События о необходимости обновления данных
  final PublishSubject<RefreshDataEvent> refreshDataEventsStream =
      PublishSubject<RefreshDataEvent>();

  AppState _appState;

  final FimberLog _log = FimberLog('StreamService');

  // фильтр заявок по-умолчанию (дата)
  FilterByDate _requestFilterByDate;

  FilterByDate get requestFilterByDate => _requestFilterByDate;

  set requestFilterByDate(FilterByDate value) {
    _requestFilterByDate = value;
    refreshDataEventsStream.add(RefreshDataEvent.REFRESH_REQUESTS);
  }

  // фильтр заявок по-умолчанию (текст)
  String _requestFilterByText;

  String get requestFilterByText => _requestFilterByText;

  set requestFilterByText(String value) {
    _requestFilterByText = value;
    refreshDataEventsStream.add(RefreshDataEvent.REFRESH_REQUESTS);
  }

  bool initialize() {
    _log.d('initialize() start');

    _requestFilterByDate = FilterByDate.TODAY;
    _requestFilterByText = '';

    requestsStream.map(_filterRequests).listen(requestItemsStream.add);
    requestsStream
        .map(_convertRequestToRequestIntervalItem)
        .map(_filterRequestsIntervalItem)
        .listen(requestIntervalItemsStream.add);
    requestsStream.map(_filterCurrentEventItems).listen(eventItemsStream.add);

    appStateStream.listen((AppState value) {
      _appState = value;
    });

    _log.d('initialize() end');
    return true;
  }

  List<EventItem> _filterCurrentEventItems(List<Request> requests) {
    List<EventItem> result = [];
    var currentRequestId = _appState?.requestId;
    if (currentRequestId != null) {
      var index = requests.indexWhere((Request r) => r.id == currentRequestId);
      if (index != -1) {
        List<Event> events = requests[index].events;
        if (events != null) {
          // filter by chain
          var filterEvents = <Event>[];
          var rootId = _appState?.eventFilterByChain;
          var isNotChainShow = rootId == null || rootId.isEmpty;
          if (isNotChainShow) {
            filterEvents = events;
          } else {
            events.forEach((Event e) {
              if (rootId == e.rootId || rootId == e.id) {
                filterEvents.add(e);
              }
            });
          }
          // convert to eventItem
          if (filterEvents != null) {
            // DATE_LABEL
            var currentDate = filterEvents[0].systemDate.trunc();
            result.add(_getDateLabelEvent(date: currentDate));

            filterEvents.forEach((Event e) {
              // DATE_LABEL
              var nextDate = e.systemDate.trunc();
              if (nextDate != currentDate) {
                currentDate = nextDate;
                result.add(_getDateLabelEvent(date: currentDate));
              }
              // EVENT
              EventItem eventItem;
              if (isNotChainShow && e.childId == null) {
                eventItem = EventItem(
                    type: EventItemType.EVENT,
                    event: e,
                    isAlien: _isAlienEvent(event: e),
                    isReadOnly: _isReadOnlyEvent(event: e),
                    isHaveHistory: e.rootId != null || e.childId != null);
                result.add(eventItem);
              } else if (!isNotChainShow) {
                eventItem = EventItem(
                    type: EventItemType.EVENT,
                    event: e,
                    isAlien: _isAlienEvent(event: e),
                    isReadOnly: _isReadOnlyEvent(event: e),
                    isHaveHistory: true);
                result.add(eventItem);
              }
            });
          }
        }
      }
    }
    return result;
  }

  bool _isAlienEvent({Event event}) {
    bool result = true;
    var currentUserId = _appState.user.id;
    if (event.user.id == currentUserId) {
      result = false;
    }
    return result;
  }

  bool _isReadOnlyEvent({Event event}) {
    bool result = false;
    if (event.eventType == EventType.SET_RATING) {
      var ratings = _appState.ratingReferences;
      if (ratings != null) {
        var index =
            ratings.indexWhere((Rating e) => e.label == event.ratingLabel);
        if (index != -1 && ratings[index].isCanUpdate == false) {
          result = true;
        }
      }
    }
    return result;
  }

  EventItem _getDateLabelEvent({DateTime date}) {
    return EventItem(
        type: EventItemType.DATE_LABEL, labelText: date.dateForHuman());
  }

  List<Request> _filterRequests(List<Request> inRequests) {
    // Сначала фильтруем заявки по дате
    List<Request> filteredByDate = [];
    var today = DateTime.now().trunc();

    if (_requestFilterByDate == FilterByDate.TODAY) {
      inRequests.forEach((Request request) {
        var index = request.intervals
            .indexWhere((WorkInterval i) => i.dateBegin.trunc() == today);
        if (index != -1) {
          filteredByDate.add(request);
        }
      });
    } else if (_requestFilterByDate == FilterByDate.BEFORE) {
      inRequests.forEach((Request request) {
        var index = request.intervals.indexWhere(
            (WorkInterval i) => i.dateBegin.trunc().isBefore(today));
        if (index != -1) {
          filteredByDate.add(request);
        }
      });
    } else if (_requestFilterByDate == FilterByDate.AFTER) {
      inRequests.forEach((Request request) {
        var index = request.intervals
            .indexWhere((WorkInterval i) => i.dateBegin.trunc().isAfter(today));
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
            '${r.number}$d${r.dateFrom.dateForHuman()}$d${r.dateTo.dateForHuman()}$d${r.allIntervalsToString()}$d';
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
      request.intervals.forEach((WorkInterval interval) {
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
            '${i.number}$d${i.interval.dateBegin.dateForHuman()}$d${i.intervalTimes()}$d';
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
    requestsStream.close();
    requestItemsStream.close();
    requestIntervalItemsStream.close();
    eventItemsStream.close();
    refreshDataEventsStream.close();
    _log.i('dispose');
  }
}

enum FilterByDate { BEFORE, TODAY, AFTER }

enum RefreshDataEvent { REFRESH_REQUESTS }
