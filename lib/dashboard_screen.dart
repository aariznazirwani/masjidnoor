import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'weather_service.dart';
import 'transactions_screen.dart';
import 'update_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  bool _isLoadingWeather = true;
  String _currentTime = '';
  String _currentDate = '';
  String _currentDay = '';
  Timer? _timeTimer;

  int _currentIndex = 0;

  int _titleIndex = 0;
  final List<String> _titles = ['Masjid Noor Bathar', 'مسجد نور بٹھار'];
  Timer? _titleTimer;

  @override
  void initState() {
    super.initState();
    _startTitleTimer();
    _fetchWeather();
    _updateTime();
    _timeTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) _updateTime();
    });
    // Check for updates after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateManager(context).checkForUpdates();
    });
  }

  void _updateTime() {
    // Current UTC time + 5 hours 30 minutes for IST
    final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    final weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    final int hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final String period = now.hour >= 12 ? 'PM' : 'AM';

    setState(() {
      _currentTime = '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
      _currentDate = '${months[now.month - 1]} ${now.day}, ${now.year}';
      _currentDay = weekDays[now.weekday - 1];
    });
  }

  Future<void> _fetchWeather() async {
    try {
      final data = await _weatherService.fetchWeather('34.126631237568205,74.22824381004901'); 
      if (mounted) {
        setState(() {
          _weatherData = data;
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingWeather = false;
        });
        print('Error fetching weather: $e');
      }
    }
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
  }

  @override
  void dispose() {
    _titleTimer?.cancel();
    _timeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: AppBar(
        centerTitle: true,
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

      ),
      body: _currentIndex == 0
          ? SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather Widget
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    if (_isLoadingWeather)
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                            child: CircularProgressIndicator(color: Colors.white)),
                      )
                    else if (_weatherData != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_weatherData!['location']?['name'] ?? _weatherData!['city'] ?? "Weather"}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_weatherData!['current']?['temp_c'] ?? _weatherData!['temperature'] ?? "--"}°C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_weatherData!['current']?['condition']?['text'] ?? _weatherData!['weather'] ?? "--"}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.cloud,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Humidity: ${_weatherData!['current']?['humidity'] ?? _weatherData!['humidity'] ?? "--"}%',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            "Weather Unavailable",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),

                          const SizedBox(height: 16),
                          Container(
                            height: 1,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'IST',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _currentDay,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _currentDate,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                  ),

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

          ],
        ),
      )
          : _currentIndex == 1
              ? const TransactionsScreen()
              : Center(child: Text('Screen ${_currentIndex + 1}')),
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



