import 'package:fimber/fimber.dart';
import 'package:quality_control/entity/user.dart';

class CurrentUserService {
  CurrentUserService() {
    _log.i('create');
  }

  User _currentUser;
  final FimberLog _log = FimberLog('CurrentUserService');

  Future<bool> initialize() async {
    _log.d('initialize() start');

    _currentUser = await _loadUserFromSPrefs();
    // TODO(dyv): пока заглушка на сохранённого пользователя
    _currentUser ??= User(
        id: '1',
        userRole: UserRole.DRIVER,
        lastName: 'Водитель',
        firstName: 'Иван',
        middleName: 'Иванович',
        phone: '+790500001234');

    _log.d('initialize() end');
    return true;
  }

  User getCurrentUser() => _currentUser;

  Future<User> _loadUserFromSPrefs() async {
    // TODO(dyv): пока заглушка на сохранённого пользователя
    return null;
  }
}
