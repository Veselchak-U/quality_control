// Пользователь
class User {
  User(
      {this.id,
      this.userRole,
      this.lastName,
      this.firstName,
      this.middleName,
      this.phone}) {
    // replace null and delete double inner spaces + outer spaces
    lastName =
        lastName == null ? '' : lastName.replaceAll(RegExp(r'\s+'), ' ').trim();
    firstName = firstName == null
        ? ''
        : firstName.replaceAll(RegExp(r'\s+'), ' ').trim();
    middleName = middleName == null
        ? ''
        : middleName.replaceAll(RegExp(r'\s+'), ' ').trim();
    phone = phone == null
        ? ''
        : phone.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String id;
  UserRole userRole;
  String lastName; // фамилия
  String firstName; // имя
  String middleName; // отчество
  String phone;

  String toFullFIO() {
    // delete double inner spaces + outer spaces
    return '$lastName $firstName $middleName'
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String toShortFIO() {
    String result;
    if (lastName.isEmpty) {
      result = toFullFIO();
    } else {
      var i = firstName.isEmpty ? '' : '${firstName.substring(0, 1)}.';
      var o = middleName.isEmpty ? '' : '${middleName.substring(0, 1)}.';
      result = '$lastName $i$o';
    }
    return result;
  }

  String getUserRoleName() {
    String result;
    if (userRole == UserRole.DRIVER) {
      result = 'Водитель';
    } else if (userRole == UserRole.DELEGAT) {
      result = 'Представитель';
    } else if (userRole == UserRole.OTHER) {
      result = 'Ответственный';
    }
    return result;
  }
}

// Роль пользователя: водитель, представитель заказчика, ответственное лицо по регламентной заявке
enum UserRole { DRIVER, DELEGAT, OTHER }
