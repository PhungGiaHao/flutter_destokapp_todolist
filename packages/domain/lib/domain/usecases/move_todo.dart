import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class MoveTodo {
  final TodoRepository repository;

  MoveTodo(this.repository);

  Future<void> call(Todo todo) async {
    await repository.updateTodo(todo);
  }
}
