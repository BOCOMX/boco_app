import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nombreController = TextEditingController(text: 'Fabián');
  final TextEditingController apellidoController = TextEditingController(text: '');
  final TextEditingController correoController = TextEditingController(text: 'fartigas27@gmail.com');
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showEditAccountModal() {
    showDialog(
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width * 0.9;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const NetworkImage('https://placehold.co/100x100') as ImageProvider,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt, color: Colors.grey, size: 32)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre(s)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: apellidoController,
                      decoration: const InputDecoration(labelText: 'Apellido(s)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: correoController,
                      decoration: const InputDecoration(labelText: 'Correo electrónico'),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Guardar cambios
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF678D),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showChangePasswordModal() {
    showDialog(
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width * 0.9;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Contraseña actual'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Nueva contraseña'),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Cambiar contraseña
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF678D),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToLegal(String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalScreen(title: title, content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Información de la cuenta
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 18),
            child: ListTile(
              leading: _profileImage != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(_profileImage!),
                      radius: 22,
                    )
                  : const CircleAvatar(
                      backgroundImage: NetworkImage('https://placehold.co/100x100'),
                      radius: 22,
                    ),
              title: Text(nombreController.text.isNotEmpty ? nombreController.text : 'Usuario'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _showEditAccountModal,
            ),
          ),
          // Seguridad
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 18),
            child: ListTile(
              leading: const Icon(Icons.lock_outline, color: Color(0xFFFF678D)),
              title: const Text('Cambiar contraseña'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _showChangePasswordModal,
            ),
          ),
          // Configuraciones
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 18),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications, color: Color(0xFFFF678D)),
              title: const Text('Notificaciones push'),
              value: pushNotifications,
              activeColor: const Color(0xFFFF678D),
              onChanged: (value) {
                setState(() {
                  pushNotifications = value;
                });
              },
            ),
          ),
          // FAQ y legales
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 18),
            child: ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFFFF678D)),
              title: const Text('FAQ'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => _navigateToLegal('FAQ', 'Aquí van las preguntas frecuentes de la app...'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 18),
            child: ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFFFF678D)),
              title: const Text('Política de privacidad'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => _navigateToLegal('Política de privacidad', 'Aquí va la política de privacidad...'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 18),
            child: ListTile(
              leading: const Icon(Icons.description_outlined, color: Color(0xFFFF678D)),
              title: const Text('Términos y condiciones'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => _navigateToLegal('Términos y condiciones', 'Aquí van los términos y condiciones...'),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 220,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('¿Eliminar cuenta?'),
                      content: const Text('Esta acción es irreversible. ¿Estás seguro de que deseas eliminar tu cuenta?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    // Lógica de eliminar cuenta
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                icon: const Icon(Icons.delete_outline, size: 22, color: Colors.red),
                label: const Text('Eliminar cuenta', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  foregroundColor: Colors.red,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegalScreen extends StatelessWidget {
  final String title;
  final String content;
  const LegalScreen({required this.title, required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(content, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
} 