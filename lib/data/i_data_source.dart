import 'package:flutter/foundation.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/user.dart';

abstract class IDataSource {
  Future<bool> initialize();

  Future<List<Request>> loadRequests({@required User user});

  Future<List<Status>> getStatusReferences({@required User user});

  Future<List<Rating>> getRatingReferences({@required User user});

  Future<bool> addEvent(
      {@required String requestId, @required Event event, Event parentEvent});
}
