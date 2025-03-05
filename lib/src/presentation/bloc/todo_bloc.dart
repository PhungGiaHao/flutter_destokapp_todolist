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
            todos.where((t) => t.status == event.status).toList()
              ..sort((a, b) => a.position.compareTo(b.position));

        print(
          'Reordering from ${event.oldIndex} to ${event.newIndex} in status ${event.status}',
        );

        print('=== Before Reorder ===');
        for (var todo in columnTodos) {
          print(
            'ID: ${todo.id}, Position: ${todo.position}, Title: ${todo.title}',
          );
        }

        if (event.oldIndex < 0 ||
            event.oldIndex >= columnTodos.length ||
            event.newIndex < 0 ||
            event.newIndex >= columnTodos.length) {
          print(
            'Invalid indices: oldIndex=${event.oldIndex}, newIndex=${event.newIndex}',
          );
          return;
        }

        final movedTodo = columnTodos.removeAt(event.oldIndex);
        columnTodos.insert(event.newIndex, movedTodo);

        // Update positions and log each update
        for (int i = 0; i < columnTodos.length; i++) {
          columnTodos[i] = columnTodos[i].copyWith(position: i);
          print('Updating Todo ID: ${columnTodos[i].id}, New Position: $i');
          await repository.updateTodo(columnTodos[i]);
        }

        print('=== After Reorder ===');
        for (var todo in columnTodos) {
          print(
            'ID: ${todo.id}, Position: ${todo.position}, Title: ${todo.title}',
          );
        }

        // Map updated positions back to all todos
        final updatedTodos =
            todos.map((todo) {
              final found = columnTodos.firstWhere(
                (t) => t.id == todo.id,
                orElse: () => todo,
              );
              return found;
            }).toList();

        emit(TodoLoaded(todos: updatedTodos));

        print('=== State after emitting ===');
        for (var todo in updatedTodos) {
          print(
            'ID: ${todo.id}, Position: ${todo.position}, Title: ${todo.title}',
          );
        }
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
