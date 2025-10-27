import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Colores personalizados
const Color primaryColor = Color(0xFF1C1C1C);
const Color secondaryColor = Color(0xFFFF678D);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _showForm = false;
  bool _acceptTerms = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showForm
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => setState(() => _showForm = false),
              ),
              title: const Text('Volver', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              centerTitle: false,
            )
          : null,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: !_showForm ? _buildInitialOptions(context) : _buildRegisterForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialOptions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),
        Image.asset('assets/images/icono-boco.png', width: 120, height: 120),
        const SizedBox(height: 24),
        const Text(
          'Crea una cuenta',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 64),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.grey),
              ),
              elevation: 0,
            ),
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/icono-google.svg',
              height: 24,
            ),
            label: const Text('Continuar con Google', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.grey),
              ),
              elevation: 0,
            ),
            onPressed: () {
              setState(() => _showForm = true);
            },
            icon: const Icon(Icons.email_outlined, color: Colors.black, size: 22),
            label: const Text('Continuar con correo', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¿Ya tienes una cuenta? ', style: TextStyle(fontSize: 15)),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Inicia sesión',
                style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    bool hasMinLength = password.length >= 8;
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasSymbol = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    bool passwordsMatch = password == confirmPassword && password.isNotEmpty;
    String strength = 'Débil';
    int score = [hasMinLength, hasNumber, hasUpper, hasSymbol].where((v) => v).length;
    if (score >= 3) strength = 'Fuerte';
    else if (score == 2) strength = 'Media';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Crea tu cuenta para disfrutar de todos los beneficios de BOCO.',
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
        const SizedBox(height: 18),
        const Text('Correo electrónico', style: TextStyle(fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'ejemplo@mail.com',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 18),
        const Text('Contraseña', style: TextStyle(fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: !_passwordVisible,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: '***************',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 18),
        const Text('Confirmar contraseña', style: TextStyle(fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_confirmPasswordVisible,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: '***************',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              },
            ),
          ),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.shield_outlined, color: score >= 3 ? Colors.green : (score == 2 ? Colors.orange : Colors.red), size: 20),
            const SizedBox(width: 6),
            Text('Fortaleza: $strength', style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheck(hasMinLength, 'Al menos 8 caracteres'),
            _buildCheck(hasNumber, 'Incluye un número'),
            _buildCheck(hasUpper, 'Incluye una mayúscula'),
            _buildCheck(hasSymbol, 'Incluye un símbolo'),
            _buildCheck(passwordsMatch, 'Las contraseñas coinciden'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: _acceptTerms,
              activeColor: secondaryColor,
              onChanged: (val) {
                setState(() => _acceptTerms = val ?? false);
              },
            ),
            Flexible(
              child: Wrap(
                children: [
                  const Text('Acepto los '),
                  GestureDetector(
                    onTap: () => _showTermsDialog(context),
                    child: const Text(
                      'Términos y condiciones',
                      style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            onPressed: _acceptTerms && score >= 3 && passwordsMatch ? () {} : null,
            child: const Text('Registrarse', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCheck(bool value, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(value ? Icons.check_circle : Icons.radio_button_unchecked, size: 18, color: value ? Colors.green : Colors.grey),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 14, color: value ? Colors.green : Colors.black87)),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y condiciones'),
        content: const SingleChildScrollView(
          child: Text('Aquí van los términos y condiciones de la app. Puedes reemplazar este texto por el legal real.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: TextStyle(color: secondaryColor)),
          ),
        ],
      ),
    );
  }
}
