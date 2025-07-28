import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterForm extends StatefulWidget {
  final void Function({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  })
  onSubmit;

  const RegisterForm({super.key, required this.onSubmit});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es obligatorio';
    }

    // Validación de longitud
    if (value.length > 254) {
      return 'El email es demasiado largo (máximo 254 caracteres)';
    }

    if (value.length < 5) {
      return 'El email es demasiado corto (mínimo 5 caracteres)';
    }

    // Validación de contenido - caracteres peligrosos
    if (value.contains('<') ||
        value.contains('>') ||
        value.contains('"') ||
        value.contains("'") ||
        value.contains('&') ||
        value.contains('`') ||
        value.contains('\\') ||
        value.contains('/')) {
      return 'El email contiene caracteres no permitidos';
    }

    // Validación de formato con regex específico
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Formato de email inválido (ejemplo: usuario@dominio.com)';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    // Validación de longitud
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (value.length > 128) {
      return 'La contraseña es demasiado larga (máximo 128 caracteres)';
    }

    // Validación de contenido - caracteres peligrosos
    if (value.contains('<') ||
        value.contains('>') ||
        value.contains('"') ||
        value.contains("'") ||
        value.contains('`') ||
        value.contains('\\')) {
      return 'La contraseña contiene caracteres no permitidos';
    }

    // Validación de formato - complejidad
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigit = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return 'La contraseña debe contener al menos una mayúscula';
    }

    if (!hasLowercase) {
      return 'La contraseña debe contener al menos una minúscula';
    }

    if (!hasDigit) {
      return 'La contraseña debe contener al menos un número';
    }

    if (!hasSpecialChar) {
      return "La contraseña debe contener al menos un símbolo (!@#\$%^&*...)";
    }

    return null;
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es obligatorio';
    }

    // Validación de longitud
    if (value.length < 2) {
      return '$fieldName debe tener al menos 2 caracteres';
    }

    if (value.length > 50) {
      return '$fieldName es demasiado largo (máximo 50 caracteres)';
    }

    // Validación de contenido - caracteres peligrosos
    if (value.contains('<') ||
        value.contains('>') ||
        value.contains('"') ||
        value.contains("'") ||
        value.contains('&') ||
        value.contains('`') ||
        value.contains('\\') ||
        value.contains('/') ||
        value.contains('@') ||
        value.contains('#') ||
        value.contains(r'$') ||
        value.contains('%')) {
      return '$fieldName contiene caracteres no permitidos';
    }

    // Validación de formato - solo letras, espacios, acentos y apostrofes
    final nameRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s'-]+$");

    if (!nameRegex.hasMatch(value)) {
      return '$fieldName solo puede contener letras, espacios, acentos y apostrofes';
    }

    // Validación adicional - no puede empezar o terminar con espacios
    if (value.trim() != value) {
      return '$fieldName no puede empezar o terminar con espacios';
    }

    // Validación adicional - no puede tener espacios dobles
    if (value.contains('  ')) {
      return '$fieldName no puede tener espacios dobles';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio';
    }

    // Validación de longitud
    if (value.length < 10) {
      return 'El teléfono debe tener al menos 10 dígitos';
    }

    if (value.length > 15) {
      return 'El teléfono es demasiado largo (máximo 15 dígitos)';
    }

    // Validación de contenido - caracteres peligrosos
    if (value.contains('<') ||
        value.contains('>') ||
        value.contains('"') ||
        value.contains("'") ||
        value.contains('&') ||
        value.contains('`') ||
        value.contains('\\') ||
        value.contains('/') ||
        value.contains('@') ||
        value.contains('#')) {
      return 'El teléfono contiene caracteres no permitidos';
    }

    // Validación de formato - solo números y símbolo +
    final phoneRegex = RegExp(r'^\+?[1-9]\d{8,14}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Formato de teléfono inválido (ej: +34612345678)';
    }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ingresa tu nombre',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            validator: (value) => _validateName(value, 'El nombre'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Apellido',
              hintText: 'Ingresa tu apellido',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            validator: (value) => _validateName(value, 'El apellido'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'usuario@ejemplo.com',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(254)],
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              hintText: '+34612345678',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(15)],
            validator: _validatePhone,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Mínimo 8 caracteres',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: const OutlineInputBorder(),
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            inputFormatters: [LengthLimitingTextInputFormatter(128)],
            validator: _validatePassword,
            onFieldSubmitted: (_) => _submitForm(),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Registrarse',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
