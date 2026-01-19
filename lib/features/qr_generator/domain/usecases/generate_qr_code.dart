import 'package:freeqrgen/core/errors/failures.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_result.dart';
import 'package:freeqrgen/features/qr_generator/domain/repositories/qr_repository.dart';

/// Use case for generating QR codes
class GenerateQRCode {
  final QRRepository repository;

  GenerateQRCode(this.repository);

  Future<Either<Failure, QRResult>> call({
    required QRContent content,
    required QRCustomization customization,
  }) async {
    // Validate content first
    final validationResult = repository.validateContent(content);
    if (validationResult.isLeft) {
      return Either.left(validationResult.left);
    }

    // Generate QR code
    return await repository.generateQRCode(
      content: content,
      customization: customization,
    );
  }
}
