import '../models/task.dart';
import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}
class TaskLoading extends TaskState {}
class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);
  @override
  List<Object?> get props => [tasks];
}
class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
  @override
  List<Object?> get props => [message];
}
class TaskEmpty extends TaskState { const TaskEmpty(); } 