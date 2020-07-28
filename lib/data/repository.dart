import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:quality_control/data/i_data_source.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/user.dart';
import 'package:quality_control/service/stream_service.dart';

class Repository {
  Repository(
      {@required IDataSource dataSource, @required StreamService streamService})
      : _dataSource = dataSource,
        _streamService = streamService {
    _log.i('create');
  }

  final IDataSource _dataSource;
  final StreamService _streamService;
  final FimberLog _log = FimberLog('Repository');
  User _currentUser;
  List<Status> statusReferences; // справочник статусов
  List<Rating> ratingReferences; // справочник оценок
  List<Request> _requests; // текущие заявки

  Future<bool> initialize({@required User user}) async {
    _log.d('initialize() start');

    await _dataSource.initialize();
    _currentUser = user;
    statusReferences = await _dataSource.getStatusReferences(user: _currentUser);
    ratingReferences = await _dataSource.getRatingReferences(user: _currentUser);
    _requests = await _dataSource.loadRequests(user: _currentUser);
    _streamService.listRequests.add(_requests);
    _log.d('listRequests.add ${_requests.length} items');

    _log.d('initialize() end');
    return true;
  }
}

