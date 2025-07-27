class NotesValidator {
  static const int minLength = 3;
  static const int maxLength = 500;

  // Caracteres especiales peligrosos no permitidos
  static const List<String> _dangerousCharacters = [
    '<',
    '>',
    '&',
    '"',
    "'",
    '/',
    '\\',
    '{',
    '}',
    '[',
    ']',
    ';',
    '=',
  ];

  /// Valida las notas del cliente
  /// Retorna null si no hay errores, o un mensaje de error si los hay
  static String? validateNotes(String? notes) {
    // Si está vacío o es null, es válido (campo opcional)
    if (notes == null || notes.trim().isEmpty) {
      return null;
    }

    final trimmedNotes = notes.trim();

    // Validar longitud mínima
    final lengthError = _validateLength(trimmedNotes);
    if (lengthError != null) return lengthError;

    // Validar formato (solo alfanuméricos y espacios)
    final formatError = _validateFormat(trimmedNotes);
    if (formatError != null) return formatError;

    // Validar caracteres peligrosos
    final dangerousCharError = _validateDangerousCharacters(trimmedNotes);
    if (dangerousCharError != null) return dangerousCharError;

    return null;
  }

  /// Valida la longitud de las notas
  static String? _validateLength(String notes) {
    if (notes.length < minLength) {
      return 'Las notas deben tener al menos $minLength caracteres';
    }

    if (notes.length > maxLength) {
      return 'Las notas no pueden exceder $maxLength caracteres';
    }

    return null;
  }

  /// Valida que solo contenga caracteres alfanuméricos y espacios
  static String? _validateFormat(String notes) {
    // Permitir letras, números, espacios, puntos, comas, acentos y ñ
    final regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s.,]+$');

    if (!regex.hasMatch(notes)) {
      return 'Las notas solo pueden contener letras, números, espacios, puntos y comas';
    }

    return null;
  }

  /// Valida que no contenga caracteres especiales peligrosos
  static String? _validateDangerousCharacters(String notes) {
    for (String char in _dangerousCharacters) {
      if (notes.contains(char)) {
        return 'Las notas contienen caracteres no permitidos: $char';
      }
    }

    return null;
  }

  /// Verifica si las notas son válidas (sin retornar mensaje de error)
  static bool isValid(String? notes) {
    return validateNotes(notes) == null;
  }

  /// Obtiene el conteo de caracteres actual
  static String getCharacterCount(String? notes) {
    final length = notes?.trim().length ?? 0;
    return '$length/$maxLength';
  }
}
