import 'package:econopreco/features/core/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    group('when', () {
      test(
        'Should execute onSuccess and not execute onError when it is Success',
        () {
          final Result<int> result = Success(42);
          bool successCalled = false;
          bool errorCalled = false;
          late final int returnedValue;

          result.when(
            onError: (error) => errorCalled = true,
            onSuccess: (value) {
              successCalled = true;
              returnedValue = value;
            },
          );

          expect(successCalled, isTrue);
          expect(errorCalled, isFalse);
          expect(returnedValue, equals(42));
        },
      );

      test(
        'deve executar onError e não executar onSuccess quando for Error',
        () {
          final exception = Exception('Falha na operação');
          final Result<int> result = Error(exception);
          var successCalled = false;
          var errorCalled = false;
          Exception? returnedException;

          result.when(
            onError: (error) {
              errorCalled = true;
              returnedException = error;
            },
            onSuccess: (value) => successCalled = true,
          );

          expect(errorCalled, isTrue);
          expect(successCalled, isFalse);
          expect(returnedException, same(exception));
        },
      );
    });

    group('fold', () {
      test('deve retornar o valor de onSuccess e não executar onError quando for Success', () {
        final Result<int> result = Success(10);
        var errorCalled = false;

        final foldResult = result.fold((error) {
          errorCalled = true;
          return 'erro';
        }, (value) => 'sucesso: $value');

        expect(foldResult, equals('sucesso: 10'));
        expect(errorCalled, isFalse);
      });

      test('deve retornar o valor de onError e não executar onSuccess quando for Error', () {
        final exception = Exception('Falha na operação');
        final Result<int> result = Error(exception);
        var successCalled = false;

        final foldResult = result.fold((error) => 'erro: ${error.toString()}', (
          value,
        ) {
          successCalled = true;
          return 'sucesso: $value';
        });

        expect(foldResult, contains('Falha na operação'));
        expect(successCalled, isFalse);
      });
    });
  });
}
