import 'package:flutter/material.dart';

import 'fetures/core/result.dart';

class HomeView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome to the Home View')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Test Result class
          // Result<int> result = performOperation();
          // result.when(
          //   onError: (error) => ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Operation failed with error: $error')),
          //   ),
          //   onSuccess: (value) => ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Operation succeeded with value: $value')),
          //   ),
          // );

          // Test failing operation
          Result<int> failingResult = performFailingOperation();
          failingResult.when(
            onError: (error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failing operation error: $error')),
            ),
            onSuccess: (value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failing operation succeeded with value: $value'),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Result<int> performOperation() {
    return Success(-1);
  } // Example operation that returns a Success result

  Result<int> performFailingOperation() {
    return Error(Exception('Operation failed'));
  } // Example operation that returns an Error result
}
