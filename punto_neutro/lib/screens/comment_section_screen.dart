import 'package:flutter/material.dart';

class CommentSectionScreen extends StatefulWidget {
  const CommentSectionScreen({Key? key}) : super(key: key);

  @override
  State<CommentSectionScreen> createState() => _CommentSectionScreenState();
}

class _CommentSectionScreenState extends State<CommentSectionScreen> {
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, String>> _comments = [
    {
      "user": "Anonymous user",
      "comment":
          "Excellent article. It's reassuring to know that tools exist to combat misinformation. The research seems very solid and well-documented.",
      "time": "2 hours ago"
    },
    {
      "user": "Anonymous user",
      "comment":
          "When will this technology be available to the general public? The information seems credible but needs more details about implementation.",
      "time": "4 hours ago"
    },
    {
      "user": "Anonymous user",
      "comment":
          "This sounds too good to be true. 98% accuracy seems exaggerated and there are no specific details about the testing methodology.",
      "time": "6 hours ago"
    },
  ];

  void _postComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(0, {
        "user": "You",
        "comment": _commentController.text.trim(),
        "time": "Just now"
      });
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Comments (18)'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Lista de comentarios
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _comments.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return ListTile(
                  leading: const Icon(Icons.person_outline, color: Colors.black),
                  title: Text(
                    comment["user"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(comment["comment"]!),
                  trailing: Text(
                    comment["time"]!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            ),
          ),

          // Barra para escribir nuevo comentario
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: _postComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
