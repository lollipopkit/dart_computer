import 'dart:isolate';

class Task<T> {
  final Function task;
  final T? param;
  final String? name;

  final Capability capability;

  Task({required this.task, required this.capability, this.param, this.name});
}

class TaskResult<T> {
  final T? result;
  final Capability capability;
  final String? name;

  TaskResult({required this.result, required this.capability, this.name});
}
