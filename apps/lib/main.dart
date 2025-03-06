// main.dart
import 'package:flutter/material.dart';
import 'package:data/data/data_sources/todo_database.dart';
import 'package:data/data/repositories_impl/todo_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/presentation/bloc/todo_bloc.dart';
import 'package:presentation/presentation/bloc/todo_event.dart';
import 'package:presentation/presentation/pages/todo_page.dart';
import 'package:config/theme.dart';

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
        home: const TodoPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
