// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      priority: json['priority'] as String,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
      category: json['category'] as String? ?? '',
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'priority': instance.priority,
      'syncStatus': instance.syncStatus,
      'category': instance.category,
    };
