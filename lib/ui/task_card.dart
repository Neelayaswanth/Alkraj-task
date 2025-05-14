import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const TaskCard({Key? key, required this.task, this.onEdit, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text('Status: ${task.status}'),
                  backgroundColor: task.status == 'completed' ? Colors.green[100] : Colors.orange[100],
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('Priority: ${task.priority}'),
                  backgroundColor: task.priority == 'high'
                      ? Colors.red[100]
                      : task.priority == 'normal'
                          ? Colors.blue[100]
                          : Colors.grey[200],
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
} 