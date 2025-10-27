import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Colores personalizados
const Color primaryColor = Color(0xFF1C1C1C);
const Color secondaryColor = Color(0xFFFF678D);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false; // Para ocultar/ver contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // LOGO CENTRADO
                Image.asset('assets/images/icono-boco.png', width: 120, height: 120),
                const SizedBox(height: 32),

                // INPUT CORREO
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Correo electrónico', style: TextStyle(fontSize: 15, color: Colors.black87)),
                ),
                const SizedBox(height: 6),
                _buildInputField(label: 'ejemplo@mail.com', isHint: true),
                const SizedBox(height: 18),

                // INPUT CONTRASEÑA
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Contraseña', style: TextStyle(fontSize: 15, color: Colors.black87)),
                ),
                const SizedBox(height: 6),
                _buildPasswordInput(),
                const SizedBox(height: 6),

                // OLVIDASTE CONTRASEÑA
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(0, 0)),
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: secondaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // BOTÓN INICIAR SESIÓN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // SEPARADOR
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('O inicia sesión con', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 22),

                // BOTÓN GOOGLE REDONDO SOLO ICONO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {},
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/icono-google.svg',
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // TEXTO DE REGISTRO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes una cuenta? ', style: TextStyle(fontSize: 15)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // MÉTODO PARA CREAR INPUTS
  Widget _buildInputField({required String label, bool isHint = false}) {
    return TextField(
      decoration: InputDecoration(
        hintText: isHint ? label : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      textInputAction: TextInputAction.done,
    );
  }

  // MÉTODO PARA CONTRASEÑA CON ICONO PEQUEÑO
  Widget _buildPasswordInput() {
    return TextField(
      obscureText: !_passwordVisible,
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
    );
  }
}
