import 'package:flutter_test/flutter_test.dart';
import 'package:news_wave/core/error/failure.dart';

void main() {
  group('Failure – equality & props', () {
    // ──────────────────────────────────────────────────
    // ServerFailure
    // ──────────────────────────────────────────────────
    group('ServerFailure', () {
      test('should carry the correct message', () {
        const failure = ServerFailure('Server down');
        expect(failure.message, 'Server down');
      });

      test('props should contain only [message]', () {
        const failure = ServerFailure('Server down');
        expect(failure.props, ['Server down']);
      });

      test('two instances with same message should be equal', () {
        const a = ServerFailure('err');
        const b = ServerFailure('err');
        expect(a, b);
      });

      test('two instances with different messages should NOT be equal', () {
        const a = ServerFailure('err1');
        const b = ServerFailure('err2');
        expect(a, isNot(b));
      });
    });

    // ──────────────────────────────────────────────────
    // CacheFailure
    // ──────────────────────────────────────────────────
    group('CacheFailure', () {
      test('should carry the correct message', () {
        const failure = CacheFailure('No cache');
        expect(failure.message, 'No cache');
      });

      test('props should contain only [message]', () {
        const failure = CacheFailure('No cache');
        expect(failure.props, ['No cache']);
      });

      test('two instances with same message should be equal', () {
        const a = CacheFailure('cache err');
        const b = CacheFailure('cache err');
        expect(a, b);
      });
    });

    // ──────────────────────────────────────────────────
    // NetworkFailure
    // ──────────────────────────────────────────────────
    group('NetworkFailure', () {
      test('should carry the correct message', () {
        const failure = NetworkFailure('No internet');
        expect(failure.message, 'No internet');
      });

      test('props should contain only [message]', () {
        const failure = NetworkFailure('No internet');
        expect(failure.props, ['No internet']);
      });
    });

    // ──────────────────────────────────────────────────
    // DatabaseFailure
    // ──────────────────────────────────────────────────
    group('DatabaseFailure', () {
      test('should carry the correct message', () {
        const failure = DatabaseFailure('DB error');
        expect(failure.message, 'DB error');
      });

      test('two instances with same message should be equal', () {
        const a = DatabaseFailure('db');
        const b = DatabaseFailure('db');
        expect(a, b);
      });
    });

    // ──────────────────────────────────────────────────
    // AuthenticationFailure
    // ──────────────────────────────────────────────────
    group('AuthenticationFailure', () {
      test('should carry the correct message', () {
        const failure = AuthenticationFailure('Unauthorized');
        expect(failure.message, 'Unauthorized');
      });
    });

    // ──────────────────────────────────────────────────
    // ValidationFailure
    // ──────────────────────────────────────────────────
    group('ValidationFailure', () {
      test('should carry the correct message', () {
        const failure = ValidationFailure('Invalid input');
        expect(failure.message, 'Invalid input');
      });
    });

    // ──────────────────────────────────────────────────
    // UnknownFailure
    // ──────────────────────────────────────────────────
    group('UnknownFailure', () {
      test('should carry the correct message', () {
        const failure = UnknownFailure('Something went wrong');
        expect(failure.message, 'Something went wrong');
      });
    });

    // ──────────────────────────────────────────────────
    // Cross-type comparison
    // ──────────────────────────────────────────────────
    group('Cross-type inequality', () {
      test('ServerFailure and CacheFailure with same message should NOT be equal', () {
        const a = ServerFailure('err');
        const b = CacheFailure('err');
        expect(a, isNot(b));
      });
    });
  });
}
