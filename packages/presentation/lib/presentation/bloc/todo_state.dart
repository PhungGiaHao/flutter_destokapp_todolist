import 'package:domain/domain/entities/todo.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded({required this.todos});
}

class TodoError extends TodoState {
  final String message;

  TodoError({required this.message});
}
