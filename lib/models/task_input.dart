class TaskInput {
  String title;
  String description;
  String recurrenceType;
  dynamic recurrenceData;
  bool requiredPhoto;
  int? points;
  int? order;
  String? note;

  TaskInput({
    required this.title,
    required this.description,
    required this.recurrenceType,
    this.recurrenceData,
    this.requiredPhoto = false,
    this.points,
    this.order,
    this.note,
  });
}
