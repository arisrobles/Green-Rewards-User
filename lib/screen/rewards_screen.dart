import 'package:flutter/material.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  // Example data for rewards
  final List<Map<String, dynamic>> _rewards = [
    {
      'id': 'pencil',
      'name': 'Pencil (1pc)',
      'points': 500,
      'description': '1 piece of Number 2 Mongol Pencil with non-smudge eraser. Perfect for school or office use.',
      'image': 'https://via.placeholder.com/150/FFD700/000000?query=two+pencils+illustration', // Placeholder image
      'isExpanded': false,
      'quantity': 1,
    },
    {
      'id': 'rice',
      'name': 'Rice (1kg)',
      'points': 1500,
      'description': '1 kilogram of premium white rice, perfect for daily meals. Sourced locally for freshness.',
      'image': 'https://via.placeholder.com/150/8B4513/FFFFFF?query=sack+of+rice+illustration', // Placeholder image
      'isExpanded': false,
      'quantity': 1,
    },
    {
      'id': 'notebook',
      'name': 'Notebook (1pc)',
      'points': 700,
      'description': 'A standard size notebook with 80 leaves, ideal for school or office use. Eco-friendly paper.',
      'image': 'https://via.placeholder.com/150/ADD8E6/000000?query=notebook+illustration', // Placeholder image
      'isExpanded': false,
      'quantity': 1,
    },
    {
      'id': 'soap',
      'name': 'Laundry Soap (1pc)',
      'points': 1000,
      'description': 'One bar of laundry soap, effective for hand washing clothes. Biodegradable formula.',
      'image': 'https://via.placeholder.com/150/FFC0CB/000000?query=laundry+soap+bar+illustration', // Placeholder image
      'isExpanded': false,
      'quantity': 1,
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF43EA7D), // Vibrant light green
              Color(0xFF4CAF50), // Main green
              Color(0xFF388E3C), // Medium green
            ],
            stops: [0.0, 0.6, 1.0],
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
              
              // Rewards Title and Point Balance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rewards',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your Point Balance: 123459',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
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
              
              // Rewards List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  itemCount: _rewards.length,
                  itemBuilder: (context, index) {
                    final reward = _rewards[index];
                    return _buildRewardCard(reward);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward) {
    return GestureDetector(
      onTap: () {
        setState(() {
          reward['isExpanded'] = !reward['isExpanded'];
        });
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    reward['image'],
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(color: Colors.grey, thickness: 0.8),
              const SizedBox(height: 15),
              Text(
                reward['name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${reward['points']} pts',
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (reward['isExpanded']) ...[
                const SizedBox(height: 15),
                Text(
                  reward['description'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.grey, size: 20),
                            onPressed: () {
                              setState(() {
                                if (reward['quantity'] > 1) reward['quantity']--;
                              });
                            },
                          ),
                          Text(
                            '${reward['quantity']}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.grey, size: 20),
                            onPressed: () {
                              setState(() {
                                reward['quantity']++;
                              });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text('Qnty', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle order now
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 3,
                        shadowColor: const Color(0xFF2196F3).withOpacity(0.4),
                      ),
                      child: const Text(
                        'Order Now',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}