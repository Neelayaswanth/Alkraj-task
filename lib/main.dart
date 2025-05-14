import 'dart:async';
import 'bloc/task_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';
import 'data/task_repository.dart';
import 'ui/task_list_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({Key? key}) : super(key: key);

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  late final TaskRepository _repository;
  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;
  late final StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _repository = TaskRepository();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _subscription = _connectivityStream.listen((result) {
      if (result != ConnectivityResult.none) {
        _repository.syncPendingTasks();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return RepositoryProvider.value(
          value: _repository,
          child: BlocProvider(
            create: (context) => TaskBloc(_repository)..add(LoadTasks()),
            child: MaterialApp(
              title: 'Task Manager',
              theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
              darkTheme: ThemeData(brightness: Brightness.dark, colorScheme: ColorScheme.dark(primary: Colors.blue)),
              themeMode: mode,
              home: const TaskListScreen(),
            ),
          ),
        );
      },
    );
  }
} 