import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos: todos));
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    });

    on<AddTodo>((event, emit) async {
      if (state is TodoLoaded) {
        final currentTodos = (state as TodoLoaded).todos;
        final newTodo = Todo(
          title: event.title,
          description: event.description,
          priority: event.priority,
          status: event.status,
          position: currentTodos.where((t) => t.status == event.status).length,
        );
        await repository.addTodo(newTodo);
        add(LoadTodos());
      }
    });

    on<UpdateTodoEvent>((event, emit) async {
      await repository.updateTodo(
        Todo(
          id: event.id,
          title: event.title,
          description: event.description,
          priority: event.priority,
          status: event.status,
          position: event.position,
        ),
      );
      add(LoadTodos());
    });

    on<DeleteTodo>((event, emit) async {
      await repository.deleteTodo(event.id);
      add(LoadTodos());
    });

    on<ReorderTodo>((event, emit) async {
      if (state is TodoLoaded) {
        final todos = (state as TodoLoaded).todos;
        final columnTodos =
            todos.where((t) => t.status == event.status).toList();

        // Ensure the oldIndex and newIndex are within bounds
        if (event.oldIndex < 0 ||
            event.oldIndex >= columnTodos.length ||
            event.newIndex < 0 ||
            event.newIndex >= columnTodos.length) {
          return;
        }

        final movedTodo = columnTodos.removeAt(event.oldIndex);
        columnTodos.insert(event.newIndex, movedTodo);

        // Update positions
        for (int i = 0; i < columnTodos.length; i++) {
          columnTodos[i] = columnTodos[i].copyWith(position: i);
          await repository.updateTodo(columnTodos[i]);
        }

        // Update the main todos list with the new positions
        final updatedTodos =
            todos.map((todo) {
              final index = columnTodos.indexWhere((t) => t.id == todo.id);
              return index != -1 ? columnTodos[index] : todo;
            }).toList();

        emit(TodoLoaded(todos: updatedTodos));
      }
    });
  }
}

extension TodoCopyWith on Todo {
  Todo copyWith({
    int? id,
    String? title,
    String? description,
    String? priority,
    String? status,
    int? position,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      position: position ?? this.position,
    );
  }
}
