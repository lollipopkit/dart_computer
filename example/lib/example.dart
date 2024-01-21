import 'dart:async';

import 'package:computer/computer.dart';

Future<void> main() async {
  final computer = Computer.shared;

  await computer.turnOn(
    workersCount: 2,
    verbose: true,
  );
  final b = await computer.start<int, int>(asyncFib, 40);
  print('Calculated b: $b');
  final c = await computer.start<int, int>(fib, 30);
  print('Calculated c: $c');

  await computer.turnOff();
}

int fib(int n) {
  if (n < 2) {
    return n;
  }
  return fib(n - 2) + fib(n - 1);
}

Future<int> asyncFib(int n) async {
  await Future<void>.delayed(const Duration(seconds: 2));

  if (n < 2) {
    return n;
  }
  return fib(n - 2) + fib(n - 1);
}
