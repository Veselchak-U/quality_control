import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:quality_control/data/i_data_source.dart';
import 'package:quality_control/data/reference_books.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/user.dart';
import 'package:quality_control/service/stream_service.dart';

class DummyDataSource implements IDataSource {
  DummyDataSource({@required StreamService streamService})
      : _streamService = streamService {
    _log.i('create');
  }

  final StreamService _streamService;
  final FimberLog _log = FimberLog('DummyDataSource');

  @override
  Future<bool> initialize() {
    return Future<bool>.delayed(Duration(seconds: 1), () => true);
  }

  @override
  Future<List<Request>> loadRequests({User user}) {
    return Future<List<Request>>.delayed(
        Duration(milliseconds: 500), () => ReferenceBooks.getRequests());
  }

  @override
  Future<List<Rating>> getRatingReferences({@required User user}) async {
    return Future<List<Rating>>.delayed(
        Duration(milliseconds: 500), () => ReferenceBooks.ratingReference);
  }

  @override
  Future<List<Status>> getStatusReferences({@required User user}) async {
    return Future<List<Status>>.delayed(
        Duration(milliseconds: 500), () => ReferenceBooks.statusReference);
  }
}
