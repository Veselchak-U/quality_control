
import 'package:flutter/foundation.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/user.dart';

abstract class BaseDataSource {
  bool isInitialized;

  Future<bool> initialize();

  Future<List<Request>> loadRequests({@required User user});
}