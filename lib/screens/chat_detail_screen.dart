import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_screen.dart'; // Importa las clases de datos

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.addAll(widget.chat.messages);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(Message(
          text: _messageController.text.trim(),
          time: DateTime.now(),
          isMe: true,
          status: MessageStatus.sent,
        ));
      });
      _messageController.clear();
    }
  }

  void _handleClipButton() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Próximamente: Adjuntar fotos/documentos (máx. 2MB)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.imageUrl),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(widget.chat.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index]; // Mostrar los mensajes en orden cronológico
                return Align(
                  alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message.isMe ? Colors.grey[900] : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16.0),
                        topRight: const Radius.circular(16.0),
                        bottomLeft: Radius.circular(message.isMe ? 16.0 : 4.0),
                        bottomRight: Radius.circular(message.isMe ? 4.0 : 16.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(color: message.isMe ? Colors.white : Colors.black87),
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(message.time),
                              style: TextStyle(
                                color: message.isMe ? Colors.white70 : Colors.grey[600],
                                fontSize: 10.0,
                              ),
                            ),
                            if (message.isMe) ...[
                              const SizedBox(width: 4.0),
                              _buildMessageStatusIcon(message.status),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0 + MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                  onPressed: _handleClipButton,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: Colors.white70);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.white70);
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 14, color: Theme.of(context).colorScheme.secondary);
      default:
        return const SizedBox.shrink();
    }
  }
} 