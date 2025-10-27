import 'package:flutter/material.dart';
import 'post_detail_screen.dart';

const Color secondaryColor = Color(0xFFFF678D);

class Post {
  final String imageUrl;
  final String title;
  final String category;
  final DateTime date;
  final String content;
  final String author;
  final String authorImage;
  final int likes;
  final int reads;
  final List<Map<String, String>> comments;
  final bool isLiked;
  final bool isBookmarked;

  Post({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.date,
    required this.content,
    required this.author,
    required this.authorImage,
    this.likes = 0,
    this.reads = 0,
    this.comments = const [],
    this.isLiked = false,
    this.isBookmarked = false,
  });
}

class Event {
  final String imageUrl;
  final String title;
  final DateTime dateTime;
  final String place;
  final String content;

  Event({
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.place,
    required this.content,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0; // 0: Noticias y Consejos, 1: Eventos
  String selectedCategory = 'Todas';

  final List<String> categories = [
    'Todas',
    'Salud y cuidado animal',
    'Entretenimiento',
    'Entrenamiento',
    'Nutrición',
    'Viajes',
  ];

  final List<Post> posts = [
    Post(
      imageUrl: 'https://placehold.co/400x200/FF678D/FFFFFF?text=Salud',
      title: 'Consejos para la salud de tu mascota',
      category: 'Salud y cuidado animal',
      date: DateTime.now().subtract(const Duration(days: 1)),
      content: 'Contenido del post de salud...',
      author: 'BOCO',
      authorImage: 'https://placehold.co/100x100',
      likes: 42,
      reads: 123,
      comments: [
        {'author': 'Ana', 'text': '¡Muy buen post!'},
        {'author': 'Carlos', 'text': 'Gracias por los consejos.'},
      ],
    ),
    Post(
      imageUrl: 'https://placehold.co/400x200/FF678D/FFFFFF?text=Entretenimiento',
      title: 'Juegos para entretener a tu perro',
      category: 'Entretenimiento',
      date: DateTime.now().subtract(const Duration(days: 2)),
      content: 'Contenido de entretenimiento...',
      author: 'BOCO',
      authorImage: 'https://placehold.co/100x100',
      likes: 28,
      reads: 89,
      comments: [
        {'author': 'María', 'text': '¡Excelentes ideas!'},
      ],
    ),
    // Post adicional 1
    Post(
      imageUrl: 'https://placehold.co/400x200/FF678D/FFFFFF?text=Nutrición',
      title: 'Alimentación balanceada para gatos',
      category: 'Nutrición',
      date: DateTime.now().subtract(const Duration(days: 3)),
      content: 'Consejos sobre nutrición felina...',
      author: 'BOCO',
      authorImage: 'https://placehold.co/100x100',
      likes: 15,
      reads: 60,
      comments: [
        {'author': 'Luis', 'text': '¡Muy útil!'},
      ],
    ),
    // Post adicional 2
    Post(
      imageUrl: 'https://placehold.co/400x200/FF678D/FFFFFF?text=Viajes',
      title: 'Viajar con tu mascota: tips esenciales',
      category: 'Viajes',
      date: DateTime.now().subtract(const Duration(days: 4)),
      content: 'Todo lo que necesitas saber para viajar con tu mascota...',
      author: 'BOCO',
      authorImage: 'https://placehold.co/100x100',
      likes: 22,
      reads: 75,
      comments: [
        {'author': 'Sofía', 'text': '¡Me encantó!'},
      ],
    ),
  ];

  final List<Event> events = [
    Event(
      imageUrl: 'https://placehold.co/400x200/FF678D/FFFFFF?text=Adopción',
      title: 'Feria de adopción',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      place: 'Parque Central',
      content: 'Detalles del evento...',
    ),
    Event(
      imageUrl: 'https://placehold.co/400x200/FF678D/FFFFFF?text=Caminata',
      title: 'Caminata canina',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      place: 'Plaza Mayor',
      content: 'Detalles de la caminata...',
    ),
    // Agrega más eventos de ejemplo aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 26),
        _buildCustomTabBar(),
        const SizedBox(height: 18),
        if (selectedTab == 0) _buildCategoryFilter(),
        Expanded(
          child: selectedTab == 0 ? _buildPostsTab() : _buildEventsTab(),
        ),
      ],
    );
  }

  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => setState(() => selectedTab = 0),
            child: Row(
              children: [
                Icon(Icons.grid_on,
                  color: selectedTab == 0 ? secondaryColor : Colors.grey[500],
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'PUBLICACIONES',
                  style: TextStyle(
                    color: selectedTab == 0 ? secondaryColor : Colors.grey[500],
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Container(
            height: 18,
            width: 1.5,
            color: Colors.grey[400],
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () => setState(() => selectedTab = 1),
            child: Row(
              children: [
                Icon(Icons.event,
                  color: selectedTab == 1 ? secondaryColor : Colors.grey[500],
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'EVENTOS',
                  style: TextStyle(
                    color: selectedTab == 1 ? secondaryColor : Colors.grey[500],
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isActive = selectedCategory == cat;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              showCheckmark: false,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isActive)
                    const Icon(Icons.check, color: Colors.white, size: 18),
                  if (isActive) const SizedBox(width: 4),
                  Text(
                    cat,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              selected: isActive,
              selectedColor: secondaryColor,
              backgroundColor: Colors.white,
              elevation: isActive ? 4 : 1,
              shadowColor: Colors.grey.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: isActive ? secondaryColor : Colors.grey[300]!,
                  width: 1.2,
                ),
              ),
              onSelected: (_) {
                setState(() {
                  selectedCategory = cat;
                });
              },
            ),
          );
        },
      ),
    );
  }

  double _textWidth(String text, double fontSize) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  Widget _buildPostsTab() {
    List<Post> filteredPosts = selectedCategory == 'Todas'
        ? posts
        : posts.where((p) => p.category == selectedCategory).toList();
    filteredPosts.sort((a, b) => b.date.compareTo(a.date));
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: ListView.builder(
        key: ValueKey<String>(selectedCategory),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              post.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth - 54, // Deja espacio para el botón y separación
                            ),
                            child: Text(
                              post.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.category,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(
                          title: post.title,
                          imageUrl: post.imageUrl,
                          content: post.content,
                          author: post.author,
                          authorImage: post.authorImage,
                          initialLikes: post.likes,
                          initialReads: post.reads,
                          initialComments: post.comments,
                          initialIsLiked: post.isLiked,
                          initialIsBookmarked: post.isBookmarked,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: secondaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_outward, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    List<Event> sortedEvents = List.from(events);
    sortedEvents.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        final isPast = event.dateTime.isBefore(DateTime.now());
        return _buildEventCard(event, isPast);
      },
    );
  }

  Widget _buildEventCard(Event event, bool isPast) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              event.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (!isPast) ...[
                        Text(
                          '${_formatDate(event.dateTime)} · ${_formatTime(event.dateTime)}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        Text(
                          event.place,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ] else ...[
                        const Text(
                          'Evento finalizado',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
