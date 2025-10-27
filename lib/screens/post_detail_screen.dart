import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const Color secondaryColor = Color(0xFFFF678D);

class PostDetailScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String content;
  final String author;
  final String authorImage;
  final int initialLikes;
  final int initialReads;
  final List<Map<String, String>> initialComments;
  final bool initialIsLiked;
  final bool initialIsBookmarked;

  const PostDetailScreen({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.author,
    required this.authorImage,
    this.initialLikes = 0,
    this.initialReads = 0,
    this.initialComments = const [],
    this.initialIsLiked = false,
    this.initialIsBookmarked = false,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late bool isLiked;
  late int likes;
  late int reads;
  late bool isBookmarked;
  late List<Map<String, String>> comments;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialIsLiked;
    likes = widget.initialLikes;
    reads = widget.initialReads;
    isBookmarked = widget.initialIsBookmarked;
    comments = List.from(widget.initialComments);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _formatDate(DateTime.now()),
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 14,
                    child: Material(
                      color: isBookmarked ? secondaryColor : Colors.white,
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          setState(() {
                            isBookmarked = !isBookmarked;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.bookmark_border,
                            color: isBookmarked ? Colors.white : Colors.black,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(widget.authorImage),
                      radius: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.author,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Text(
                  widget.content,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoBox(icon: Icons.remove_red_eye, label: '$reads', sub: 'Lecturas'),
                    _InfoBox(icon: Icons.favorite, label: '$likes', sub: 'Me gusta'),
                    _InfoBox(icon: Icons.comment, label: '${comments.length}', sub: 'Comentarios'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLiked ? secondaryColor : Colors.grey[200],
                      foregroundColor: isLiked ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Icon(
                      isLiked ? Icons.thumb_down : Icons.thumb_up,
                      color: isLiked ? Colors.white : Colors.black54,
                    ),
                    label: Text(isLiked ? 'Ya no me gusta' : 'Me gusta'),
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                        likes += isLiked ? 1 : -1;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Comentarios',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: comments.map((c) => _CommentTile(author: c['author']!, text: c['text']!)).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Escribe un comentario...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 2,
                        ),
                        onPressed: () {
                          if (_commentController.text.trim().isNotEmpty) {
                            setState(() {
                              comments.add({
                                'author': 'Tú',
                                'text': _commentController.text.trim(),
                              });
                              _commentController.clear();
                            });
                          }
                        },
                        child: const Icon(Icons.send, size: 22, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  const _InfoBox({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700], size: 22),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(sub, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String author;
  final String text;
  const _CommentTile({required this.author, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 14,
            child: Text(author[0], style: const TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(author, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(text, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 