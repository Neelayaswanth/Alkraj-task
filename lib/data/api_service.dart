import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import 'dart:async';
import 'bloc/task_event.dart';

class ApiService {
  static const String baseUrl = 'https://api.example.com'; // Replace with your API endpoint

  Future<T> _retry<T>(Future<T> Function() fn, {int retries = 3, Duration delay = const Duration(seconds: 1)}) async {
    int attempt = 0;
    while (true) {
      try {
        return await fn();
      } catch (e) {
        if (attempt >= retries) rethrow;
        await Future.delayed(delay * (attempt + 1));
        attempt++;
      }
    }
  }

  Future<List<Task>> getTasks() async {
    return _retry(() async {
      final response = await http.get(Uri.parse('$baseUrl/tasks'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    });
  }

  Future<Task> createTask(Task task) async {
    return _retry(() async {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create task');
      }
    });
  }

  Future<Task> updateTask(Task task) async {
    return _retry(() async {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update task');
      }
    });
  }

  Future<void> deleteTask(int id) async {
    return _retry(() async {
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks/$id'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    });
  }
} 