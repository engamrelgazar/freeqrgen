import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/platform/file_picker_service.dart';
import 'package:freeqrgen/core/utils/content_validators.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/form_field_state.dart';
import 'package:freeqrgen/features/qr_generator/domain/usecases/generate_qr_code.dart';
import 'package:freeqrgen/features/qr_generator/domain/usecases/validate_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// BLoC for QR Generator feature
class QRGeneratorBloc extends Bloc<QRGeneratorEvent, QRGeneratorState> {
  final GenerateQRCode generateQRCode;
  final ValidateContent validateContent;
  final FilePickerService filePickerService;

  QRGeneratorBloc({
    required this.generateQRCode,
    required this.validateContent,
    required this.filePickerService,
  }) : super(QRGeneratorState.initial()) {
    on<ChangeContentType>(_onChangeContentType);
    on<UpdateContent>(_onUpdateContent);
    on<UpdateCustomization>(_onUpdateCustomization);
    on<GenerateQR>(_onGenerateQR);
    on<PickLogoImage>(_onPickLogoImage);
    on<RemoveLogo>(_onRemoveLogo);
    on<ResetToDefaults>(_onResetToDefaults);
    on<UpdateFormField>(_onUpdateFormField);
    on<ValidateFormField>(_onValidateFormField);
    on<ClearFormFields>(_onClearFormFields);
  }

  /// Handle content type change
  void _onChangeContentType(
    ChangeContentType event,
    Emitter<QRGeneratorState> emit,
  ) {
    emit(state.copyWith(
      selectedContentType: event.contentType,
      content: null,
      clearQRResult: true,
      clearError: true,
      clearValidationError: true,
      clearFormFields: true,
    ));
  }

  /// Handle content update
  void _onUpdateContent(
    UpdateContent event,
    Emitter<QRGeneratorState> emit,
  ) {
    // Validate content
    final validationResult = validateContent(event.content);
    
    if (validationResult.isLeft) {
      emit(state.copyWith(
        content: event.content,
        validationError: validationResult.left.message,
        clearQRResult: true,
      ));
    } else {
      emit(state.copyWith(
        content: event.content,
        clearValidationError: true,
        clearError: true,
      ));
      
      // Auto-generate QR code if content is valid
      add(const GenerateQR());
    }
  }

  /// Handle customization update
  void _onUpdateCustomization(
    UpdateCustomization event,
    Emitter<QRGeneratorState> emit,
  ) {
    emit(state.copyWith(
      customization: event.customization,
    ));
    
    // Regenerate QR if content exists
    if (state.content != null) {
      add(const GenerateQR());
    }
  }

  /// Handle QR generation
  Future<void> _onGenerateQR(
    GenerateQR event,
    Emitter<QRGeneratorState> emit,
  ) async {
    if (state.content == null) return;

    emit(state.copyWith(
      isGenerating: true,
      clearError: true,
    ));

    final result = await generateQRCode(
      content: state.content!,
      customization: state.customization,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isGenerating: false,
          errorMessage: failure.message,
        ));
      },
      (qrResult) {
        emit(state.copyWith(
          isGenerating: false,
          qrResult: qrResult,
          clearError: true,
        ));
      },
    );
  }

  /// Handle logo image picking
  Future<void> _onPickLogoImage(
    PickLogoImage event,
    Emitter<QRGeneratorState> emit,
  ) async {
    emit(state.copyWith(isPickingLogo: true));

    try {
      final imageBytes = await filePickerService.pickImage();
      
      if (imageBytes != null) {
        final updatedCustomization = state.customization.copyWith(
          logoBytes: imageBytes,
        );
        
        emit(state.copyWith(
          customization: updatedCustomization,
          isPickingLogo: false,
        ));
        
        // Regenerate QR with logo
        if (state.content != null) {
          add(const GenerateQR());
        }
      } else {
        emit(state.copyWith(isPickingLogo: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isPickingLogo: false,
        errorMessage: 'Failed to pick image: ${e.toString()}',
      ));
    }
  }

  /// Handle logo removal
  void _onRemoveLogo(
    RemoveLogo event,
    Emitter<QRGeneratorState> emit,
  ) {
    final updatedCustomization = state.customization.copyWith(
      clearLogo: true,
    );
    
    emit(state.copyWith(
      customization: updatedCustomization,
    ));
    
    // Regenerate QR without logo
    if (state.content != null) {
      add(const GenerateQR());
    }
  }

  /// Handle reset to defaults
  void _onResetToDefaults(
    ResetToDefaults event,
    Emitter<QRGeneratorState> emit,
  ) {
    emit(QRGeneratorState.initial());
  }

  /// Handle form field update
  void _onUpdateFormField(
    UpdateFormField event,
    Emitter<QRGeneratorState> emit,
  ) {
    final updatedFields = Map<String, FormFieldState>.from(state.formFields);
    final currentField = state.getFieldState(event.fieldKey);
    
    updatedFields[event.fieldKey] = currentField.copyWith(
      value: event.value,
      clearError: true,
    );

    emit(state.copyWith(formFields: updatedFields));
  }

  /// Handle form field validation
  void _onValidateFormField(
    ValidateFormField event,
    Emitter<QRGeneratorState> emit,
  ) {
    final updatedFields = Map<String, FormFieldState>.from(state.formFields);
    
    // Perform validation based on field key
    final validationResult = _validateField(event.fieldKey, event.value);
    
    if (validationResult.isValid) {
      updatedFields[event.fieldKey] = FormFieldState.valid(event.value);
    } else {
      updatedFields[event.fieldKey] = FormFieldState.invalid(
        event.value,
        validationResult.errorMessage ?? 'Invalid input',
      );
    }

    emit(state.copyWith(formFields: updatedFields));
  }

  /// Handle clear form fields
  void _onClearFormFields(
    ClearFormFields event,
    Emitter<QRGeneratorState> emit,
  ) {
    emit(state.copyWith(clearFormFields: true));
  }

  /// Validate a field based on its key
  ValidationResult _validateField(String fieldKey, String value) {
    switch (fieldKey) {
      case 'text':
        return ContentValidators.validateText(value);
      case 'email':
        return ContentValidators.validateEmail(value);
      case 'email_subject':
        return ContentValidators.validateEmailSubject(value);
      case 'email_body':
        return ContentValidators.validateEmailBody(value);
      case 'url':
        return ContentValidators.validateURL(value);
      case 'phone':
        return ContentValidators.validatePhone(value);
      case 'sms_phone':
        return ContentValidators.validatePhone(value);
      case 'sms_message':
        return ContentValidators.validateSMSMessage(value);
      case 'wifi_ssid':
        return ContentValidators.validateWiFiSSID(value);
      case 'contact_first_name':
        return value.isNotEmpty
            ? ValidationResult.valid()
            : ValidationResult.error('First name is required');
      case 'latitude':
        return ContentValidators.validateLatitude(value);
      case 'longitude':
        return ContentValidators.validateLongitude(value);
      case 'event_title':
        return ContentValidators.validateEventTitle(value);
      case 'whatsapp_phone':
        return ContentValidators.validateWhatsAppPhone(value);
      case 'instagram_username':
        return ContentValidators.validateInstagramUsername(value);
      case 'telegram_username':
        return ContentValidators.validateTelegramUsername(value);
      case 'twitter_username':
        return ContentValidators.validateTwitterUsername(value);
      default:
        return ValidationResult.valid();
    }
  }
}
