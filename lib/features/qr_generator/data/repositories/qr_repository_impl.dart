import 'dart:typed_data';
import 'package:freeqrgen/core/errors/exceptions.dart';
import 'package:freeqrgen/core/errors/failures.dart';
import 'package:freeqrgen/features/qr_generator/data/datasources/qr_generator_datasource.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_result.dart';
import 'package:freeqrgen/features/qr_generator/domain/repositories/qr_repository.dart';
import 'package:freeqrgen/features/qr_generator/domain/usecases/validate_content.dart';

/// Implementation of QR repository
class QRRepositoryImpl implements QRRepository {
  final QRGeneratorDataSource dataSource;

  QRRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, QRResult>> generateQRCode({
    required QRContent content,
    required QRCustomization customization,
  }) async {
    try {
      // Convert content to QR string
      final qrString = content.toQRString();

      // Validate content
      final validationResult = validateContent(content);
      if (validationResult.isLeft) {
        return Either.left(validationResult.left);
      }

      // Generate QR data (validates that it can be created)
      dataSource.generateQRData(
        data: qrString,
        errorCorrectionLevel: customization.errorCorrectionLevel,
      );

      // Create result
      final result = QRResult(
        content: content,
        customization: customization,
        qrString: qrString,
      );

      return Either.right(result);
    } on QRGenerationException catch (e) {
      return Either.left(
        QRGenerationFailure(message: e.message, code: e.code),
      );
    } catch (e) {
      return Either.left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Uint8List>> renderQRToImage({
    required QRResult qrResult,
    int? dpi,
  }) async {
    try {
      // This will be implemented when we create the UI layer
      // For now, return a placeholder
      return const Either.left(
        UnexpectedFailure(message: 'Rendering not yet implemented'),
      );
    } catch (e) {
      return Either.left(
        ExportFailure(message: 'Failed to render QR: ${e.toString()}'),
      );
    }
  }

  @override
  Either<Failure, bool> validateContent(QRContent content) {
    try {
      // Use detailed validation
      return ValidateContent.validateDetailed(content);
    } catch (e) {
      return Either.left(
        ValidationFailure(message: 'Validation error: ${e.toString()}'),
      );
    }
  }
}
