// Utility class to represent the result of an operation that can either succeed or fail.
//
// A [Result] can be either a [Success] with a value of tipe [T]
// or an [Error] with an [Exception] error.
//
// Example usage:
// ```dart
// Result<int> result = performOperation();
// result.fold(
//   (error) => print('Operation failed with error: $error'),
//   (value) => print('Operation succeeded with value: $value'),
// );
// ```
sealed class Result<T> {
  // Folds the [Result] into a single value of type [R].
  // Useful when a [Result] return is expected to be handled in a single place.
  R fold<R>(R Function(Exception error) onError, R Function(T value) onSuccess) {
    return switch (this) {
      Success(:final value) => onSuccess(value),
      Error(:final error) => onError(error),
    };
  }

  // Executes the appropriate callback based on whether the [Result] is a [Success] or an [Error].
  // Useful for handling the [Result] without needing to return a value.
  void when({
    required void Function(Exception error) onError,
    required void Function(T value) onSuccess,
  }) {
    switch (this) {
      case Success(:final value):
        onSuccess(value);
      case Error(:final error):
        onError(error);
    }
  }
}

final class Success<T>(final T value) extends Result<T> {}

final class Error(final Exception error) extends Result<Never> {}
