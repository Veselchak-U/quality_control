import 'package:flutter_test/flutter_test.dart';
import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/user.dart';

void main() {
  test('Event() constructor', () {
    var user = User(
        id: '12',
        userRole: UserRole.DELEGAT,
        lastName: 'Сидоров',
        firstName: 'Сидор',
        middleName: 'Сидорович',
        phone: '+799911110002');
    var newEvent = Event(
//        parentId: isUpdateMode ? event.id : null,
      systemDate: DateTime.now(),
      userDate: DateTime.now(),
      user: user,
      dateRequest: DateTime.now(),
//        workInterval: selectedInterval,
      eventType: EventType.SET_STATUS,
//        statusLabel: selectedStatus.label,
//        comment: inputtedComments
    );
    print(newEvent.id);
    expect(newEvent.id, '1000');
  });
}
