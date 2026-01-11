import 'package:flutter/material.dart';
import 'admin_login_screen.dart';
import 'update_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Check for updates after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateManager(context).checkForUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Masjid Noor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Grid
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'TOTAL HOUSEHOLDS',
                    value: '120',
                    borderLeftColor: Colors.transparent,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'PAID HOUSEHOLDS',
                    value: '85',
                    percentage: '70%',
                    percentageColor: Colors.green,
                    borderLeftColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'PENDING',
                    value: '35',
                    percentage: '30%',
                    percentageColor: Colors.orange,
                    borderLeftColor: Colors.orange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'SALARY FUND',
                    value: '\$42.5k',
                    borderLeftColor: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Total Amount Collected Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount Collected',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$45,000',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search household or month...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Transactions Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            'S.No',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            'Month',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Household',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text(
                          'Salary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // List Items
                  const TransactionItem(
                    sNo: '01',
                    month: 'Oct 2023',
                    household: 'House #42 (Ahmed)',
                    amount: '\$500',
                  ),
                  const TransactionItem(
                    sNo: '02',
                    month: 'Oct 2023',
                    household: 'House #15 (Rahman)',
                    amount: '\$250',
                  ),
                  const TransactionItem(
                    sNo: '03',
                    month: 'Sep 2023',
                    household: 'House #08 (Khan)',
                    amount: '\$100',
                  ),
                  const TransactionItem(
                    sNo: '04',
                    month: 'Sep 2023',
                    household: 'House #33 (Ali)',
                    amount: '\$500',
                  ),
                  const TransactionItem(
                    sNo: '05',
                    month: 'Aug 2023',
                    household: 'House #99 (Yusuf)',
                    amount: '\$100',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF00E676),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Dashboard selected
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt_long,
            ), // Closest to 'Reports' icon in image
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? percentage;
  final Color? percentageColor;
  final Color borderLeftColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.percentage,
    this.percentageColor,
    this.borderLeftColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Simple border logic: if borderLeftColor is transparent, use no border or just radius
        // To achieve the left border strip effect seen in image:
      ),
      child: ClipRRect(
        // Clip to ensure left pill shape stays inside
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (percentage != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          percentage!,
                          style: TextStyle(
                            color: percentageColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Left Border Strip
            if (borderLeftColor != Colors.transparent)
              Positioned(
                left: 0,
                top: 10,
                bottom: 10,
                width: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: borderLeftColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String sNo;
  final String month;
  final String household;
  final String amount;

  const TransactionItem({
    super.key,
    required this.sNo,
    required this.month,
    required this.household,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              sNo,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(month, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              household,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
