// Оценка качества по заявке
class Rating {
  Rating(
      {this.label,
      this.name,
      this.presetComments,
      this.isCommentRequired,
      this.isCanUpdate});

  String label;
  String name;
  List<String> presetComments; // список предустановленных комментариев
  bool isCommentRequired; // требуется обязательное указание комментария
  bool isCanUpdate; // возможность последующего изменения оценки
}
