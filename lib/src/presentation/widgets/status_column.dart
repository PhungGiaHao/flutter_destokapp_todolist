import 'package:flutter/material.dart';
import '../../domain/entities/todo.dart';
import 'todo_card.dart';

class StatusColumn extends StatelessWidget {
  final String status;
  final List<Todo> todos;
  final Function(Todo) onEdit;
  final Function(Todo) onDelete;
  final Function(int oldIndex, int newIndex) onReorder;
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
    // Filter todos belonging to this column and sort by their position.
    final columnTodos = todos.where((t) => t.status == status).toList();
    columnTodos.sort((a, b) => a.position.compareTo(b.position));

    return Expanded(
      child: DragTarget<Todo>(
        // Outer DragTarget for cross-column drag: if a todo is dropped here and its
        // status is different, update its status.
        onAccept: (draggedTodo) {
          if (draggedTodo.status != status) {
            onStatusChange(draggedTodo, status);
          }
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
                // Using Flutter's built-in ReorderableListView
                child: ReorderableListView(
                  proxyDecorator: (
                    Widget child,
                    int index,
                    Animation<double> animation,
                  ) {
                    return Material(color: Colors.transparent, child: child);
                  },
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) {
                    // Pass the new ordering to the callback
                    onReorder(oldIndex, newIndex);
                  },
                  // Provide a unique key for each item.
                  children: [
                    for (int index = 0; index < columnTodos.length; index++)
                      Card(
                        key: ValueKey(columnTodos[index].id),
                        child: TodoCard(
                          todo: columnTodos[index],
                          onEdit: () => onEdit(columnTodos[index]),
                          onDelete: () => onDelete(columnTodos[index]),
                        ),
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
