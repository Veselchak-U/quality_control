import 'package:quality_control/entity/rating.dart';
import 'package:quality_control/entity/status.dart';

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
}
