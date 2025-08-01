class TaskInput {
  String title;
  String description;
  String recurrenceType;
  dynamic recurrenceData;
  bool requiredPhoto;

  TaskInput({
    required this.title,
    required this.description,
    required this.recurrenceType,
    this.recurrenceData,
    this.requiredPhoto = false,
  });
}
