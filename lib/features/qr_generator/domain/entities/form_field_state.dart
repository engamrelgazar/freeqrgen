import 'package:equatable/equatable.dart';

/// Represents the state of a single form field
class FormFieldState extends Equatable {
  final String value;
  final String? errorMessage;
  final bool isValid;

  const FormFieldState({
    required this.value,
    this.errorMessage,
    required this.isValid,
  });

  /// Initial empty state
  factory FormFieldState.initial() {
    return const FormFieldState(
      value: '',
      isValid: true,
    );
  }

  /// Valid state with value
  factory FormFieldState.valid(String value) {
    return FormFieldState(
      value: value,
      isValid: true,
    );
  }

  /// Invalid state with error
  factory FormFieldState.invalid(String value, String errorMessage) {
    return FormFieldState(
      value: value,
      errorMessage: errorMessage,
      isValid: false,
    );
  }

  /// Copy with updated fields
  FormFieldState copyWith({
    String? value,
    String? errorMessage,
    bool? isValid,
    bool clearError = false,
  }) {
    return FormFieldState(
      value: value ?? this.value,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [value, errorMessage, isValid];
}
