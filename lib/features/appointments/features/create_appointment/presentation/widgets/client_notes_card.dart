import 'package:flutter/material.dart';

class ClientNotesCard extends StatelessWidget {
  final TextEditingController notesController;
  final String clientNotes;
  final Function(String) onNotesChanged;
  final VoidCallback onConfirmPressed;

  const ClientNotesCard({
    super.key,
    required this.notesController,
    required this.clientNotes,
    required this.onNotesChanged,
    required this.onConfirmPressed,
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
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Comentarios o notas especiales (opcional)',
                hintText: 'Ej: Corte específico, preferencias, etc.',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: onNotesChanged,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: onConfirmPressed,
                child: const Text('Confirmar cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
