import 'dart:async';

import 'package:computer/computer.dart';
import 'package:computer/src/errors.dart';
import 'package:test/test.dart';

void main() {
  test('Computer turn on', () async {
    final computer = Computer();
    await computer.turnOn();
    expect(computer.isRunning, equals(true));
    await computer.turnOff();
  });

  test('Computer initially turned off', () async {
    final computer = Computer();
    expect(computer.isRunning, equals(false));
  });

  test('Computer turn off', () async {
    final computer = Computer();
    await computer.turnOn();
    await computer.turnOff();
    expect(computer.isRunning, equals(false));
  });

  test('Computer reload', () async {
    final computer = Computer();
    await computer.turnOn();
    expect(computer.isRunning, equals(true));
    await computer.turnOff();
    expect(computer.isRunning, equals(false));
    await computer.turnOn();
    expect(computer.isRunning, equals(true));
    expect(await computer.start(fib, 20), equals(fib(20)));
    await computer.turnOff();
  });

  test('Execute function with param', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(await computer.start(fib, 20), equals(fib(20)));

    await computer.turnOff();
  });

  test('Stress test', () async {
    final computer = Computer();
    await computer.turnOn();

    const numOfTasks = 500;

    final result = await Future.wait(
      List.generate(
        numOfTasks,
        (_) async => await computer.start(fib, 30),
      ),
    );

    final forComparison = List.generate(
      numOfTasks,
      (_) => 832040,
    );

    expect(result, forComparison);

    await computer.turnOff();
  });

  test('Execute function without params', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(await computer.startNoParam(fib20), equals(fib20()));

    await computer.turnOff();
  });

  test('Execute static method', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(
      await computer.start(Fibonacci.fib, 20),
      equals(Fibonacci.fib(20)),
    );

    await computer.turnOff();
  });

  test('Execute async method', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(
      await computer.start(fibAsync, 20),
      equals(await fibAsync(20)),
    );

    await computer.turnOff();
  });

  test('Add computes before workers have been created', () async {
    final computer = Computer();
    expect(Future.value(computer.start(fib, 20)), completion(equals(fib20())));
    await computer.turnOn();

    addTearDown(() async => await computer.turnOff());
  });

  test('Error method', () async {
    final computer = Computer();
    await computer.turnOn();

    try {
      await computer.start(errorFib, 20);
    } catch (e) {
      expect(e, isA<RemoteExecutionError>());
      expect(e, isA<ComputerError>());
    }

    await computer.turnOff();
  });

  test('Cancel running worker', () async {
    final computer = Computer();
    await computer.turnOn();

    Future<void>.delayed(Duration.zero, () async {
      try {
        await computer.start(errorFib, 20);
      } catch (e) {
        expect(e, isA<CancelExecutionError>());
        expect(e, isA<ComputerError>());
      }
    });

    await computer.turnOff();
  });

  test('Computer instance is a singleton', () async {
    final computer1 = Computer.shared;
    final computer2 = Computer.shared;

    expect(identical(computer1, computer2), true);
  });

  test('Computer create create new instances', () async {
    final computer1 = Computer();
    final computer2 = Computer();

    expect(identical(computer1, computer2), false);
  });
}

int fib(int n) {
  if (n < 2) {
    return n;
  }
  return fib(n - 2) + fib(n - 1);
}

int errorFib(int n) {
  throw Exception('Something went wrong');
}

Future<int> fibAsync(int n) async {
  await Future<void>.delayed(const Duration(milliseconds: 100));

  return fib(n);
}

int fib20() {
  return fib(20);
}

abstract class Fibonacci {
  static int fib(int n) {
    if (n < 2) {
      return n;
    }
    return fib(n - 2) + fib(n - 1);
  }
}
