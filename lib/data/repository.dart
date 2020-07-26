import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:quality_control/data/base_data_source.dart';
import 'package:quality_control/service/stream_service.dart';

class Repository {
  Repository(
      {@required BaseDataSource dataSource,
      @required StreamService streamService})
      : _dataSource = dataSource,
        _streamService = streamService {
    _log.i('create');
  }

  final BaseDataSource _dataSource;
  final StreamService _streamService;
  final FimberLog _log = FimberLog('Repository');
}
