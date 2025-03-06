// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter/material.dart';
import 'package:domain/domain/entities/todo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:core/core/utils/priority_helper.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;
  const TodoCard({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
    required this.index,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa công việc này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (todo.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                todo.description,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getPriorityColor(todo.priority),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      todo.priority,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(todo.status, style: const TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.pen, size: 16),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.trash,
                      size: 16,
                      color: Colors.red,
                    ),
                    onPressed: () => _confirmDelete(context),
                  ),
                  ReorderableDragStartListener(
                    index: index,
                    child: const Icon(
                      FontAwesomeIcons.arrowsUpDownLeftRight,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Todo>(
      data: todo,
      maxSimultaneousDrags: 1,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.75,
          // Provide a fixed width for feedback
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: _buildCard(context),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.5, child: _buildCard(context)),
      child: _buildCard(context),
    );
  }
}
