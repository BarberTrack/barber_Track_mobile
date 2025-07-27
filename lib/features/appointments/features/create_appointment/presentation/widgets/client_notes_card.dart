import 'package:flutter/material.dart';
import '../../../../../../core/utils/notes_validator.dart';

class ClientNotesCard extends StatelessWidget {
  final TextEditingController notesController;
  final String clientNotes;
  final Function(String) onNotesChanged;
  final VoidCallback onConfirmPressed;
  final String? errorMessage;
  final bool hasValidationError;

  const ClientNotesCard({
    super.key,
    required this.notesController,
    required this.clientNotes,
    required this.onNotesChanged,
    required this.onConfirmPressed,
    this.errorMessage,
    this.hasValidationError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note_add, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Notas adicionales',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Comentarios o notas especiales (opcional)',
                    hintText: 'Ej: Corte específico, preferencias, etc.',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: hasValidationError ? Colors.red : Colors.grey,
                        width: hasValidationError ? 2.0 : 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: hasValidationError ? Colors.red : Colors.grey,
                        width: hasValidationError ? 2.0 : 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: hasValidationError ? Colors.red : Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    counterText: NotesValidator.getCharacterCount(clientNotes),
                    counterStyle: TextStyle(
                      color: hasValidationError ? Colors.red : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  maxLines: 3,
                  maxLength: NotesValidator.maxLength,
                  onChanged: onNotesChanged,
                ),
                if (hasValidationError && errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasValidationError
                      ? Colors.grey.shade400
                      : Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: hasValidationError ? null : onConfirmPressed,
                child: const Text('Confirmar cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
