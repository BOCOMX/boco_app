import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color secondaryColor = Color(0xFFFF678D);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _error;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Volver', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                Image.asset('assets/images/icono-boco.png', width: 120, height: 120),
                const SizedBox(height: 10),
                const Text(
                  'Recuperar contraseña',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ingresa el correo con el que te registraste y te enviaremos un código para restaurar tu contraseña.',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Correo electrónico', style: TextStyle(fontSize: 15, color: Colors.black87)),
                ),
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
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 14)),
                  ),
                if (_sent)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('¡Te hemos enviado un código a tu correo!', style: TextStyle(color: Colors.green, fontSize: 14)),
                  ),
                const SizedBox(height: 28),
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
                    onPressed: _sent ? null : _sendCode,
                    child: const Text('Enviar código', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendCode() {
    setState(() {
      _error = null;
      _sent = false;
    });
    final email = _emailController.text.trim();
    // Simulación: solo acepta un correo de ejemplo
    if (email == 'fartigas27@gmail.com') {
      setState(() {
        _sent = true;
      });
    } else {
      setState(() {
        _error = 'No existe una cuenta con ese correo.';
      });
    }
  }
} 