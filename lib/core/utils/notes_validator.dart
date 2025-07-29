class NotesValidator {
  static const int minLength = 3;
  static const int maxLength = 500;


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


  static String? validateNotes(String? notes) {
  
    if (notes == null || notes.trim().isEmpty) {
      return null;
    }

    final trimmedNotes = notes.trim();

   
    final lengthError = _validateLength(trimmedNotes);
    if (lengthError != null) return lengthError;

    
    final formatError = _validateFormat(trimmedNotes);
    if (formatError != null) return formatError;

    final dangerousCharError = _validateDangerousCharacters(trimmedNotes);
    if (dangerousCharError != null) return dangerousCharError;

    return null;
  }


  static String? _validateLength(String notes) {
    if (notes.length < minLength) {
      return 'Las notas deben tener al menos $minLength caracteres';
    }

    if (notes.length > maxLength) {
      return 'Las notas no pueden exceder $maxLength caracteres';
    }

    return null;
  }


  static String? _validateFormat(String notes) {
 
    final regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s.,]+$');

    if (!regex.hasMatch(notes)) {
      return 'Las notas solo pueden contener letras, números, espacios, puntos y comas';
    }

    return null;
  }


  static String? _validateDangerousCharacters(String notes) {
    for (String char in _dangerousCharacters) {
      if (notes.contains(char)) {
        return 'Las notas contienen caracteres no permitidos: $char';
      }
    }

    return null;
  }


  static bool isValid(String? notes) {
    return validateNotes(notes) == null;
  }

  static String getCharacterCount(String? notes) {
    final length = notes?.trim().length ?? 0;
    return '$length/$maxLength';
  }
}
