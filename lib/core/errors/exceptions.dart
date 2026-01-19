/// Base class for all exceptions
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// QR generation related exceptions
class QRGenerationException extends AppException {
  const QRGenerationException({
    required super.message,
    super.code,
  });
}

/// Content validation exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
  });
}

/// Export related exceptions
class ExportException extends AppException {
  const ExportException({
    required super.message,
    super.code,
  });
}

/// File operation exceptions
class FileOperationException extends AppException {
  const FileOperationException({
    required super.message,
    super.code,
  });
}

/// Permission related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
  });
}

/// Share related exceptions
class ShareException extends AppException {
  const ShareException({
    required super.message,
    super.code,
  });
}

/// Platform not supported exception
class PlatformNotSupportedException extends AppException {
  const PlatformNotSupportedException({
    required super.message,
    super.code,
  });
}
