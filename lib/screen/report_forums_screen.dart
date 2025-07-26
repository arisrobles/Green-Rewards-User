import 'package:flutter/material.dart';

class ReportForumScreen extends StatelessWidget {
  const ReportForumScreen({super.key});

  // Example data for forum posts
  final List<Map<String, dynamic>> _forumPosts = const [
    {
      'user': 'Alonso',
      'time': '5 mins ago',
      'content': 'It feels great knowing that by just segregating our waste properly, I\'m helping the environment!',
      'upvotes': 884,
      'downvotes': 1,
    },
    {
      'user': 'Teodora',
      'time': '2 hours ago',
      'content': 'Hi, I\'m new here! I\'m wondering if plastic sachets (like shampoo packets) go under recyclables or residuals? I want to make sure I\'m doing it right so I don\'t lose points. Appreciate any tips from the pros here!',
      'upvotes': 569,
      'downvotes': 2,
    },
    {
      'user': 'Realonda',
      'time': '5 hours ago',
      'content': 'Bringing recyclables directly to the drop-off center gives bonus points!',
      'upvotes': 120,
      'downvotes': 0,
    },
    {
      'user': 'Maria',
      'time': '1 day ago',
      'content': 'Does anyone know where I can dispose of old batteries safely in our barangay?',
      'upvotes': 75,
      'downvotes': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2E7D32),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                    const Icon(Icons.person_outline, color: Colors.white, size: 30),
                  ],
                ),
              ),
              
              // Report Forum Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Report Forum',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 24),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    ),
                  ),
                ),
              ),
              
              // Forum Posts List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  itemCount: _forumPosts.length,
                  itemBuilder: (context, index) {
                    final post = _forumPosts[index];
                    return _buildForumPostCard(post);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForumPostCard(Map<String, dynamic> post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.black54, size: 28),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['user'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post['time'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              post['content'],
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.arrow_upward, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post['upvotes']}', style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 15),
                    const Icon(Icons.arrow_downward, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post['downvotes']}', style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                  ],
                ),
                const Icon(Icons.chat_bubble_outline, size: 22, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}