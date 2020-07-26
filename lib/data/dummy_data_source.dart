import 'package:quality_control/data/base_data_source.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/user.dart';

class DummyDataSource implements BaseDataSource {
  @override
  bool isInitialized;

  @override
  Future<bool> initialize() {
    return Future<bool>.delayed(Duration(seconds: 2), () => true);
  }

  @override
  Future<List<Request>> loadRequests({User user}) {
    return Future<List<Request>>.delayed(
        Duration(milliseconds: 500), () => <Request>[]);
  }
}
