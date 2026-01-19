import 'package:equatable/equatable.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content_type.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_result.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/form_field_state.dart';

/// QR Generator state
class QRGeneratorState extends Equatable {
  final QRContentType selectedContentType;
  final QRContent? content;
  final QRCustomization customization;
  final QRResult? qrResult;
  final bool isGenerating;
  final bool isPickingLogo;
  final String? errorMessage;
  final String? validationError;
  final Map<String, FormFieldState> formFields;

  const QRGeneratorState({
    required this.selectedContentType,
    this.content,
    required this.customization,
    this.qrResult,
    this.isGenerating = false,
    this.isPickingLogo = false,
    this.errorMessage,
    this.validationError,
    this.formFields = const {},
  });

  /// Initial state
  factory QRGeneratorState.initial() {
    return QRGeneratorState(
      selectedContentType: QRContentType.text,
      customization: const QRCustomization(),
    );
  }

  /// Copy with updated fields
  QRGeneratorState copyWith({
    QRContentType? selectedContentType,
    QRContent? content,
    QRCustomization? customization,
    QRResult? qrResult,
    bool? isGenerating,
    bool? isPickingLogo,
    String? errorMessage,
    String? validationError,
    Map<String, FormFieldState>? formFields,
    bool clearError = false,
    bool clearValidationError = false,
    bool clearQRResult = false,
    bool clearFormFields = false,
  }) {
    return QRGeneratorState(
      selectedContentType: selectedContentType ?? this.selectedContentType,
      content: content ?? this.content,
      customization: customization ?? this.customization,
      qrResult: clearQRResult ? null : (qrResult ?? this.qrResult),
      isGenerating: isGenerating ?? this.isGenerating,
      isPickingLogo: isPickingLogo ?? this.isPickingLogo,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      validationError: clearValidationError
          ? null
          : (validationError ?? this.validationError),
      formFields: clearFormFields ? const {} : (formFields ?? this.formFields),
    );
  }

  /// Check if QR can be generated
  bool get canGenerate => content != null && validationError == null;

  /// Check if logo is present
  bool get hasLogo => customization.hasLogo;

  /// Get form field state by key
  FormFieldState getFieldState(String key) {
    return formFields[key] ?? FormFieldState.initial();
  }

  /// Check if all form fields are valid
  bool get areAllFieldsValid {
    if (formFields.isEmpty) return true;
    return formFields.values.every((field) => field.isValid);
  }

  @override
  List<Object?> get props => [
        selectedContentType,
        content,
        customization,
        qrResult,
        isGenerating,
        isPickingLogo,
        errorMessage,
        validationError,
        formFields,
      ];
}
