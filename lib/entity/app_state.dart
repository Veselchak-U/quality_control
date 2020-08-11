import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/user.dart';

class AppState {
  AppState(
      {this.requestFilterByDate,
      this.requestFilterByText,
      this.eventFilterByChain,
      this.user,
      this.requestId,
      this.intervalId,
      this.event,
      this.listPresentation,
      this.bottomNavigationBarIndex,
      this.statusReferences,
      this.ratingReferences,
      this.requests});

  RequestFilterByDate requestFilterByDate; // фильтр заявок по дате
  String requestFilterByText; // фильтр заявок по тексту
  String eventFilterByChain; // фильтр событий по цепочке
  User user; // текущий пользователь
  String requestId; // текущая заявка
  String intervalId; // текущий интервал
  Event event; // корректируемое событие из заявки
  ListPresentation listPresentation; // текущий режим показа списка
  int bottomNavigationBarIndex; // текущая вкладка внизу
  List<Status> statusReferences; // справочник статусов (для сохранения)
  List<Rating> ratingReferences; // справочник оценок (для сохранения)
  List<Request> requests; // текущие заявки (для сохранения)
}

enum RequestFilterByDate { BEFORE, TODAY, AFTER }

enum ListPresentation { INTERVAL, REQUEST }
