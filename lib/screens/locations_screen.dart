import 'package:flutter/material.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Parque Canino Central',
      'type': 'Parque',
      'address': 'Av. Principal 123, Centro',
      'rating': 4.5,
      'distance': '0.8 km',
      'imageUrl': 'https://placehold.co/600x300/FF678D/FFF?text=Parque',
      'description': 'Parque amplio con áreas separadas para perros grandes y pequeños',
      'amenities': ['Agua', 'Sombra', 'Veterinario cercano'],
    },
    {
      'name': 'Café Mascotas',
      'type': 'Café',
      'address': 'Calle Comercial 456',
      'rating': 4.2,
      'distance': '1.2 km',
      'imageUrl': 'https://placehold.co/600x300/FF678D/FFF?text=Café',
      'description': 'Café con terraza pet-friendly y menú especial para mascotas',
      'amenities': ['Terraza', 'Menú mascotas', 'WiFi'],
    },
    {
      'name': 'Veterinaria 24/7',
      'type': 'Veterinaria',
      'address': 'Plaza Mayor 789',
      'rating': 4.8,
      'distance': '2.1 km',
      'imageUrl': 'https://placehold.co/600x300/FF678D/FFF?text=Veterinaria',
      'description': 'Clínica veterinaria con atención las 24 horas',
      'amenities': ['24/7', 'Emergencias', 'Farmacia'],
    },
    {
      'name': 'Tienda de Mascotas Happy Pets',
      'type': 'Tienda',
      'address': 'Centro Comercial Plaza Norte',
      'rating': 4.0,
      'distance': '3.5 km',
      'imageUrl': 'https://placehold.co/600x300/FF678D/FFF?text=Tienda',
      'description': 'Tienda especializada en productos para mascotas',
      'amenities': ['Productos premium', 'Asesoría', 'Delivery'],
    },
  ];

  String _selectedFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Parque', 'Café', 'Veterinaria', 'Tienda'];

  @override
  Widget build(BuildContext context) {
    final filteredLocations = _selectedFilter == 'Todos'
        ? _locations
        : _locations.where((location) => location['type'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // Separación superior
          const SizedBox(height: 18),
          // Filtros tipo chip
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected)
                          const Icon(Icons.check, color: Colors.white, size: 18),
                        if (isSelected) const SizedBox(width: 4),
                        Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFF678D),
                    backgroundColor: Colors.white,
                    elevation: isSelected ? 4 : 1,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFFFF678D) : Colors.grey[300]!,
                        width: 1.2,
                      ),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Lista de lugares
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                return _buildLocationCard(location);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[200]!, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.13),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del lugar
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              location['imageUrl'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
                  ),
                );
              },
            ),
          ),
          // Información del lugar
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        location['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C1C1C),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location['rating'].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                // Dirección y distancia
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location['address'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        location['distance'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Descripción
                Text(
                  location['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                // Amenities
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: location['amenities'].map<Widget>((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        amenity,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.map, size: 16, color: Colors.white),
                        label: const Text('Ver en mapa'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF678D),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('Llamar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF678D),
                          side: const BorderSide(color: Color(0xFFFF678D)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }
}
