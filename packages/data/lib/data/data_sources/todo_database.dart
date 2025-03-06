import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../models/todo_model.dart';

class TodoDatabase {
  static Database? _database;

  Future<void> initDatabase() async {
    if (_database != null) return; // Already initialized

    if (kIsWeb) {
      // Use sqflite_common_ffi_web for web
      databaseFactory = databaseFactoryFfiWeb;
      _database = await openDatabase(
        'todo_database.db', // On web, this is a virtual path stored in IndexedDB
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, priority TEXT, status TEXT, position INTEGER)',
          );
        },
        version: 1,
      );
    } else {
      // Use default sqflite for native platforms
      _database = await openDatabase(
        join(await getDatabasesPath(), 'todo_database.db'),
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, priority TEXT, status TEXT, position INTEGER)',
          );
        },
        version: 1,
      );
    }
  }

  Future<void> deleteAndRenewDatabase() async {
    if (kIsWeb) {
      // On web, we need to close and reopen with a fresh database
      await _database?.close();
      databaseFactory = databaseFactoryFfiWeb;
      await deleteDatabase('todo_database.db'); // Deletes from IndexedDB
      _database = null; // Reset the reference
      await initDatabase();
    } else {
      // Native platforms
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'todo_database.db');
      await deleteDatabase(path);
      _database = null; // Reset the reference
      await initDatabase();
    }
  }

  Future<List<TodoModel>> getTodos() async {
    final List<Map<String, dynamic>> maps = await _database!.query('todos');
    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }

  Future<void> insertTodo(TodoModel todo) async {
    await _database!.insert('todos', todo.toMap());
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
