import 'package:quality_control/entity/user.dart';

class AppState {
  AppState(
      {this.requestFilterByDate,
      this.requestFilterByText,
      this.user,
      this.requestId,
      this.intervalId,
      this.listPresentation,
      this.bottomNavigationBarIndex});

  RequestFilterByDate requestFilterByDate; // фильтр заявок по дате
  String requestFilterByText; // фильтр заявок по тексту
  User user; // текущий пользователь
  String requestId; // текущая заявка
  String intervalId; // текущий интервал
  ListPresentation listPresentation; // текущий режим показа списка
  int bottomNavigationBarIndex; // текущая вкладка внизу
}

enum RequestFilterByDate { BEFORE, TODAY, AFTER }

enum ListPresentation { INTERVAL, REQUEST }
