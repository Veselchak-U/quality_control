// Пользователь
class User {
  User(
      {this.id,
      this.userRole,
      this.lastName,
      this.firstName,
      this.middleName,
      this.phone});

  String id;
  UserRole userRole;
  String lastName; // фамилия
  String firstName; // имя
  String middleName; // отчество
  String phone;
}

// Роль пользователя: водитель, представитель заказчика, ответственное лицо по регламентной заявке
enum UserRole { DRIVER, DELEGAT, OTHER }
