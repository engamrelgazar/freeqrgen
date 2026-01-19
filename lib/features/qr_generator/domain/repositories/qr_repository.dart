import 'dart:typed_data';
import 'package:freeqrgen/core/errors/failures.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_result.dart';

/// Repository interface for QR code operations
abstract class QRRepository {
  /// Generate QR code from content and customization
  Future<Either<Failure, QRResult>> generateQRCode({
    required QRContent content,
    required QRCustomization customization,
  });

  /// Render QR code to image bytes
  Future<Either<Failure, Uint8List>> renderQRToImage({
    required QRResult qrResult,
    int? dpi,
  });

  /// Validate QR content
  Either<Failure, bool> validateContent(QRContent content);
}

/// Simple Either type for error handling
class Either<L, R> {
  final L? _left;
  final R? _right;

  const Either.left(L left)
      : _left = left,
        _right = null;

  const Either.right(R right)
      : _left = null,
        _right = right;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left {
    if (_left == null) {
      throw Exception('Called left on Right');
    }
    return _left;
  }

  R get right {
    if (_right == null) {
      throw Exception('Called right on Left');
    }
    return _right;
  }

  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn) {
    if (isLeft) {
      return leftFn(_left as L);
    } else {
      return rightFn(_right as R);
    }
  }
}
