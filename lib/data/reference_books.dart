import 'package:quality_control/entity/interval.dart';
import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/request.dart';
import 'package:quality_control/entity/status.dart';
import 'package:quality_control/entity/user.dart';

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
        isCommentRequired: true,
        isCanChange: true)
  ];

  static List<Request> getRequests() {
    var now = DateTime.now();
    var dayInMonth = DateTime(now.year, now.month + 1, 0).day;

    return [
      Request(
          id: '90189',
          number: 8853,
          dateFrom: DateTime(now.year, now.month, 1),
          dateTo: DateTime(now.year, now.month, dayInMonth),
          intervals: List<Interval>.generate(dayInMonth * 4, (int i) {
            i++;
            Interval result;
            if (i % 4 == 0) {
              result = Interval(
                  dateBegin: DateTime(now.year, now.month, i ~/ 4 + 1, 7, 25),
                  dateEnd: DateTime(now.year, now.month, i ~/ 4 + 1, 8, 00));
            } else if (i % 4 == 1) {
              result = Interval(
                  dateBegin: DateTime(now.year, now.month, i ~/ 4 + 1, 12, 30),
                  dateEnd: DateTime(now.year, now.month, i ~/ 4 + 1, 12, 40));
            } else if (i % 4 == 2) {
              result = Interval(
                  dateBegin: DateTime(now.year, now.month, i ~/ 4 + 1, 12, 45),
                  dateEnd: DateTime(now.year, now.month, i ~/ 4 + 1, 13, 15));
            } else if (i % 4 == 3) {
              result = Interval(
                  dateBegin: DateTime(now.year, now.month, i ~/ 4 + 1, 13, 50),
                  dateEnd: DateTime(now.year, now.month, i ~/ 4 + 1, 14, 10));
            }
            return result;
          }),
          routeFrom: 'УДАЧНЫЙ',
          routeTo: 'УДАЧНЫЙ',
          routeDescription: 'Работа по графику.',
          customer: 'АК "АЛРОСА" (ПАО) УМНУ СТ"Алмазавтоматика"',
          customerDelegat: User(
              id: '11',
              userRole: UserRole.DELEGAT,
              lastName: 'Представитель 1',
              firstName: 'Петр',
              middleName: 'Петрович',
              phone: '+799911110001'),
          comment: 'Изменения в плане согласованы согласно СЗ',
          note: 'прим 1'),
      Request(
          id: '92088',
          number: 10019,
          dateFrom: DateTime(now.year, now.month, 1),
          dateTo: DateTime(now.year, now.month, dayInMonth),
          intervals: List<Interval>.generate(dayInMonth * 2, (int i) {
            i++;
            Interval result;
            if (i % 2 == 0) {
              result = Interval(
                  dateBegin: DateTime(now.year, now.month, i ~/ 2 + 1, 15, 00),
                  dateEnd: DateTime(now.year, now.month, i ~/ 2 + 1, 16, 00));
            } else if (i % 2 == 1) {
              result = Interval(
                  dateBegin: DateTime(now.year, now.month, i ~/ 2 + 1, 16, 30),
                  dateEnd: DateTime(now.year, now.month, i ~/ 2 + 1, 17, 00));
            }
            return result;
          }),
          routeFrom: 'Удачный АУО УМТС',
          routeTo: 'Удачный АУО УМТС',
          routeDescription: 'По 325 отчету',
          customer: 'АК "АЛРОСА" (ПАО) УГОК АТТ-3',
          customerDelegat: User(
              id: '12',
              userRole: UserRole.DELEGAT,
              lastName: 'Представитель 2',
              firstName: 'Сидор',
              middleName: 'Сидорович',
              phone: '+799911110002'),
          comment: '633',
          note: 'Доставка персонала АУО УМТС: на работу, обед, с работы: Н-город - УМТС(тех.база, нефтебаза, АЗС-1, АЗС-2)')
    ];
  }
}
