import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../models/task.dart';
import 'task_form_screen.dart';
import 'task_card.dart';
import '../main.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _searchQuery = '';
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTask(id));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(themeNotifier.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            _showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final filteredTasks = state.tasks.where((task) {
              final query = _searchQuery.toLowerCase();
              return task.title.toLowerCase().contains(query) ||
                  task.description.toLowerCase().contains(query);
            }).toList();
            if (filteredTasks.isEmpty) {
              return const Center(child: Text('No tasks found.'));
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                return ListView.separated(
                  itemCount: filteredTasks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return TaskCard(
                      task: task,
                      onEdit: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskFormScreen(task: task),
                          ),
                        );
                        if (updated == true) {
                          context.read<TaskBloc>().add(LoadTasks());
                          _showSnackBar(context, 'Task updated');
                        }
                      },
                      onDelete: () => _showDeleteDialog(context, task.id!),
                    );
                  },
                );
              },
            );
          } else if (state is TaskEmpty) {
            return const Center(child: Text('No tasks found.'));
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
          if (added == true) {
            context.read<TaskBloc>().add(LoadTasks());
            _showSnackBar(context, 'Task added');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 