import 'dart:math';

import 'package:quality_control/entity/event.dart';
import 'package:quality_control/entity/work_interval.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/user.dart';
import 'package:quality_control/extension/datetime_extension.dart';

class ReferenceBooks {
  static final List<Status> statusReference = [
    Status(label: 'ARRIVE', name: 'Прибыл'),
    Status(label: 'START', name: 'Начало работы'),
    Status(label: 'WAIT', name: 'Ожидание'),
    Status(label: 'DONE', name: 'Выполнено'),
    Status(label: 'PART_DONE', name: 'Выполнено частично'),
    Status(label: 'NOT_DONE', name: 'Не выполнено')
  ];

  static final List<Rating> ratingReference = [
    Rating(
        label: '1',
        name: 'Очень плохо',
        presetComments: [
          'Не заказан пропуск на объект',
          'Не подготовлена площадка',
          'Опоздание заказчика более 2-ух часов'
        ],
        isCommentRequired: true,
        isCanChange: true),
    Rating(
        label: '2',
        name: 'Плохо',
        presetComments: [
          'Не заказан пропуск на объект',
          'Опоздание заказчика более часа'
        ],
        isCommentRequired: true,
        isCanChange: true),
    Rating(
        label: '3',
        name: 'Удовлетворительно',
        presetComments: [
          'Не заказан пропуск на объект',
          'Опоздание заказчика менее получаса'
        ],
        isCommentRequired: true,
        isCanChange: false),
    Rating(
        label: '4',
        name: 'Хорошо',
        presetComments: [],
        isCommentRequired: false,
        isCanChange: true),
    Rating(
        label: '5',
        name: 'Очень хорошо',
        presetComments: [
          'Аккуратно',
          'Быстро',
          'Вовремя',
          'Всё вышеперечисленное'
        ],
        isCommentRequired: false,
        isCanChange: true)
  ];

  static List<Request> getRequests() {
    var now = DateTime.now().trunc();
    var idCounter = 1;

    var dateFrom = now.subtract(Duration(days: 12));
    var dateTo = now.add(Duration(days: 1));
    var daysInPeriod = dateTo.difference(dateFrom).inDays + 1;
    var currentDay = dateFrom.day;
    var request1 = Request(
      id: '90189',
      number: 8853,
      dateFrom: dateFrom,
      dateTo: dateTo,
      intervals: List<WorkInterval>.generate(daysInPeriod * 4, (int i) {
        i++;
        WorkInterval result;
        if (i % 4 == 1) {
          result = WorkInterval(
              id: '${idCounter++}',
              dateBegin:
                  DateTime(dateFrom.year, dateFrom.month, currentDay, 7, 25),
              dateEnd:
                  DateTime(dateFrom.year, dateFrom.month, currentDay, 8, 00));
        } else if (i % 4 == 2) {
          result = WorkInterval(
              id: '${idCounter++}',
              dateBegin:
                  DateTime(dateFrom.year, dateFrom.month, currentDay, 12, 30),
              dateEnd:
                  DateTime(dateFrom.year, dateFrom.month, currentDay, 12, 40));
        } else if (i % 4 == 3) {
          result = WorkInterval(
              id: '${idCounter++}',
              dateBegin:
                  DateTime(dateFrom.year, dateFrom.month, currentDay, 12, 45),
              dateEnd:
                  DateTime(dateFrom.year, dateFrom.month, currentDay, 13, 15));
        } else if (i % 4 == 0) {
          result = WorkInterval(
              id: '${idCounter++}',
              dateBegin:
                  DateTime(dateFrom.year, dateFrom.month, currentDay, 13, 50),
              dateEnd:
                  DateTime(dateFrom.year, dateFrom.month, currentDay, 14, 10));
          currentDay++;
        }
        return result;
      }),
      routeFrom: 'Склад Зарница',
      routeTo: 'ЦХХ (ДАМБА №4)',
      routeDescription: 'Работа по графику.',
      customer: 'АК "АЛРОСА" (ПАО) УМНУ СТ"Алмазавтоматика"',
      customerDelegat: User(
          id: '11',
          userRole: UserRole.DELEGAT,
          lastName: 'Петров',
          firstName: 'Петр',
          middleName: 'Петрович',
          phone: '+79991111001'),
      comment: 'Изменения в плане согласованы согласно СЗ',
      note:
          '1-я половина 29984\nРежим согласован с ЦУТ\n\n№ С302-670-31-01-670-31/1636 от 20.02.2019\n\nкорректирование режима согласно С302-670-31-01-670-31/3908 от 18.04',
      events: [
        Event(
            systemDate: DateTime.now().subtract(Duration(days: 1)),
            userDate: DateTime.now()
                .subtract(Duration(days: 1, minutes: Random().nextInt(30))),
            user: User(
                id: '11',
                userRole: UserRole.DELEGAT,
                lastName: 'Петров',
                firstName: 'Петр',
                middleName: 'Петрович',
                phone: '+79991111001'),
            dateRequest: DateTime.now(),
            intervalRequest: WorkInterval(
                id: '333', dateBegin: DateTime.now(), dateEnd: DateTime.now()),
            eventType: EventType.SET_STATUS,
            statusLabel: 'START',
            comment: 'Коммент к статусу'),
        Event(
            systemDate: DateTime.now().subtract(Duration(days: 1)),
            userDate: DateTime.now()
                .subtract(Duration(days: 1, minutes: Random().nextInt(30))),
            user: User(
                id: '11',
                userRole: UserRole.DELEGAT,
                lastName: 'Петров',
                firstName: 'Петр',
                middleName: 'Петрович',
                phone: '+79991111001'),
            dateRequest: DateTime.now(),
            intervalRequest: WorkInterval(
                id: '333', dateBegin: DateTime.now(), dateEnd: DateTime.now()),
            eventType: EventType.SET_RATING,
            ratingLabel: '5',
            ratingComment: 'Аккуратно',
            comment: 'Коммент к оценке'),
      ],
    );

    dateFrom = DateTime(now.year, now.month, 1);
    dateTo = DateTime(now.year, now.month + 1, 0);
    daysInPeriod = dateTo.difference(dateFrom).inDays + 1;
    currentDay = dateFrom.day;
    var request2 = Request(
      id: '92088',
      number: 10019,
      dateFrom: dateFrom,
      dateTo: dateTo,
      intervals: List<WorkInterval>.generate(daysInPeriod * 2, (int i) {
        i++;
        WorkInterval result;
        if (i % 2 == 1) {
          result = WorkInterval(
              id: '${idCounter++}',
              dateBegin: DateTime(now.year, now.month, currentDay, 15, 00),
              dateEnd: DateTime(now.year, now.month, currentDay, 16, 00));
        } else if (i % 2 == 0) {
          result = WorkInterval(
              id: '${idCounter++}',
              dateBegin: DateTime(now.year, now.month, currentDay, 16, 30),
              dateEnd: DateTime(now.year, now.month, currentDay, 17, 00));
          currentDay++;
        }
        return result;
      }),
      routeFrom: 'Удачный АУО УМТС',
      routeTo: 'Подземный Рудник "Удачный"',
      routeDescription: 'По 325 отчету',
      customer: 'АК "АЛРОСА" (ПАО) УГОК АТТ-3',
      customerDelegat: User(
          id: '12',
          userRole: UserRole.DELEGAT,
          lastName: 'Сидоров',
          firstName: 'Сидор',
          middleName: 'Сидорович',
          phone: '+799911110002'),
      comment: '633',
      note:
          'Доставка персонала АУО УМТС: на работу, обед, с работы: Н-город - УМТС(тех.база, нефтебаза, АЗС-1, АЗС-2)',
      events: [
        Event(
            systemDate: DateTime.now().subtract(Duration(days: 1)),
            userDate: DateTime.now()
                .subtract(Duration(days: 1, minutes: Random().nextInt(30))),
            user: User(
                id: '11',
                userRole: UserRole.DELEGAT,
                lastName: 'Петров',
                firstName: 'Петр',
                middleName: 'Петрович',
                phone: '+79991111001'),
            dateRequest: DateTime.now(),
            intervalRequest: WorkInterval(
                id: '333', dateBegin: DateTime.now(), dateEnd: DateTime.now()),
            eventType: EventType.SET_STATUS,
            statusLabel: 'START',
            comment: 'Коммент к статусу'),
        Event(
            systemDate: DateTime.now().subtract(Duration(days: 1)),
            userDate: DateTime.now()
                .subtract(Duration(days: 1, minutes: Random().nextInt(30))),
            user: User(
                id: '12',
                userRole: UserRole.DELEGAT,
                lastName: 'Сидоров',
                firstName: 'Сидор',
                middleName: 'Сидорович',
                phone: '+799911110002'),
            dateRequest: DateTime.now(),
            intervalRequest: WorkInterval(
                id: '333', dateBegin: DateTime.now(), dateEnd: DateTime.now()),
            eventType: EventType.SET_RATING,
            ratingLabel: '5',
            ratingComment: 'Аккуратно',
            comment: 'Коммент к оценке'),
      ],
    );

    return [request1, request2];
  }
}
