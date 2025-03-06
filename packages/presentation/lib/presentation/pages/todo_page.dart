import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain/entities/todo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/status_column.dart';
import '../widgets/add_todo_dialog.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showAddEditDialog(BuildContext context, {Todo? todo}) {
    showDialog(
      context: context,
      builder: (context) => AddTodoDialog(
        todo: todo,
        onSubmit: (title, description, priority) {
          if (todo == null) {
            // Create a new Todo
            final todos = context.read<TodoBloc>().state is TodoLoaded
                ? (context.read<TodoBloc>().state as TodoLoaded).todos
                : [];
            final newPosition =
                todos.where((t) => t.status == 'Chưa làm').length;

            final newTodo = Todo(
              id: DateTime.now().millisecondsSinceEpoch,
              title: title,
              description: description,
              priority: priority,
              status: 'Chưa làm', // Default status
              position: newPosition, // Default position based on status
            );

            context.read<TodoBloc>().add(
                  AddTodo(
                    title: newTodo.title,
                    description: newTodo.description,
                    priority: newTodo.priority,
                    status: newTodo.status,
                  ),
                );
            _showSnackBar(context, 'Đã thêm công việc');
          } else {
            // Update existing Todo
            final updatedTodo = todo.copyWith(
              title: title,
              description: description,
              priority: priority,
            );
            context.read<TodoBloc>().add(
                  UpdateTodoEvent(
                    id: updatedTodo.id!,
                    title: updatedTodo.title,
                    description: updatedTodo.description,
                    priority: updatedTodo.priority,
                    status: updatedTodo.status,
                    position: updatedTodo.position,
                  ),
                );
            _showSnackBar(context, 'Đã cập nhật công việc');
          }
        },
      ),
    );
  }

  void _deleteTodo(BuildContext context, Todo todo) {
    context.read<TodoBloc>().add(DeleteTodo(id: todo.id!));
    _showSnackBar(context, 'Đã xóa công việc');
  }

  void _updateTodoPositions(
    BuildContext context,
    int oldIndex,
    int newIndex,
    String status,
  ) {
    print('Reordering from $oldIndex to $newIndex in status $status');
    context.read<TodoBloc>().add(
          ReorderTodo(oldIndex: oldIndex, newIndex: newIndex, status: status),
        );
    _showSnackBar(context, 'Cập nhật thứ tự thành công');
  }

  void _changeTodoStatus(BuildContext context, Todo todo, String newStatus) {
    final updatedTodo = todo.copyWith(status: newStatus);
    context.read<TodoBloc>().add(
          UpdateTodoEvent(
            id: updatedTodo.id!,
            title: updatedTodo.title,
            description: updatedTodo.description,
            priority: updatedTodo.priority,
            status: updatedTodo.status,
            position: updatedTodo.position,
          ),
        );
    _showSnackBar(context, 'Đã thay đổi trạng thái công việc');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý công việc'),
        backgroundColor: Colors.blue,
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            _showSnackBar(context, 'Lỗi: ${state.message}');
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            final todos = state.todos;
            return Row(
              children: ['Chưa làm', 'Đang làm', 'Hoàn thành'].map((status) {
                return Expanded(
                  child: StatusColumn(
                    status: status,
                    todos: todos,
                    onEdit: (todo) => _showAddEditDialog(context, todo: todo),
                    onDelete: (todo) => _deleteTodo(context, todo),
                    onReorder: (oldIndex, newIndex) => _updateTodoPositions(
                      context,
                      oldIndex,
                      newIndex,
                      status,
                    ),
                    onStatusChange: (todo, newStatus) =>
                        _changeTodoStatus(context, todo, newStatus),
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text('Không có công việc nào.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context),
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }
}
