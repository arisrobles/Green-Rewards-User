import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<Map<String, dynamic>> _transactionsData = [
    {'date': 'July 1', 'action': 'recycled', 'points': 50},
    {'date': 'June 23', 'action': 'availed pencil', 'points': -500},
    {'date': 'June 16', 'action': 'recycled', 'points': 50},
    {'date': 'June 11', 'action': 'segregated', 'points': 60},
    {'date': 'June 4', 'action': 'recycled', 'points': 50},
    {'date': 'May 27', 'action': 'recycled', 'points': 50},
    {'date': 'May 20', 'action': 'availed rice', 'points': -1500},
    {'date': 'May 13', 'action': 'recycled', 'points': 50},
  ];

  String _selectedFilter = 'all'; // 'all', 'used', 'earned'

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
              
              // Transactions Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
              
              // Filter Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    _buildFilterButton('all'),
                    const SizedBox(width: 10),
                    _buildFilterButton('used'),
                    const SizedBox(width: 10),
                    _buildFilterButton('earned'),
                  ],
                ),
              ),
              
              // Transactions List
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: const [
                              Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                              Expanded(flex: 3, child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                              Expanded(flex: 2, child: Text('Points', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.right)),
                            ],
                          ),
                        ),
                        const Divider(height: 1, thickness: 1, color: Colors.grey),
                        
                        // Transaction Items
                        ..._transactionsData.where((transaction) {
                          if (_selectedFilter == 'all') return true;
                          if (_selectedFilter == 'used') return transaction['points'] < 0;
                          if (_selectedFilter == 'earned') return transaction['points'] > 0;
                          return false;
                        }).map((data) {
                          return _buildTransactionItem(data);
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    final bool isSelected = _selectedFilter == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6A1B9A) : Colors.grey[300], // Purple for selected, light grey for unselected
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> data) {
    Color pointsColor = data['points'] > 0 ? const Color(0xFF4CAF50) : Colors.red;
    String pointsText = data['points'] > 0 ? '+${data['points']}' : '${data['points']}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(data['date'], style: const TextStyle(fontSize: 14, color: Colors.black87))),
          Expanded(flex: 3, child: Text(data['action'], style: const TextStyle(fontSize: 14, color: Colors.black87))),
          Expanded(
            flex: 2,
            child: Text(
              pointsText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: pointsColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}