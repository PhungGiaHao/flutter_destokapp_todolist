import 'package:flutter/material.dart';
import 'package:domain/domain/entities/todo.dart';
import 'todo_card.dart';

class StatusColumn extends StatelessWidget {
  final String status;
  final List<Todo> todos;
  final Function(Todo) onEdit;
  final Function(Todo) onDelete;
  final Function(int, int) onReorder;
  final Function(Todo, String) onStatusChange;

  const StatusColumn({
    super.key,
    required this.status,
    required this.todos,
    required this.onEdit,
    required this.onDelete,
    required this.onReorder,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final columnTodos = todos.where((t) => t.status == status).toList();
    columnTodos.sort((a, b) => a.position.compareTo(b.position));

    return Expanded(
      child: DragTarget<Todo>(
        onAccept: (todo) {
          onStatusChange(todo, status);
        },
        builder: (context, candidateData, rejectedData) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Text(
                status,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Expanded(
                child: ReorderableListView(
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    onReorder(oldIndex, newIndex);
                  },
                  children: [
                    for (int index = 0; index < columnTodos.length; index++)
                      TodoCard(
                        key: ValueKey(columnTodos[index].id),
                        todo: columnTodos[index],
                        onEdit: () => onEdit(columnTodos[index]),
                        onDelete: () => onDelete(columnTodos[index]),
                        index: index,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
