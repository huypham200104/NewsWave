import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Backend-related failures(404, 500, etc)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Network-related failures (no internet, timeout, etc)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Database-related failures (DB errors, data not found, etc)
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

// Cache-related failures (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Authentication-related failures (login errors, token issues, etc)
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

// Validation-related failures (input errors, invalid data, etc)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Unknown or unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

