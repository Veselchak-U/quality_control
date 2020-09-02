import 'package:fimber/fimber.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/event_item.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request_item.dart';
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

  // Заявки - входящий поток
  final BehaviorSubject<List<Request>> requestsStream =
      BehaviorSubject<List<Request>>();

  // Элементы списка: заявки
  final BehaviorSubject<List<RequestItem>> requestItemsStream =
      BehaviorSubject<List<RequestItem>>();

  // Элементы списка: интервалы заявок
  final BehaviorSubject<List<RequestIntervalItem>> requestIntervalItemsStream =
      BehaviorSubject<List<RequestIntervalItem>>();

  // Элементы списка: события по заявке
  final BehaviorSubject<List<EventItem>> eventItemsStream =
      BehaviorSubject<List<EventItem>>();

  // Элементы списка: цепочка событий корректировки
  final PublishSubject<List<EventItem>> chainItemsStream =
      PublishSubject<List<EventItem>>();

  // События о необходимости обновления данных
  final PublishSubject<RefreshDataEvent> refreshDataEventsStream =
      PublishSubject<RefreshDataEvent>();

  // Поток с текущим состоянием приложения
  final BehaviorSubject<AppState> appStateStream = BehaviorSubject<AppState>();

  // Текущее состояние приложения (для локального применения)
  AppState _appState;

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

  final FimberLog _log = FimberLog('StreamService');

  bool initialize() {
    _log.d('initialize() start');

    _requestFilterByDate = FilterByDate.TODAY;
    _requestFilterByText = '';

    requestsStream
        .map(_convertRequestsToRequestItems)
        .map(_filterRequestItems)
        .map(_sortRequestItems)
        .listen(requestItemsStream.add);

    requestsStream
        .map(_convertRequestsToRequestIntervalItems)
        .map(_filterRequestIntervalItems)
        .map(_sortRequestIntervalItems)
        .listen(requestIntervalItemsStream.add);

    requestsStream.map(_filterEventItems).listen(eventItemsStream.add);

    requestsStream
        .map(_filterChainEvents)
        .map(_convertToEventItems)
        .listen(chainItemsStream.add);

    appStateStream.listen((AppState value) {
      _appState = value;
    });

    _log.d('initialize() end');
    return true;
  }

  List<Event> _filterChainEvents(List<Request> requests) {
    List<Event> result = [];
    // get chain filter
    var rootId = _appState.eventFilterByChain;
    if (rootId != null && rootId.isNotEmpty) {
      // get current request events
      var currentRequestId = _appState.requestItem?.id;
      if (currentRequestId != null) {
        var index =
            requests.indexWhere((Request r) => r.id == currentRequestId);
        if (index != -1) {
          List<Event> events = requests[index].events;
          if (events != null && events.isNotEmpty) {
            // get events by chain filter
            events.forEach((Event e) {
              if (rootId == e.rootId || rootId == e.id) {
                result.add(e);
              }
            });
          }
        }
      }
    }
    return result;
  }

  List<EventItem> _convertToEventItems(List<Event> filterEvents) {
    List<EventItem> result = [];
    var rootId = _appState.eventFilterByChain;
    var isChainShow = rootId != null && rootId.isNotEmpty;

    if (filterEvents != null && filterEvents.isNotEmpty) {
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
        if (isChainShow) {
          // просмотр цепочки изменений
          eventItem = EventItem(
              type: EventItemType.EVENT,
              event: e,
              isAlien: _isAlienEvent(event: e),
              isReadOnly: _isReadOnlyEvent(event: e),
              isHaveHistory: e.childId != null);
          result.add(eventItem);
        } else {
          // обычный просмотр событий
          if (e.childId == null) {
            // показываем только последнюю корр-ку, но с датой первого события
            eventItem = EventItem(
                type: EventItemType.EVENT,
                event: e,
                rootDate: _getRootDate(events: filterEvents, rootId: e.rootId),
                isAlien: _isAlienEvent(event: e),
                isReadOnly: _isReadOnlyEvent(event: e),
                isHaveHistory: e.rootId != null /* || e.childId != null*/);
            result.add(eventItem);
          }
        }
      });
    }
    return result;
  }

  List<EventItem> _filterEventItems(List<Request> requests) {
    List<EventItem> result = [];
    var currentRequestId = _appState.requestItem?.id;
    if (currentRequestId != null) {
      var index = requests.indexWhere((Request r) => r.id == currentRequestId);
      if (index != -1) {
        List<Event> events = requests[index].events;
        if (events != null && events.isNotEmpty) {
          // filter by chain
          var filterEvents = <Event>[];
          var rootId = _appState.eventFilterByChain;
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
              // обычный просмотр событий
              if (isNotChainShow && e.childId == null) {
                eventItem = EventItem(
                    type: EventItemType.EVENT,
                    event: e,
                    isAlien: _isAlienEvent(event: e),
                    isReadOnly: _isReadOnlyEvent(event: e),
                    isHaveHistory: e.rootId != null || e.childId != null);
                result.add(eventItem);
              } else if (!isNotChainShow) {
                // просмотр цепочки изменений
                eventItem = EventItem(
                    type: EventItemType.EVENT,
                    event: e,
                    isAlien: _isAlienEvent(event: e),
                    isReadOnly: _isReadOnlyEvent(event: e),
                    isHaveHistory: e.childId != null);
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

  DateTime _getRootDate({List<Event> events, String rootId}) {
    DateTime result;
    if (events.isNotEmpty && rootId != null) {
      result = events.firstWhere((Event e) => e.id == rootId).systemDate;
    }
    return result;
  }

  EventItem _getDateLabelEvent({DateTime date}) {
    return EventItem(
        type: EventItemType.DATE_LABEL, labelText: date.dateForHuman());
  }

  List<RequestItem> _filterRequestItems(List<RequestItem> inRequestItems) {
    // Сначала фильтруем заявки по дате
    List<RequestItem> filteredByDate = [];
    var today = DateTime.now().trunc();

    if (_requestFilterByDate == FilterByDate.TODAY) {
      inRequestItems.forEach((item) {
        var index = item.intervals
            .indexWhere((WorkInterval i) => i.dateBegin.trunc() == today);
        if (index != -1) {
          filteredByDate.add(item);
        }
      });
    } else if (_requestFilterByDate == FilterByDate.BEFORE) {
      inRequestItems.forEach((item) {
        var index = item.intervals.indexWhere(
            (WorkInterval i) => i.dateBegin.trunc().isBefore(today));
        if (index != -1) {
          filteredByDate.add(item);
        }
      });
    } else if (_requestFilterByDate == FilterByDate.AFTER) {
      inRequestItems.forEach((item) {
        var index = item.intervals
            .indexWhere((WorkInterval i) => i.dateBegin.trunc().isAfter(today));
        if (index != -1) {
          filteredByDate.add(item);
        }
      });
    }

    // Затем фильтруем заявки по тексту поиска
    List<RequestItem> filteredByText = [];

    if (_requestFilterByText.isEmpty) {
      filteredByText = filteredByDate;
    } else {
      var searchString = _requestFilterByText.toLowerCase();
      var d = String.fromCharCode(0); // delimiter
      filteredByDate.forEach((RequestItem item) {
        var data1 =
            '${item.number}$d${item.dateFrom.dateForHuman()}$d${item.dateTo.dateForHuman()}$d${item.allIntervalsToString()}$d';
        var data2 = '${item.routeFrom}$d${item.routeTo}$d';
        var data3 =
            '${item.customer}$d${item.customerDelegat.lastName}$d${item.customerDelegat.firstName}$d${item.customerDelegat.middleName}$d';
        var dataString = '$data1$data2$data3'.toLowerCase();
        if (dataString.contains(searchString)) {
          filteredByText.add(item);
        }
      });
    }

    return filteredByText;
  }

  List<RequestIntervalItem> _convertRequestsToRequestIntervalItems(
      List<Request> requests) {
    var result = <RequestIntervalItem>[];
    RequestIntervalItem item;

    if (requests != null && requests.isNotEmpty) {
      requests.forEach((Request request) {
        if (request.intervals != null && request.intervals.isNotEmpty) {
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
        }
      });
    }
//    _log.d('_convertRequestToRequestIntervalItem ${result.length} items');
    return result;
  }

  List<RequestItem> _convertRequestsToRequestItems(List<Request> requests) {
    var result = <RequestItem>[];
    RequestItem item;

    if (requests != null && requests.isNotEmpty) {
      requests.forEach((Request request) {
        item = request.toRequestItem();
        result.add(item);
      });
    }
    return result;
  }

  List<RequestItem> _sortRequestItems(List<RequestItem> items) {
    if (items.isNotEmpty) {
      items.sort((a, b) => a.number.compareTo(b.number));
    }
    return items;
  }

  List<RequestIntervalItem> _filterRequestIntervalItems(
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

  List<RequestIntervalItem> _sortRequestIntervalItems(
      List<RequestIntervalItem> items) {
    if (items.isNotEmpty) {
      items
          .sort((a, b) => a.interval.dateBegin.compareTo(b.interval.dateBegin));
    }
    return items;
  }

  void dispose() {
    appStateStream.close();
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
