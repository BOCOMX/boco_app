import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'adoption_detail_screen.dart';

const Color secondaryColor = Color(0xFFFF678D);

class PetCard extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final bool isMale;
  final DateTime? birthDate;
  final bool? vaccinated;
  final String? description;
  final VoidCallback? onTap;

  const PetCard({
    super.key,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.isMale,
    this.birthDate,
    this.vaccinated,
    this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isMale ? Icons.male : Icons.female,
                    color: isMale ? Colors.blue : Colors.pink,
                    size: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 0),
              child: Text(
                location,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdoptScreen extends StatefulWidget {
  const AdoptScreen({super.key});

  @override
  State<AdoptScreen> createState() => _AdoptScreenState();
}

class _AdoptScreenState extends State<AdoptScreen> {
  final List<String> categories = ['Todo', 'Perro', 'Gato'];
  String selectedCategory = 'Todo';

  final List<Map<String, dynamic>> pets = [
    {
      'name': 'Puppy Max',
      'location': 'New York, USA',
      'imageUrl': 'https://placehold.co/400x400/FF678D/FFF?text=Perro+Max',
      'isMale': true,
      'type': 'Perro',
      'birthDate': DateTime(2022, 5, 10),
      'vaccinated': true,
      'description': 'Un perrito adorable, juguetón y muy sociable. Ideal para familias con niños.',
    },
    {
      'name': 'Cat Chip',
      'location': 'New York, USA',
      'imageUrl': 'https://placehold.co/400x400/FF678D/FFF?text=Gato+Chip',
      'isMale': false,
      'type': 'Gato',
      'birthDate': DateTime(2021, 11, 2),
      'vaccinated': false,
      'description': 'Gatita curiosa y cariñosa, le encanta dormir en lugares soleados.',
    },
    {
      'name': 'Dog Bella',
      'location': 'Los Angeles, USA',
      'imageUrl': 'https://placehold.co/400x400/FF678D/FFF?text=Perra+Bella',
      'isMale': false,
      'type': 'Perro',
      'birthDate': DateTime(2020, 8, 15),
      'vaccinated': true,
      'description': 'Bella es muy activa y le encanta correr en el parque.',
    },
    {
      'name': 'Cat Luna',
      'location': 'Miami, USA',
      'imageUrl': 'https://placehold.co/400x400/FF678D/FFF?text=Gata+Luna',
      'isMale': false,
      'type': 'Gato',
      'birthDate': DateTime(2023, 2, 1),
      'vaccinated': true,
      'description': 'Luna es una gatita juguetona y muy tierna.',
    },
    {
      'name': 'Rocky',
      'location': 'Chicago, USA',
      'imageUrl': 'https://placehold.co/400x400/FF678D/FFF?text=Perro+Rocky',
      'isMale': true,
      'type': 'Perro',
      'birthDate': DateTime(2022, 9, 20),
      'vaccinated': false,
      'description': 'Rocky es un perro guardián, leal y protector.',
    },
    {
      'name': 'Misty',
      'location': 'Houston, USA',
      'imageUrl': 'https://placehold.co/400x400/FF678D/FFF?text=Gata+Misty',
      'isMale': false,
      'type': 'Gato',
      'birthDate': DateTime(2021, 6, 5),
      'vaccinated': true,
      'description': 'Misty es tranquila y le gusta observar por la ventana.',
    },
  ];

  List<Map<String, dynamic>> get filteredPets {
    if (selectedCategory == 'Todo') return pets;
    return pets.where((pet) => pet['type'] == selectedCategory).toList();
  }

  void _showCategoryMenu() async {
    final String? result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((cat) {
              return ListTile(
                title: Text(cat),
                leading: selectedCategory == cat
                    ? Icon(Icons.check, color: secondaryColor)
                    : null,
                onTap: () => Navigator.pop(context, cat),
              );
            }).toList(),
          ),
        );
      },
    );
    if (result != null && result != selectedCategory) {
      setState(() {
        selectedCategory = result;
      });
    }
  }

  void _goToAddPetForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPetFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showCategoryMenu,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Text(
                            selectedCategory,
                            style: const TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                          const Spacer(),
                          const Icon(Icons.filter_list, color: Colors.black87),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 36,
                  width: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      elevation: 2,
                    ),
                    onPressed: _goToAddPetForm,
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredPets.length,
              itemBuilder: (context, index) {
                final pet = filteredPets[index];
                return PetCard(
                  name: pet['name'],
                  location: pet['location'],
                  imageUrl: pet['imageUrl'],
                  isMale: pet['isMale'],
                  birthDate: pet['birthDate'],
                  vaccinated: pet['vaccinated'],
                  description: pet['description'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PetAdoptionDetailScreen(
                          imageUrls: [pet['imageUrl'], pet['imageUrl']], // Por ahora, repite la imagen
                          name: pet['name'],
                          location: pet['location'],
                          isMale: pet['isMale'],
                          birthDate: pet['birthDate'],
                          vaccinated: pet['vaccinated'],
                          description: pet['description'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddPetFormScreen extends StatefulWidget {
  const AddPetFormScreen({super.key});

  @override
  State<AddPetFormScreen> createState() => _AddPetFormScreenState();
}

class _AddPetFormScreenState extends State<AddPetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _birthDate;
  String? _type;
  String? _hasSpecificBreed;
  String? _sex;
  String? _vaccinated;

  final List<String> _types = ['Perro', 'Gato', 'Ave', 'Reptil', 'Pez', 'Roedor', 'Otro'];
  final List<String> _sexes = ['Macho', 'Hembra'];
  final List<String> _yesNo = ['Sí', 'No'];

  Future<void> _pickImages() async {
    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _images = picked;
      });
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Fotos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._images.map((img) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(img.path),
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.add_a_photo, color: secondaryColor, size: 32),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text('Nombre provisional', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nombre de la mascota',
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
              const SizedBox(height: 18),
              const Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _type,
                items: _types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _type = v;
                    _hasSpecificBreed = null;
                    _breedController.clear();
                  });
                },
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
              if (_type == 'Perro' || _type == 'Gato') ...[
                const SizedBox(height: 18),
                const Text('¿Tiene raza específica?', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _hasSpecificBreed,
                  items: _yesNo
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _hasSpecificBreed = v;
                      if (v == 'No') _breedController.text = 'Mestizo';
                      if (v == 'Sí') _breedController.clear();
                    });
                  },
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
                const SizedBox(height: 12),
                if (_hasSpecificBreed == 'Sí') ...[
                  const Text('¿Qué raza es?', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _breedController,
                    decoration: InputDecoration(
                      hintText: 'Raza de la mascota',
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
                ] else if (_hasSpecificBreed == 'No') ...[
                  const Text('Raza: Mestizo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ],
              const SizedBox(height: 18),
              const Text('Fecha de nacimiento', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 365)),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _birthDate = picked);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _birthDate == null
                        ? 'Selecciona la fecha'
                        : '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}',
                    style: TextStyle(
                      color: _birthDate == null ? Colors.grey : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (_birthDate == null)
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 2),
                  child: Text('Campo obligatorio', style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 18),
              const Text('Sexo', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _sex,
                items: _sexes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _sex = v),
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
              const SizedBox(height: 18),
              const Text('¿Vacunado?', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _vaccinated,
                items: _yesNo
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _vaccinated = v),
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
              const SizedBox(height: 18),
              const Text('Ubicación', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Ciudad, Estado o dirección',
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
              const SizedBox(height: 18),
              const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe a la mascota, su personalidad, necesidades, etc.',
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
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _birthDate != null && _images.isNotEmpty) {
                      // Aquí puedes manejar el envío del formulario
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Mascota puesta en adopción!')),
                      );
                      Navigator.pop(context);
                    } else if (_images.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agrega al menos una foto.')),
                      );
                    } else if (_birthDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecciona la fecha de nacimiento.')),
                      );
                    }
                  },
                  child: const Text('Poner en adopción', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
