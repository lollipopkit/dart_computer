import 'dart:async';
import 'dart:isolate';

abstract final class TaskBase {
  final Function task;
  final String? name;
  final Capability capability;

  const TaskBase({required this.task, required this.capability, this.name});
}

final class Task<P, R> extends TaskBase {
  final P? param;

  const Task({
    required FutureOr<R> Function(P) task,
    required super.capability,
    this.param,
    required super.name,
  }) : super(task: task);
}

final class TaskNoParam<R> extends TaskBase {
  const TaskNoParam({
    required FutureOr<R> Function() task,
    required super.capability,
    required super.name,
  }) : super(task: task);
}

class TaskResult<T> {
  final T? result;
  final Capability capability;
  final String? name;

  const TaskResult({required this.result, required this.capability, this.name});
}
