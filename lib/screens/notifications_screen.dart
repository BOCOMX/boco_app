import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Lista de notificaciones con su estado
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'imagePath': 'assets/images/perfil BOCO.png',
      'title': '¡Bienvenido a BOCO!',
      'text': 'Un texto de bienvenida',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isUnread': false,
      'type': 'welcome',
    },
  ];

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n['id'] == id);
      notification['isUnread'] = false;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isUnread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Todas las notificaciones marcadas como leídas',
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

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Marcar como leída si no lo está
    if (notification['isUnread']) {
      _markAsRead(notification['id']);
    }

    // Manejar la acción según el tipo de notificación
    switch (notification['type']) {
      case 'welcome':
        _showWelcomeModal(context);
        break;
      // Aquí se pueden agregar más tipos de notificaciones
    }
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inDays == 1) {
      return 'Ayer ${DateFormat('hh:mm a').format(date)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat('EEEE').format(date)} ${DateFormat('hh:mm a').format(date)}';
    } else {
      return DateFormat('EEEE d \'de\' MMMM yyyy').format(date);
    }
  }

  void _showWelcomeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/perfil BOCO.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Bienvenido a BOCO!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Estamos emocionados de tenerte aquí. BOCO es tu compañero perfecto para el cuidado de tus mascotas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('¡Comenzar!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            onSelected: (value) {
              if (value == 'mark_all_read') {
                _markAllAsRead();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Text('Marcar todo como leído'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: _notifications.map((notification) => _NotificationTile(
          imagePath: notification['imagePath'],
          title: notification['title'],
          text: notification['text'],
          time: _getRelativeTime(notification['time']),
          isUnread: notification['isUnread'],
          onTap: () => _handleNotificationTap(notification),
        )).toList(),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String text;
  final String time;
  final bool isUnread;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.imagePath,
    required this.title,
    required this.text,
    required this.time,
    this.isUnread = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (isUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
