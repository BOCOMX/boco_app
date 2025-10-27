import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'settings_screen.dart';
import 'pet_activities_screen.dart';
import 'dart:async';

const Color primaryColor = Color(0xFF1C1C1C);
const Color secondaryColor = Color(0xFFFF678D);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> _pets = [];
  List<Map<String, dynamic>> _reminders = [];

  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petAgeController = TextEditingController();
  String _selectedType = 'Perro';
  String _selectedBreed = 'Labrador';
  String _selectedGender = 'Macho';
  String _selectedAgeUnit = 'Años';
  File? _selectedPetImage;

  final TextEditingController _reminderController = TextEditingController();
  DateTime? _selectedReminderDate;
  TimeOfDay? _selectedReminderTime;

  final ImagePicker _picker = ImagePicker();

  final Map<String, List<String>> petBreeds = {
    'Perro': ['Labrador', 'Bulldog', 'Pug'],
    'Gato': ['Persa', 'Siamés', 'Bengalí'],
    'Ave': ['Canario', 'Loro', 'Periquito'],
  };

  TextEditingController _otherTypeController = TextEditingController();
  TextEditingController _breedController = TextEditingController();
  bool _hasBreed = false;
  DateTime? _selectedPetBirthDate;

  int _selectedTab = 0; // 0: Mascotas, 1: Calendario, 2: Guardado

  Timer? _reminderTimer;

  @override
  void initState() {
    super.initState();
    _startReminderTimer();
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }

  void _startReminderTimer() {
    _reminderTimer?.cancel();
    _reminderTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_selectedTab == 1 && mounted) setState(() {});
    });
  }

  void _resetForm() {
    _petNameController.clear();
    _breedController.clear();
    _otherTypeController.clear();
    _selectedType = 'Perro';
    _selectedGender = 'Macho';
    _hasBreed = false;
    _selectedPetImage = null;
    _selectedPetBirthDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildProfileTabs(),
            const SizedBox(height: 18),
            if (_selectedTab == 0) _buildPetsGrid(),
            if (_selectedTab == 1) _buildCalendarSection(),
            if (_selectedTab == 2) _buildSavedSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: const DecorationImage(
                    image: NetworkImage('https://placehold.co/100x100'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Fabián",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "fartigas27@gmail.com",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Aquí irá la lógica de cerrar sesión
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.favorite, color: _selectedTab == 0 ? secondaryColor : Colors.grey[500], size: 24),
          onPressed: () => setState(() => _selectedTab = 0),
          tooltip: 'Mascotas',
        ),
        const SizedBox(width: 32),
        IconButton(
          icon: Icon(Icons.calendar_today, color: _selectedTab == 1 ? secondaryColor : Colors.grey[500], size: 24),
          onPressed: () => setState(() => _selectedTab = 1),
          tooltip: 'Calendario',
        ),
        const SizedBox(width: 32),
        IconButton(
          icon: Icon(Icons.bookmark, color: _selectedTab == 2 ? secondaryColor : Colors.grey[500], size: 24),
          onPressed: () => setState(() => _selectedTab = 2),
          tooltip: 'Guardado',
        ),
      ],
    );
  }

  Widget _buildPetsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tus Mascotas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: secondaryColor, size: 28),
              onPressed: () => _showAddPetDialog(),
              tooltip: 'Añadir mascota',
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_pets.isEmpty)
          const Center(child: Text('No tienes mascotas registradas.')),
        if (_pets.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: _pets.length,
            itemBuilder: (context, index) {
              return _buildPetCard(_pets[index]);
            },
          ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Calendario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: secondaryColor, size: 28),
              onPressed: _showAddReminderDialog,
              tooltip: 'Añadir recordatorio',
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_reminders.isEmpty)
          const Center(child: Text('No tienes recordatorios.')),
        if (_reminders.isNotEmpty)
          Column(
            children: _reminders.map((reminder) => _buildReminderCard(reminder)).toList(),
          ),
      ],
    );
  }

  Widget _buildSavedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Publicaciones guardadas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 48), // Simula el espacio del botón
          ],
        ),
        const SizedBox(height: 10),
        Center(child: Text('Aquí irán las publicaciones guardadas.')),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.add_circle, color: secondaryColor, size: 28),
          onPressed: onAdd,
          tooltip: 'Añadir $title',
        ),
      ],
    );
  }

  Widget _buildPetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Tus Mascotas", () => _showAddPetDialog()),
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            clipBehavior: Clip.none,
            children: _pets.map((pet) => Container(
              margin: const EdgeInsets.only(right: 14),
              child: _buildPetCard(pet),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    String edad = '';
    if (pet['birthDate'] != null && pet['birthDate'] is DateTime) {
      final now = DateTime.now();
      final birth = pet['birthDate'] as DateTime;
      int years = now.year - birth.year;
      int months = now.month - birth.month;
      if (months < 0) {
        years--;
        months += 12;
      }
      if (years > 0) {
        edad = '$years año${years > 1 ? 's' : ''}';
        if (months > 0) {
          edad += ' y $months mes${months > 1 ? 'es' : ''}';
        }
      } else if (months > 0) {
        edad = '$months mes${months > 1 ? 'es' : ''}';
      } else {
        edad = 'Menos de 1 mes';
      }
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetActivitiesScreen(pet: pet),
          ),
        );
      },
      child: Container(
      width: 180,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: pet['image'] != null
                ? Image.file(
                    pet['image'],
                    width: 180,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 180,
                    height: 120,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.pets,
                      color: Colors.grey[400],
                      size: 50,
                    ),
                  ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        pet['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 20,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showAddPetDialog(pet: pet);
                          }
                          if (value == 'delete') {
                            setState(() => _pets.remove(pet));
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text("Editar"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20),
                                SizedBox(width: 8),
                                Text("Eliminar"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                    edad,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  void _showAddPetDialog({Map<String, dynamic>? pet}) {
    _resetForm();

    if (pet != null) {
      _petNameController.text = pet['name'];
      _selectedType = pet['type'];
      _selectedGender = pet['gender'];
      if (pet['image'] != null) {
        _selectedPetImage = pet['image'];
      }
      if (pet['type'] == 'Otro') {
        _otherTypeController.text = pet['type'];
      }
      if (pet['breed'] != 'No aplica' && pet['breed'] != 'No tiene raza / Mestizo') {
        _hasBreed = true;
        _breedController.text = pet['breed'];
      } else {
        _hasBreed = false;
        _breedController.clear();
        }
      if (pet['birthDate'] != null) {
        _selectedPetBirthDate = pet['birthDate'];
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width * 0.9;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: StatefulBuilder(
                builder: (context, setStateModal) {
                  return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                              setStateModal(() {
                            _selectedPetImage = File(pickedFile.path);
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _selectedPetImage != null ? FileImage(_selectedPetImage!) : null,
                        child: _selectedPetImage == null
                            ? const Icon(Icons.add_a_photo, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _petNameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      textInputAction: TextInputAction.done,
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      items: ['Perro', 'Gato', 'Ave', 'Reptil', 'Pez', 'Roedor', 'Otro'].map((String type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                            setStateModal(() {
                          _selectedType = newValue!;
                        });
                      },
                    ),
                    if (_selectedType == 'Otro')
                      TextField(
                        controller: _otherTypeController,
                        decoration: const InputDecoration(labelText: 'Especificar tipo de mascota'),
                        textInputAction: TextInputAction.done,
                      ),
                    if (_selectedType == 'Perro' || _selectedType == 'Gato')
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text('¿Tiene raza específica?'),
                              Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                  value: _hasBreed,
                                  onChanged: (value) {
                                        setStateModal(() {
                                      _hasBreed = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_hasBreed)
                            TextField(
                              controller: _breedController,
                              decoration: const InputDecoration(labelText: 'Raza (especificar)'),
                              textInputAction: TextInputAction.done,
                            ),
                          if (!_hasBreed)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('No tiene raza / Mestizo', 
                                style: TextStyle(color: Colors.grey)),
                            ),
                        ],
                      ),
                        // Fecha de nacimiento
                        const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedPetBirthDate ?? DateTime.now(),
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime.now(),
                                    cancelText: 'Cancelar',
                                    confirmText: 'Guardar',
                                    locale: const Locale('es', 'MX'),
                                  );
                                  if (pickedDate != null) {
                                    setStateModal(() {
                                      _selectedPetBirthDate = pickedDate;
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                          child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Fecha de nacimiento (aprox.)',
                                      hintText: 'Seleccionar fecha',
                                    ),
                                    controller: TextEditingController(
                                      text: _selectedPetBirthDate != null
                                          ? DateFormat('dd/MM/yyyy').format(_selectedPetBirthDate!)
                                          : '',
                                    ),
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(labelText: 'Género'),
                      items: ['Macho', 'Hembra'].map((String gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                            setStateModal(() {
                          _selectedGender = newValue!;
                        });
                      },
                    ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                TextButton(
                  onPressed: () {
                    _resetForm();
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    if (pet != null) {
                      _editPet(pet);
                    } else {
                      _addPet();
                    }
                  },
                  child: Text(pet == null ? "Guardar" : "Actualizar"),
                ),
              ],
                        ),
                      ],
                    ),
            );
          },
              ),
            ),
          ),
        );
      },
    );
  }

  void _addPet() {
    if (_petNameController.text.isEmpty || 
        _selectedPetBirthDate == null ||
        ((_selectedType == 'Perro' || _selectedType == 'Gato') && _hasBreed && _breedController.text.isEmpty) ||
        (_selectedType == 'Otro' && _otherTypeController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() {
      _pets.add({
        'name': _petNameController.text,
        'type': _selectedType == 'Otro' ? _otherTypeController.text : _selectedType,
        'breed': (_selectedType == 'Perro' || _selectedType == 'Gato') 
            ? (_hasBreed ? _breedController.text : 'No tiene raza / Mestizo')
            : 'No aplica',
        'birthDate': _selectedPetBirthDate,
        'gender': _selectedGender,
        'image': _selectedPetImage,
      });
    });

    _resetForm();
    Navigator.pop(context);
  }

  void _editPet(Map<String, dynamic> oldPet) {
    if (_petNameController.text.isEmpty || 
        _selectedPetBirthDate == null ||
        ((_selectedType == 'Perro' || _selectedType == 'Gato') && _hasBreed && _breedController.text.isEmpty) ||
        (_selectedType == 'Otro' && _otherTypeController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() {
      int index = _pets.indexOf(oldPet);
      if (index != -1) {
        _pets[index] = {
          'name': _petNameController.text,
          'type': _selectedType == 'Otro' ? _otherTypeController.text : _selectedType,
          'breed': (_selectedType == 'Perro' || _selectedType == 'Gato') 
              ? (_hasBreed ? _breedController.text : 'No tiene raza / Mestizo')
              : 'No aplica',
          'birthDate': _selectedPetBirthDate,
          'gender': _selectedGender,
          'image': _selectedPetImage ?? oldPet['image'],
        };
      }
    });

    _resetForm();
    Navigator.pop(context);
  }

  Widget _buildRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Recordatorios", () => _showAddReminderDialog()),
        Column(
          children: _reminders.map((reminder) => _buildReminderCard(reminder)).toList(),
        ),
      ],
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    final DateTime date = reminder['date'];
    final String title = reminder['title'];
    final String? pet = reminder['pet'];
    final Duration diff = date.difference(DateTime.now());
    String tiempo = '';
    if (diff.inSeconds <= 60 && diff.inSeconds >= -60) {
      tiempo = 'Justo ahora';
    } else if (diff.inMinutes < 60 && diff.inMinutes > 0) {
      tiempo = 'Dentro de: ${diff.inMinutes} minuto${diff.inMinutes > 1 ? 's' : ''}';
    } else if (diff.inHours < 24 && diff.inHours > 0) {
      tiempo = 'Dentro de: ${diff.inHours} hora${diff.inHours > 1 ? 's' : ''}';
    } else if (diff.inDays > 0) {
      tiempo = 'Dentro de: ${diff.inDays} día${diff.inDays > 1 ? 's' : ''}';
    } else if (diff.isNegative) {
      tiempo = 'Ya pasó';
    }
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.calendar_today, color: secondaryColor, size: 24),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pet != null ? '$title "$pet"' : title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tiempo,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: const PopupMenuThemeData(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              icon: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_vert, color: Colors.grey, size: 16),
              ),
              onSelected: (selected) {
                if (selected == 'edit') {
                  _showEditReminderDialog(reminder);
                } else if (selected == 'done' || selected == 'delete') {
                  setState(() {
                    _reminders.remove(reminder);
                  });
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, size: 20),
                    title: Text('Editar'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'done',
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outline, size: 20),
                    title: Text('Realizado'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, size: 20),
                    title: Text('Eliminar'),
                  ),
                ),
              ],
              offset: const Offset(0, 8),
              elevation: 8,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddReminderDialog() {
    final TextEditingController _titleController = TextEditingController();
    DateTime? _selectedDate;
    TimeOfDay? _selectedTime;
    String? _selectedPet;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Nuevo recordatorio'),
          content: StatefulBuilder(
            builder: (context, setStateModal) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Nombre del recordatorio'),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setStateModal(() => _selectedDate = picked);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Fecha',
                            hintText: 'Seleccionar fecha',
                          ),
                          controller: TextEditingController(
                            text: _selectedDate != null
                                ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                                : '',
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setStateModal(() => _selectedTime = picked);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Hora (opcional)',
                            hintText: 'Seleccionar hora',
                          ),
                          controller: TextEditingController(
                            text: _selectedTime != null
                                ? _selectedTime!.format(context)
                                : '',
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_pets.isNotEmpty)
                      DropdownButtonFormField<String>(
                        value: _selectedPet,
                        decoration: const InputDecoration(labelText: 'Mascota (opcional)'),
                        items: _pets.map<DropdownMenuItem<String>>((pet) {
                          return DropdownMenuItem<String>(
                            value: pet['name'] as String,
                            child: Text(pet['name'] as String),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setStateModal(() => _selectedPet = value);
                        },
                      ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor, foregroundColor: Colors.white),
              onPressed: () {
                if (_titleController.text.isNotEmpty && _selectedDate != null) {
                  DateTime dateTime = _selectedDate!;
                  if (_selectedTime != null) {
                    dateTime = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    );
                  }
                  setState(() {
                    _reminders.add({
                      'title': _titleController.text,
                      'date': dateTime,
                      'pet': _selectedPet,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditReminderDialog(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar recordatorio'),
        content: const Text('Aquí puedes implementar la edición del recordatorio.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}