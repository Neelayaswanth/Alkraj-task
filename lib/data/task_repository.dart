import '../models/task.dart';
import 'database_helper.dart';

class TaskRepository {
  final DatabaseHelper _databaseHelper;

  TaskRepository({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  Future<List<Task>> getTasks() async {
    return await _databaseHelper.getAllTasks();
  }

  Future<Task> createTask(Task task) async {
    final id = await _databaseHelper.createTask(task);
    return task.copyWith(id: id);
  }

  Future<Task> updateTask(Task task) async {
    await _databaseHelper.updateTask(task);
    return task;
  }

  Future<void> deleteTask(int id) async {
    await _databaseHelper.deleteTask(id);
  }

  Future<void> syncPendingTasks() async {
    // No-op for local-only version
    return;
  }
} 