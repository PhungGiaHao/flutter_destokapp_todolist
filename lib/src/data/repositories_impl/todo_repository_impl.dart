import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../data_sources/todo_database.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDatabase database;

  TodoRepositoryImpl(this.database);

  @override
  Future<List<Todo>> getTodos() async {
    final todos = await database.getTodos();
    return todos.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await database.insertTodo(todo.toModel());
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await database.updateTodo(todo.toModel());
  }

  @override
  Future<void> deleteTodo(int id) async {
    await database.deleteTodo(id);
  }
}

extension TodoModelMapper on TodoModel {
  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status,
      position: position,
    );
  }
}

extension TodoEntityMapper on Todo {
  TodoModel toModel() {
    return TodoModel(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status,
      position: position,
    );
  }
}
