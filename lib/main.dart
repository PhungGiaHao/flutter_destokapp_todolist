// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/src/config/theme.dart';
import 'package:todolist/src/data/data_sources/todo_database.dart';
import 'package:todolist/src/data/repositories_impl/todo_repository_impl.dart';
import 'package:todolist/src/presentation/bloc/todo_bloc.dart';
import 'package:todolist/src/presentation/bloc/todo_event.dart';
import 'package:todolist/src/presentation/pages/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = TodoDatabase();
  // await database.deleteAndRenewDatabase();
  await database.initDatabase();
  runApp(MyApp(todoRepository: TodoRepositoryImpl(database)));
}

class MyApp extends StatelessWidget {
  final TodoRepositoryImpl todoRepository;

  const MyApp({super.key, required this.todoRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(todoRepository)..add(LoadTodos()),
      child: MaterialApp(
        title: 'Todo List',
        theme: appTheme,
        home: TodoPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
