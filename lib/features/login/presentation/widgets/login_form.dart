import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Regex patterns para validaciones
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*$',
  );
  static final RegExp _emailAllowedChars = RegExp(r'^[a-zA-Z0-9.@_%-]+$');
  static final RegExp _passwordAllowedChars = RegExp(
    r'^[a-zA-Z0-9!@#$%^&*()\-_=+\[\]{}|:;"<>,.?/]*$',
  );
  static final RegExp _dangerousChars = RegExp(r'[<>"' + "'" + r';&|\\\/]');
  static final RegExp _consecutiveDots = RegExp(r'\.{2,}');

  // Lista de passwords comunes
  static const List<String> _commonPasswords = [
    '12345678',
    'password',
    'qwerty',
    '123456789',
    'abc123',
    'password123',
    'admin',
    '1234567890',
    'qwerty123',
    'letmein',
    '123123123',
    'welcome',
    'monkey',
    'dragon',
    'master',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  String? _validateEmailFormat(String email) {
    if (!_emailAllowedChars.hasMatch(email)) {
      return 'El email solo puede contener letras, números, puntos, guiones y @';
    }

    if (_dangerousChars.hasMatch(email)) {
      return 'El email contiene caracteres no permitidos';
    }

    if (_consecutiveDots.hasMatch(email)) {
      return 'El email no puede tener puntos consecutivos';
    }

    return null;
  }

 
  String? _validateEmailLength(String email) {
    if (email.length < 14) {
      return 'El email debe tener al menos 14 caracteres';
    }

    if (email.length > 50) {
      return 'El email no puede tener más de 50 caracteres';
    }

    return null;
  }

  String? _validatePasswordFormat(String password) {
    if (!_passwordAllowedChars.hasMatch(password)) {
      return 'La contraseña contiene caracteres no permitidos';
    }

    if (password.runes.any((rune) => rune < 32 || rune > 126)) {
      return 'La contraseña contiene caracteres no válidos';
    }

    return null;
  }

  String? _validatePasswordLength(String password) {
    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (password.length > 32) {
      return 'La contraseña no puede tener más de 32 caracteres';
    }

    return null;
  }

  // Método auxiliar para validar fortaleza de password
  String? _validatePasswordStrength(String password) {
    if (!_passwordRegex.hasMatch(password)) {
      return 'La contraseña debe contener al menos una mayúscula, una minúscula y un número';
    }

    if (_commonPasswords.contains(password.toLowerCase())) {
      return 'Esta contraseña es muy común, elige una más segura';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }

    // Remover espacios al inicio y final para validación
    final email = value.trim();

    // Validaciones en cascada: formato → longitud → contenido → regex
    String? formatError = _validateEmailFormat(email);
    if (formatError != null) return formatError;

    String? lengthError = _validateEmailLength(email);
    if (lengthError != null) return lengthError;

    if (!email.contains('@')) {
      return 'Por favor ingresa un email válido';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'Por favor ingresa un email válido';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }

    // Validaciones en cascada: formato → longitud → contenido → regex
    String? formatError = _validatePasswordFormat(value);
    if (formatError != null) return formatError;

    String? lengthError = _validatePasswordLength(value);
    if (lengthError != null) return lengthError;

    String? strengthError = _validatePasswordStrength(value);
    if (strengthError != null) return strengthError;

    return null;
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.cut, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              'BarberTrack',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inicia sesión para continuar',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 48),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Ingresa tu email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      hintText: 'Ingresa tu contraseña',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state is LoginLoading ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is LoginLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Enlace para ir al registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta? ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/register');
                        },
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
