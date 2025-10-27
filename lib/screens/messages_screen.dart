import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat_detail_screen.dart';

// Clases de datos para los mensajes y chats
class Message {
  final String text;
  final DateTime time;
  final bool isMe;
  final MessageStatus status;

  Message({
    required this.text,
    required this.time,
    required this.isMe,
    this.status = MessageStatus.sent,
  });
}

enum MessageStatus {
  sent, // Un solo check
  delivered, // Doble check
  read, // Doble check azul
}

class Chat {
  final String name;
  final String imageUrl;
  final List<Message> messages;

  Chat({
    required this.name,
    required this.imageUrl,
    required this.messages,
  });

  Message get lastMessage => messages.isNotEmpty ? messages.last : Message(text: '', time: DateTime.now(), isMe: false);
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para los chats
    final List<Chat> chats = [
      Chat(
        name: 'Anisha Mehra',
        imageUrl: 'https://placehold.co/100x100/A7F0CA/000000?text=AM',
        messages: [
          Message(text: 'Bye! I\'ll see you later.', time: DateTime(2023, 10, 26, 9, 30), isMe: true, status: MessageStatus.read),
        ],
      ),
      Chat(
        name: 'Hiral Shah',
        imageUrl: 'https://placehold.co/100x100/FFD1DC/000000?text=HS',
        messages: [
          Message(text: 'Bye! I\'ll see you later.', time: DateTime(2023, 10, 26, 9, 30), isMe: true, status: MessageStatus.delivered),
        ],
      ),
      Chat(
        name: 'Madhuraa',
        imageUrl: 'https://placehold.co/100x100/CCE3DE/000000?text=M',
        messages: [
          Message(text: 'You\'re now an admin', time: DateTime(2023, 10, 26, 8, 50), isMe: false, status: MessageStatus.sent),
        ],
      ),
      Chat(
        name: 'Lalit Awagune',
        imageUrl: 'https://placehold.co/100x100/FFECB3/000000?text=LA',
        messages: [
          Message(text: 'Bye! I\'ll see you later.', time: DateTime(2023, 10, 26, 8, 05), isMe: true, status: MessageStatus.read),
        ],
      ),
      Chat(
        name: 'Jaylon Magnus',
        imageUrl: 'https://placehold.co/100x100/E0E7FF/000000?text=JM',
        messages: [
          Message(text: 'Bye! I\'ll see you later.', time: DateTime(2023, 10, 26, 8, 45), isMe: false, status: MessageStatus.sent),
        ],
      ),
      Chat(
        name: 'Naresh Gaydhane',
        imageUrl: 'https://placehold.co/100x100/F0F4C3/000000?text=NG',
        messages: [
          Message(text: 'Bye! I\'ll see you later.', time: DateTime(2023, 10, 26, 7, 56), isMe: true, status: MessageStatus.delivered),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat.imageUrl),
                ),
                title: Text(chat.name),
                subtitle: Text(
                  chat.lastMessage.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(chat.lastMessage.time),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    if (chat.lastMessage.isMe) ...[
                      _buildMessageStatusIcon(chat.lastMessage.status, context),
                    ] else if (!chat.lastMessage.isMe && chat.lastMessage.status != MessageStatus.read) ...[
                      // Unread indicator for incoming messages
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '1', // Assuming 1 unread message for simplicity
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(chat: chat),
                    ),
                  );
                },
              ),
              Divider(height: 1, color: Colors.black.withOpacity(0.05)),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildMessageStatusIcon(MessageStatus status, BuildContext context) {
  switch (status) {
    case MessageStatus.sent:
      return const Icon(Icons.check, size: 16, color: Colors.grey);
    case MessageStatus.delivered:
      return const Icon(Icons.done_all, size: 16, color: Colors.grey);
    case MessageStatus.read:
      return Icon(Icons.done_all, size: 16, color: Theme.of(context).primaryColor);
    default:
      return const SizedBox.shrink();
  }
}
