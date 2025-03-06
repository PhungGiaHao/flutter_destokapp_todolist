class TodoModel {
  final int? id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final int position;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'position': position,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      priority: map['priority'],
      status: map['status'],
      position: map['position'],
    );
  }
}
