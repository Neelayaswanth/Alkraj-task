import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'task.g.dart';

@JsonSerializable()
class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final String priority;
  final String syncStatus;
  final String category;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.priority,
    this.syncStatus = 'synced',
    this.category = '',
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
    String? priority,
    String? syncStatus,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      syncStatus: syncStatus ?? this.syncStatus,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id, title, description, status, createdAt, priority, syncStatus, category];
} 