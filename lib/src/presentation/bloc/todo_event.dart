import 'package:todolist/src/domain/entities/todo.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  final String description;
  final String priority;
  final String status;

  AddTodo({
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
  });
}

class UpdateTodoEvent extends TodoEvent {
  final int id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final int position;

  UpdateTodoEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.position,
  });
}

class DeleteTodo extends TodoEvent {
  final int id;
  DeleteTodo({required this.id});
}

class ReorderTodo extends TodoEvent {
  final int oldIndex;
  final int newIndex;
  final String status;

  ReorderTodo({
    required this.oldIndex,
    required this.newIndex,
    required this.status,
  });
}

class DeleteTodoEvent extends TodoEvent {
  final Todo todo;
  DeleteTodoEvent(this.todo);
}

class UpdateAllTodosEvent extends TodoEvent {
  final List<Todo> todos;
  UpdateAllTodosEvent(this.todos);
}
