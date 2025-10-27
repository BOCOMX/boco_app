import 'package:flutter/material.dart';
import 'adopt_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const Color secondaryColor = Color(0xFFFF678D);
const Color maleColor = Color(0xFF4E9FE7);

class PetAdoptionDetailScreen extends StatefulWidget {
  final List<String> imageUrls;
  final String name;
  final String location;
  final bool isMale;
  final DateTime birthDate;
  final bool vaccinated;
  final String description;

  const PetAdoptionDetailScreen({
    super.key,
    required this.imageUrls,
    required this.name,
    required this.location,
    required this.isMale,
    required this.birthDate,
    required this.vaccinated,
    required this.description,
  });

  @override
  State<PetAdoptionDetailScreen> createState() => _PetAdoptionDetailScreenState();
}

class _PetAdoptionDetailScreenState extends State<PetAdoptionDetailScreen> {
  int _currentImage = 0;

  String get _age {
    final now = DateTime.now();
    int years = now.year - widget.birthDate.year;
    int months = now.month - widget.birthDate.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    if (years > 0) {
      return years == 1 ? '1 año' : '$years años';
    } else {
      return '$months meses';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Volver', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrusel de fotos cuadrado, con márgenes y bordes redondeados SOLO en el contenedor
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        itemCount: widget.imageUrls.length,
                        onPageChanged: (i) => setState(() => _currentImage = i),
                        itemBuilder: (context, i) => Image.network(
                          widget.imageUrls[i],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.imageUrls.length, (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImage == i ? 18 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _currentImage == i ? secondaryColor : Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black12),
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre sin ícono de género a la derecha
                  Text(
                    widget.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.location,
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Chips informativos centrados y con espaciado fijo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoChip(
                          icon: widget.isMale ? Icons.male : Icons.female, 
                          label: widget.isMale ? 'Macho' : 'Hembra',
                          iconColor: widget.isMale ? maleColor : secondaryColor,
                        ),
                        _InfoChip(
                          icon: Icons.cake, 
                          label: _age,
                          iconColor: secondaryColor,
                        ),
                        _InfoChip(
                          icon: Icons.vaccines, 
                          label: widget.vaccinated ? 'Vacunado' : 'Sin vacunas',
                          iconColor: secondaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 36),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdoptionRequestFormScreen()),
                        );
                      },
                      child: const Text('Solicitar adopción', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _InfoChip({
    required this.icon, 
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 10),
          Text(
            label, 
            style: const TextStyle(
              fontWeight: FontWeight.w500, 
              fontSize: 15
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class AdoptionRequestFormScreen extends StatefulWidget {
  const AdoptionRequestFormScreen({super.key});

  @override
  State<AdoptionRequestFormScreen> createState() => _AdoptionRequestFormScreenState();
}

class _AdoptionRequestFormScreenState extends State<AdoptionRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _petPlaceDescController = TextEditingController();
  List<String> _homePhotos = [];
  String? _houseType;
  String? _hasPatio;
  String? _livesAlone;
  String? _allAgree;
  String? _hasPets;
  String? _hasHadPets;
  String? _enoughIncome;
  final TextEditingController _numPetsController = TextEditingController();
  final TextEditingController _typePetsController = TextEditingController();
  String? _petsSterilized;

  final List<String> _yesNo = ['Sí', 'No'];
  final List<String> _houseTypes = ['Casa propia', 'Renta'];
  final List<String> _patioTypes = ['Sí', 'No'];

  // Simulación de datos de usuario
  final String _userName = 'Nombre de usuario';
  final String _userEmail = 'usuario@email.com';
  final String _userAge = '25';
  final String _userAddress = 'Municipio, Colonia';

  Future<void> _pickHomePhotos() async {
    // Aquí puedes usar image_picker o similar
    // Simulación: solo agrega un string
    setState(() {
      _homePhotos.add('foto_${_homePhotos.length + 1}.jpg');
    });
  }

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 18, right: 18,
          top: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom + 18,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Datos personales', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildReadOnlyField('Nombre completo', _userName),
              const SizedBox(height: 10),
              _buildReadOnlyField('Edad', _userAge),
              const SizedBox(height: 10),
              _buildReadOnlyField('Correo electrónico', _userEmail),
              const SizedBox(height: 10),
              _buildReadOnlyField('Municipio y colonia', _userAddress),
              const SizedBox(height: 22),
              const Text('Sobre tu hogar', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('¿Tienes casa propia o rentas?'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _houseType,
                items: _houseTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _houseType = v),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                ),
                validator: (v) => v == null ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 14),
              const Text('¿Tienes patio o espacio para la mascota?'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _hasPatio,
                items: _patioTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _hasPatio = v),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                ),
                validator: (v) => v == null ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 14),
              const Text('¿Dónde habitaría y dormiría la mascota? (añade fotos)'),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _pickHomePhotos,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.add_a_photo, color: secondaryColor, size: 24),
                  ),
                ),
              ),
              if (_homePhotos.isNotEmpty)
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _homePhotos.map((img) => Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.image, color: Colors.grey, size: 24),
                      ),
                    )).toList(),
                  ),
                ),
              const SizedBox(height: 14),
              const Text('¿Vives solo/a?'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _livesAlone,
                items: _yesNo.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _livesAlone = v),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                ),
                validator: (v) => v == null ? 'Campo obligatorio' : null,
              ),
              if (_livesAlone == 'No') ...[
                const SizedBox(height: 14),
                const Text('¿Todos en casa están de acuerdo con la adopción?'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _allAgree,
                  items: _yesNo.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setState(() => _allAgree = v),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  ),
                  validator: (v) => v == null ? 'Campo obligatorio' : null,
                ),
              ],
              const SizedBox(height: 24),
              const Text('Sobre experiencia y estilo de vida', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('¿Tienes mascotas actualmente?'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _hasPets,
                items: _yesNo.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() {
                  _hasPets = v;
                  _hasHadPets = null;
                }),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                ),
                validator: (v) => v == null ? 'Campo obligatorio' : null,
              ),
              if (_hasPets == 'Sí') ...[
                const SizedBox(height: 10),
                const Text('¿Cuántas?'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _numPetsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Número de mascotas',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 10),
                const Text('¿Qué tipo?'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _typePetsController,
                  decoration: InputDecoration(
                    hintText: 'Perro, gato, etc.',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 10),
                const Text('¿Esterilizadas?'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _petsSterilized,
                  items: _yesNo.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setState(() => _petsSterilized = v),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  ),
                  validator: (v) => v == null ? 'Campo obligatorio' : null,
                ),
              ] else if (_hasPets == 'No') ...[
                const SizedBox(height: 10),
                const Text('¿Has tenido mascotas antes?'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _hasHadPets,
                  items: _yesNo.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setState(() => _hasHadPets = v),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  ),
                  validator: (v) => v == null ? 'Campo obligatorio' : null,
                ),
              ],
              const SizedBox(height: 14),
              const Text('¿Consideras que tienes los ingresos suficientes para cubrir alimentación, cuidados médicos y necesidades de la mascota?'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _enoughIncome,
                items: _yesNo.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _enoughIncome = v),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                ),
                validator: (v) => v == null ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 24),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            '¡Solicitud enviada!',
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Enviar solicitud', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 3),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ),
      ],
    );
  }
} 