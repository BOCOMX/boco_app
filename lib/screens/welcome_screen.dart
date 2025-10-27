import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // Importamos MyHomePage

const Color primaryColor = Color(0xFF1C1C1C);
const Color secondaryColor = Color(0xFFFF678D);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _acceptTerms(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('acceptedTerms', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Términos y Condiciones",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "Aquí van los términos y condiciones de la app...",
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _acceptTerms(context),
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              child: const Text("Aceptar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
