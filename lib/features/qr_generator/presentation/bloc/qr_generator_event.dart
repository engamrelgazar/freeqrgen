import 'package:equatable/equatable.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content_type.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_customization.dart';

/// Base class for QR Generator events
abstract class QRGeneratorEvent extends Equatable {
  const QRGeneratorEvent();

  @override
  List<Object?> get props => [];
}

/// Event to change content type
class ChangeContentType extends QRGeneratorEvent {
  final QRContentType contentType;

  const ChangeContentType(this.contentType);

  @override
  List<Object?> get props => [contentType];
}

/// Event to update content
class UpdateContent extends QRGeneratorEvent {
  final QRContent content;

  const UpdateContent(this.content);

  @override
  List<Object?> get props => [content];
}

/// Event to update customization
class UpdateCustomization extends QRGeneratorEvent {
  final QRCustomization customization;

  const UpdateCustomization(this.customization);

  @override
  List<Object?> get props => [customization];
}

/// Event to generate QR code
class GenerateQR extends QRGeneratorEvent {
  const GenerateQR();
}

/// Event to pick logo image
class PickLogoImage extends QRGeneratorEvent {
  const PickLogoImage();
}

/// Event to remove logo
class RemoveLogo extends QRGeneratorEvent {
  const RemoveLogo();
}

/// Event to reset to defaults
class ResetToDefaults extends QRGeneratorEvent {
  const ResetToDefaults();
}

/// Event to update a form field
class UpdateFormField extends QRGeneratorEvent {
  final String fieldKey;
  final String value;

  const UpdateFormField(this.fieldKey, this.value);

  @override
  List<Object?> get props => [fieldKey, value];
}

/// Event to validate a form field
class ValidateFormField extends QRGeneratorEvent {
  final String fieldKey;
  final String value;

  const ValidateFormField(this.fieldKey, this.value);

  @override
  List<Object?> get props => [fieldKey, value];
}

/// Event to clear all form fields
class ClearFormFields extends QRGeneratorEvent {
  const ClearFormFields();
}
