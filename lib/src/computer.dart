import 'dart:async';

import 'compute_api/compute_api.dart';

/// Class, that provides `compute` like API for concurrent calculations
class Computer {
  final _computeDelegate = ComputeAPI();

  static Computer get shared => _singleton;

  Computer();

  static final _singleton = Computer();

  /// Returns `true` if `Computer` turned on and `false` otherwise
  bool get isRunning => _computeDelegate.isRunning;

  /// Turn on `Computer`
  /// - `workersCount` should not be less than 1, default is 2
  /// - `verbose` logging of every operation
  Future<void> turnOn({
    int workersCount = 2,
    bool verbose = false,
  }) async {
    if (workersCount < 1) {
      throw ArgumentError.value(
        workersCount,
        'workersCount',
        'should be greater than 0',
      );
    }
    return _computeDelegate.turnOn(
      workersCount: workersCount,
      verbose: verbose,
    );
  }

  /// Executes function [fn] with passed [param]. 
  /// 
  /// The fn will be execute after [Computer] turned on.
  Future<R> start<P, R>(
    ComputerFunc<P, R> fn, {
    required P param,
    String taskName = '_',
  }) async {
    return _computeDelegate.compute<P, R>(fn, param: param, taskName: taskName);
  }

  /// Executes function [fn] with no params.
  /// 
  /// The fn will be execute after [Computer] turned on.
  Future<R> startNoParam<R>(
    FutureOr<R> Function() fn, {
    String taskName = '_',
  }) async {
    return _computeDelegate.computeNoParam<R>(fn, taskName: taskName);
  }

  /// Turn off `Computer`
  Future<void> turnOff() async {
    if (!isRunning) return;
    return _computeDelegate.turnOff();
  }
}
