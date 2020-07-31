import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:quality_control/data/i_data_source.dart';
import 'package:quality_control/entity/app_state.dart';
import 'package:quality_control/entity/interval.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/user.dart';
import 'package:quality_control/service/stream_service.dart';

class Repository {
  Repository(
      {@required IDataSource dataSource,
      @required StreamService streamService,
      @required AppState appState})
      : _dataSource = dataSource,
        _streamService = streamService,
        _appState = appState {
    // входящие события о небходимости обновить данные
    streamService.refreshData.listen(_onRefreshDataEvent);
    _log.i('create');
  }

  final IDataSource _dataSource;
  final StreamService _streamService;
  final AppState _appState;
  User _currentUser;
  List<Status> statusReferences; // справочник статусов
  List<Rating> ratingReferences; // справочник оценок
  List<Request> _requests; // текущие заявки
  final FimberLog _log = FimberLog('Repository');

  Future<bool> initialize({@required User user}) async {
    _log.d('initialize() start');
    _currentUser = user;

    // Зачитываем данные из БД
    await _dataSource.initialize();
    statusReferences =
        await _dataSource.getStatusReferences(user: _currentUser);
    ratingReferences =
        await _dataSource.getRatingReferences(user: _currentUser);
    _requests = await _dataSource.loadRequests(user: _currentUser);

    // Инициализируем текущее состояние
    setAppState(
        newAppState: AppState(
            requestFilterByDate: RequestFilterByDate.TODAY,
            requestFilterByText: '',
            user: _currentUser,
            bottomNavigationBarIndex: 0));

    // Рассылаем зачитанные данные
    _streamService.listRequests.add(_requests);
    _log.d('listRequests.add ${_requests.length} items');

    _log.d('initialize() end');
    return true;
  }

  AppState get appState => _appState;

  void setAppState({@required AppState newAppState}) {
    var needRefreshData = false;

    if (newAppState.requestFilterByDate != null) {
      _appState.requestFilterByDate = newAppState.requestFilterByDate;
      needRefreshData = true;
    }
    if (newAppState.requestFilterByText != null) {
      _appState.requestFilterByText = newAppState.requestFilterByText;
      needRefreshData = true;
    }
    if (newAppState.user != null) {
      _appState.user = newAppState.user;
    }
    if (newAppState.requestId != null) {
      _appState.requestId = newAppState.requestId;
    }
    if (newAppState.intervalId != null) {
      _appState.intervalId = newAppState.intervalId;
    }
    if (newAppState.listPresentation != null) {
      _appState.listPresentation = newAppState.listPresentation;
    }
    if (newAppState.bottomNavigationBarIndex != null) {
      _appState.bottomNavigationBarIndex = newAppState.bottomNavigationBarIndex;
    }
    // refresh data
    _streamService.appState.add(_appState);
    if (needRefreshData) {
      _streamService.listRequests.add(_requests);
    }
  }

  // обработчик входящих событий о небходимости обновить данные
  void _onRefreshDataEvent(RefreshDataEvent event) {
    if (event == RefreshDataEvent.REFRESH_REQUESTS) {
      _streamService.listRequests.add(_requests);
    }
  }

  Request getRequestById({String requestId, String intervalId}) {
    assert(requestId != null || intervalId != null, 'There are no props!');
    Request result;

    if (requestId != null) {
      result = _requests.firstWhere((element) => element.id == requestId);
    } else if (intervalId != null) {
      Interval interval;
      for (var req in _requests) {
        result = req;
        interval = result.intervals?.firstWhere(
            (element) => element.id == intervalId,
            orElse: () => null);
        if (interval != null) break;
      }
    }
    return result;
  }
}
