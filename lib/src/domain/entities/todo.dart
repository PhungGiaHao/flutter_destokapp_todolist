class Todo {
  final int? id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final int position;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.position,
  });
}
