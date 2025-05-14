import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        priority TEXT NOT NULL,
        syncStatus TEXT NOT NULL DEFAULT 'synced',
        category TEXT NOT NULL DEFAULT ''
      )
    ''');
    await db.execute('CREATE INDEX idx_createdAt ON tasks(createdAt);');
    await db.execute('CREATE INDEX idx_priority ON tasks(priority);');
    await db.execute('CREATE INDEX idx_syncStatus ON tasks(syncStatus);');
    await db.execute('CREATE INDEX idx_category ON tasks(category);');
  }

  Future<int> createTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toJson());
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) => Task.fromJson(maps[i]));
  }

  Future<Task?> getTask(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    }
    return null;
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<List<Task>> getUnsyncedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'syncStatus != ?',
      whereArgs: ['synced'],
    );
    return List.generate(maps.length, (i) => Task.fromJson(maps[i]));
  }
} 