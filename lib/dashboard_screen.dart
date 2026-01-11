import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'admin_login_screen.dart';
import 'update_manager.dart';
import 'update_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _tableKey = GlobalKey();
  int _currentIndex = 0;

  int _titleIndex = 0;
  final List<String> _titles = ['Masjid Noor Bathar', 'مسجد نور بٹھار'];
  Timer? _titleTimer;

  @override
  void initState() {
    super.initState();
    _startTitleTimer();
    // Check for updates after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateManager(context).checkForUpdates();
    });
  }

  void _startTitleTimer() {
    _titleTimer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      if (mounted) {
        setState(() {
          _titleIndex = (_titleIndex + 1) % _titles.length;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (index == 1) {
      if (_tableKey.currentContext != null) {
        Scrollable.ensureVisible(
          _tableKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _titleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final rotateAnim = Tween(
              begin: pi / 2,
              end: 0.0,
            ).animate(animation);
            return AnimatedBuilder(
              animation: rotateAnim,
              child: child,
              builder: (context, child) {
                final isUnder = (ValueKey(_titles[_titleIndex]) != child?.key);
                var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                tilt *= isUnder ? -1.0 : 1.0;
                final value = isUnder
                    ? min(rotateAnim.value, pi / 2)
                    : rotateAnim.value;
                return Transform(
                  transform: Matrix4.rotationX(value)..setEntry(3, 1, tilt),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          child: Text(
            _titles[_titleIndex],
            key: ValueKey<String>(_titles[_titleIndex]),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
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
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Grid
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'TOTAL',
                    value: '120',
                    borderLeftColor: Colors.transparent,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'PAID',
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
                    title: 'TOTAL SALARY',
                    value: '₹42.5k',
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
                        '₹45,000',
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

            // Search Bar Removed

            // Filter Options
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filter by Month'),
                        Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filter by Household'),
                        Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Transactions Table
            Container(
              key: _tableKey,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            width: 50,
                            child: Text(
                              'S.No',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Month',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              'Household',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Salary',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
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
                      amount: '₹500',
                    ),
                    const TransactionItem(
                      sNo: '02',
                      month: 'Oct 2023',
                      household: 'House #15 (Rahman)',
                      amount: '₹250',
                    ),
                    const TransactionItem(
                      sNo: '03',
                      month: 'Sep 2023',
                      household: 'House #08 (Khan)',
                      amount: '₹100',
                    ),
                    const TransactionItem(
                      sNo: '04',
                      month: 'Sep 2023',
                      household: 'House #33 (Ali)',
                      amount: '₹500',
                    ),
                    const TransactionItem(
                      sNo: '05',
                      month: 'Aug 2023',
                      household: 'House #99 (Yusuf)',
                      amount: '₹100',
                    ),
                  ],
                ),
              ),
            ),
            // Space for FAB removed as requested
          ],
        ),
      ),
      // floatingActionButton removed
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Table',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Share'),
          BottomNavigationBarItem(icon: Icon(Icons.print), label: 'Print'),
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
            width: 50,
            child: Text(
              sNo,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(month, style: const TextStyle(color: Colors.grey)),
          ),
          SizedBox(
            width: 200,
            child: Text(
              household,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
