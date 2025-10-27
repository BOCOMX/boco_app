import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color secondaryColor = Color(0xFFFF678D);

class PetActivitiesScreen extends StatefulWidget {
  final Map<String, dynamic> pet;

  const PetActivitiesScreen({
    Key? key,
    required this.pet,
  }) : super(key: key);

  @override
  State<PetActivitiesScreen> createState() => _PetActivitiesScreenState();
}

class _PetActivitiesScreenState extends State<PetActivitiesScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _activities = [];
  List<Map<String, dynamic>> _completedActivities = [];
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    // Simulamos la carga de actividades desde la IA
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _activities = _generateActivities();
        _isLoading = false;
      });
    });
  }

  void _toggleActivityCompletion(Map<String, dynamic> activity) {
    setState(() {
      if (_activities.contains(activity)) {
        _activities.remove(activity);
        _completedActivities.add({
          ...activity,
          'completedAt': DateTime.now(),
        });
      } else {
        _completedActivities.remove(activity);
        _activities.add({
          ...activity,
          'completedAt': null,
        });
      }
    });
  }

  List<Map<String, dynamic>> _generateActivities() {
    final pet = widget.pet;
    final activities = <Map<String, dynamic>>[];
    
    // Calculamos la edad en años para recomendaciones más precisas
    int ageInYears = 0;
    if (pet['birthDate'] != null) {
      final now = DateTime.now();
      final birth = pet['birthDate'] as DateTime;
      ageInYears = now.year - birth.year;
    }

    // Actividades según el tipo de mascota
    if (pet['type'] == 'Perro') {
      activities.addAll([
        {
          'title': 'Paseo diario',
          'description': 'Un paseo de 30 minutos ayudará a mantener a ${pet['name']} activo y feliz.',
          'icon': Icons.directions_walk,
          'frequency': 'Diario',
          'duration': '30 minutos',
        },
        {
          'title': 'Juego de pelota',
          'description': 'Lanzar la pelota y que ${pet['name']} la traiga es un excelente ejercicio.',
          'icon': Icons.sports_soccer,
          'frequency': '3 veces por semana',
          'duration': '20 minutos',
        },
        {
          'title': 'Entrenamiento básico',
          'description': 'Practicar comandos básicos como "sentado" y "quieto".',
          'icon': Icons.school,
          'frequency': 'Diario',
          'duration': '15 minutos',
        },
      ]);
    } else if (pet['type'] == 'Gato') {
      activities.addAll([
        {
          'title': 'Juego con láser',
          'description': 'Usar un puntero láser para que ${pet['name']} lo persiga.',
          'icon': Icons.flash_on,
          'frequency': 'Diario',
          'duration': '15 minutos',
        },
        {
          'title': 'Juguetes interactivos',
          'description': 'Proporcionar juguetes que estimulen el instinto de caza.',
          'icon': Icons.toys,
          'frequency': 'Diario',
          'duration': '20 minutos',
        },
      ]);
    }

    // Actividades específicas según la raza
    if (pet['breed'] != 'No tiene raza / Mestizo' && pet['breed'] != 'No aplica') {
      activities.add({
        'title': 'Actividad específica para ${pet['breed']}',
        'description': 'Actividad especial recomendada para la raza ${pet['breed']}.',
        'icon': Icons.pets,
        'frequency': '2 veces por semana',
        'duration': '45 minutos',
      });
    }

    // Actividades según la edad
    if (ageInYears < 1) {
      activities.add({
        'title': 'Socialización',
        'description': 'Exponer a ${pet['name']} a diferentes personas y situaciones.',
        'icon': Icons.people,
        'frequency': 'Diario',
        'duration': '20 minutos',
      });
    } else if (ageInYears > 7) {
      activities.add({
        'title': 'Ejercicio suave',
        'description': 'Actividades de bajo impacto para mantener a ${pet['name']} activo.',
        'icon': Icons.fitness_center,
        'frequency': 'Diario',
        'duration': '15 minutos',
      });
    }

    return activities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Actividades para ${widget.pet['name']}',
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Sección de actividades pendientes
                if (_activities.isNotEmpty) ...[
                  const Text(
                    'Actividades pendientes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._activities.map((activity) => _buildActivityCard(activity, false)),
                ],
                
                // Sección de actividades completadas
                if (_completedActivities.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => setState(() => _showCompleted = !_showCompleted),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Actividades completadas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          _showCompleted ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                  if (_showCompleted) ...[
                    const SizedBox(height: 16),
                    ..._completedActivities.map((activity) => _buildActivityCard(activity, true)),
                  ],
                ],
              ],
            ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: (value) => _toggleActivityCompletion(activity),
              activeColor: secondaryColor,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(activity['icon'], color: secondaryColor),
            ),
          ],
        ),
        title: Text(
          activity['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isCompleted ? Colors.grey[600] : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              activity['description'],
              style: TextStyle(
                color: isCompleted ? Colors.grey[600] : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          activity['frequency'],
                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          activity['duration'],
                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Completada ${DateFormat('dd/MM').format(activity['completedAt'])}',
                            style: TextStyle(color: Colors.green[700], fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 