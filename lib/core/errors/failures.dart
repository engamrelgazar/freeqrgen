import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// QR generation related failures
class QRGenerationFailure extends Failure {
  const QRGenerationFailure({
    required super.message,
    super.code,
  });
}

/// Content validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Export related failures
class ExportFailure extends Failure {
  const ExportFailure({
    required super.message,
    super.code,
  });
}

/// File operation failures
class FileOperationFailure extends Failure {
  const FileOperationFailure({
    required super.message,
    super.code,
  });
}

/// Permission related failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

/// Share related failures
class ShareFailure extends Failure {
  const ShareFailure({
    required super.message,
    super.code,
  });
}

/// Platform not supported failure
class PlatformNotSupportedFailure extends Failure {
  const PlatformNotSupportedFailure({
    required super.message,
    super.code,
  });
}

/// Generic failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code,
  });
}
