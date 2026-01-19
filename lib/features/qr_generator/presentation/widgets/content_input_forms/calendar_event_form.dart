import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freeqrgen/core/constants/app_constants.dart';
import 'package:freeqrgen/features/qr_generator/domain/entities/qr_content.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:freeqrgen/features/qr_generator/presentation/bloc/qr_generator_state.dart';

/// Form for calendar event content input with BLoC-managed validation
class CalendarEventForm extends StatelessWidget {
  const CalendarEventForm({super.key});

  void _updateContent(
    BuildContext context,
    QRGeneratorState state,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    final titleField = state.getFieldState('event_title');
    final locationField = state.getFieldState('event_location');
    final descriptionField = state.getFieldState('event_description');

    if (titleField.isValid && titleField.value.isNotEmpty && 
        startDate != null && endDate != null) {
      final content = CalendarEventContent(
        title: titleField.value,
        startDate: startDate,
        endDate: endDate,
        location: locationField.value.isNotEmpty ? locationField.value : null,
        description: descriptionField.value.isNotEmpty ? descriptionField.value : null,
      );
      context.read<QRGeneratorBloc>().add(UpdateContent(content));
    }
  }

  Future<DateTime?> _selectDateTime(BuildContext context, DateTime? initialDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (picked != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
      );
      
      if (time != null) {
        return DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
      }
    }
    return null;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
      builder: (context, state) {
        final titleField = state.getFieldState('event_title');
        final startDateField = state.getFieldState('event_start_date');
        final endDateField = state.getFieldState('event_end_date');
        
        DateTime? startDate = startDateField.value.isNotEmpty 
            ? DateTime.tryParse(startDateField.value)
            : null;
        DateTime? endDate = endDateField.value.isNotEmpty 
            ? DateTime.tryParse(endDateField.value)
            : null;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'Enter Event Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    key: const ValueKey('event_title_field'),
                    decoration: InputDecoration(
                      labelText: 'Event Title *',
                      hintText: 'Meeting',
                      errorText: titleField.errorMessage,
                      prefixIcon: const Icon(Icons.title),
                    ),
                    onChanged: (value) {
                      context.read<QRGeneratorBloc>().add(
                        ValidateFormField('event_title', value),
                      );
                      _updateContent(context, state, startDate, endDate);
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(startDate == null 
                        ? 'Start Date & Time *' 
                        : 'Start: ${_formatDateTime(startDate)}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final selected = await _selectDateTime(context, startDate);
                      if (selected != null && context.mounted) {
                        context.read<QRGeneratorBloc>().add(
                          UpdateFormField('event_start_date', selected.toIso8601String()),
                        );
                        _updateContent(context, state, selected, endDate);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(endDate == null 
                        ? 'End Date & Time *' 
                        : 'End: ${_formatDateTime(endDate)}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final selected = await _selectDateTime(context, endDate ?? startDate);
                      if (selected != null && context.mounted) {
                        context.read<QRGeneratorBloc>().add(
                          UpdateFormField('event_end_date', selected.toIso8601String()),
                        );
                        _updateContent(context, state, startDate, selected);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    key: const ValueKey('event_location_field'),
                    decoration: const InputDecoration(
                      labelText: 'Location (Optional)',
                      hintText: 'Conference Room A',
                      prefixIcon: Icon(Icons.place),
                    ),
                    onChanged: (value) {
                      context.read<QRGeneratorBloc>().add(
                        UpdateFormField('event_location', value),
                      );
                      _updateContent(context, state, startDate, endDate);
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  TextField(
                    key: const ValueKey('event_description_field'),
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Event description',
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      context.read<QRGeneratorBloc>().add(
                        UpdateFormField('event_description', value),
                      );
                      _updateContent(context, state, startDate, endDate);
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  if (titleField.value.isNotEmpty &&
                      startDate != null &&
                      endDate != null &&
                      titleField.isValid)
                    Padding(
                      padding: const EdgeInsets.only(top: AppConstants.spacingM),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: AppConstants.spacingXS),
                          Text(
                            'Valid calendar event',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
