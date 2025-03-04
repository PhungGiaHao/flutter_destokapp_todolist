import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo_model.dart';

class TodoDatabase {
  static Database? _database;

  Future<void> initDatabase() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, priority TEXT, status TEXT, position INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> deleteAndRenewDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo_database.db');
    // Delete the existing database file
    await deleteDatabase(path);
    _database = null; // reset the reference
    // Reinitialize the database
    await initDatabase();
  }

  Future<List<TodoModel>> getTodos() async {
    final List<Map<String, dynamic>> maps = await _database!.query('todos');
    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }

  Future<void> insertTodo(TodoModel todo) async {
    // Insert the TodoModel into the correct table and postion it based on the status +1
    final todos = await getTodos();
    final newPosition = todos.where((t) => t.status == todo.status).length;
    await _database!.insert('todos', todo.toMap()..['position'] = newPosition);
  }

  Future<void> updateTodo(TodoModel todo) async {
    await _database!.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    await _database!.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
