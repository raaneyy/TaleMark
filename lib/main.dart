import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const TaleMarkApp());
}

class TaleMarkApp extends StatelessWidget {
  const TaleMarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaleMark',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          surface: Color(0xFFF9F9F9),
          onSurface: Color(0xFF1A1C1C),
          secondary: Color(0xFF5D5E66),
          surfaceContainer: Color(0xFFEEEEEE),
          surfaceContainerLow: Color(0xFFF3F3F4),
          surfaceContainerLowest: Colors.white,
        ),
        fontFamily: 'sans',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNav = 0;
  bool _pomodoroActive = false;
  int _remainingSeconds = 25 * 60;
  Timer? _timer;
  String? _toastMessage;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showToast(String message) {
    setState(() => _toastMessage = message);

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted && _toastMessage == message) {
        setState(() => _toastMessage = null);
      }
    });
  }

  void _togglePomodoro() {
    if (_pomodoroActive) {
      _timer?.cancel();
      setState(() => _pomodoroActive = false);
      _showToast('Session paused.');
      return;
    }

    setState(() {
      _pomodoroActive = true;
      _remainingSeconds = 25 * 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (mounted) {
          setState(() => _pomodoroActive = false);
          _showToast('Pomodoro session completed.');
        }
      } else if (mounted) {
        setState(() => _remainingSeconds--);
      }
    });

    _showToast('Pomodoro session started. Silence engaged.');
  }

  String get _timerText {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: const Color(0xFFF9F9F9),
                  elevation: 0,
                  toolbarHeight: 64,
                  titleSpacing: 20,
                  title: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            'T',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'serif',
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TaleMark',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            'HOME',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: Color(0xFF5D5E66),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => _showToast('No new notifications'),
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFE2E2E2),
                        child: Icon(Icons.person, color: Colors.black54),
                      ),
                    ),
                  ],
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildStreakCard(),
                      const SizedBox(height: 24),
                      _buildCurrentBook(),
                      const SizedBox(height: 24),
                      _buildMetrics(),
                      const SizedBox(height: 24),
                      _buildActions(),
                      const SizedBox(height: 24),
                      _buildMarginalNote(),
                      const SizedBox(height: 24),
                      _buildNightstand(),
                    ]),
                  ),
                ),
              ],
            ),

            if (_toastMessage != null)
              Positioned(
                left: 20,
                right: 20,
                bottom: 82,
                child: Center(
                  child: Material(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 11,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bookmark,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _toastMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNav,
        onDestinationSelected: (index) {
          setState(() => _currentNav = index);
          _showToast(
            ['Home', 'Library', 'Discover', 'Community', 'Session'][index],
          );
        },
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 8,
        height: 68,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cottage_outlined),
            selectedIcon: Icon(Icons.cottage),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.hourglass_empty),
            selectedIcon: Icon(Icons.hourglass_full),
            label: 'Session',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'READING JOURNAL',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: Color(0xFF5D5E66),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Today’s Quietude',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 28,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const Text(
          'Vol. XXIV',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF5D5E66),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStreakCard() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return _card(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '14',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Days Streak',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5D5E66),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Personal record: 21 days',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF444748),
                      ),
                    ),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'RITUAL',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: Color(0xFF5D5E66),
                    ),
                  ),
                  Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (i) {
              final completed = i < 5;
              final today = i == 5;

              return Column(
                children: [
                  Text(
                    days[i],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: today ? FontWeight.bold : FontWeight.normal,
                      color: today ? Colors.black : const Color(0xFF5D5E66),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: completed || today
                          ? Colors.black
                          : const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: completed
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : today
                            ? Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5D5E66),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBook() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'In Hand',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _showToast('Shelf contains 4 books'),
              child: const Text(
                'SHELF (4)',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: Color(0xFF5D5E66),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _card(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 96,
                    height: 144,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'KLARA\nAND THE\nSUN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: SizedBox(
                      height: 144,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KAZUO ISHIGURO',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: Color(0xFF5D5E66),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Klara and the Sun',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 22,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '“Do you believe in the human heart? I don’t mean simply the organ, obviously.”',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: Color(0xFF444748),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text(
                                '214 of 304 pages',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF5D5E66),
                                ),
                              ),
                              Spacer(),
                              Text(
                                '70%',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: .70,
                            minHeight: 4,
                            backgroundColor: Color(0xFFE2E2E2),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _togglePomodoro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 1,
                  ),
                  icon: Icon(
                    _pomodoroActive ? Icons.pause : Icons.timer,
                    size: 20,
                  ),
                  label: Text(
                    _pomodoroActive
                        ? 'Focus Running: $_timerText'
                        : 'Quick Pomodoro Focus [25m]',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                'Metrics of Mind',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              'WEEK 42',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.3,
                color: Color(0xFF5D5E66),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _metricCard(
                title: 'WEEKLY TARGET',
                value: '4.5',
                suffix: '/ 5.0h',
                subtitle: '30 mins to quota',
                progress: .90,
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _metricCard(
                title: 'MONTHLY READ',
                value: '3',
                suffix: 'of 4 titles',
                subtitle: '75% completed',
                progress: .75,
                icon: Icons.menu_book,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _card(
          child: Column(
            children: [
              Row(
                children: const [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WEEKLY DISTRIBUTION',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: Color(0xFF5D5E66),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '284 Pages Read',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Velocity',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF5D5E66),
                        ),
                      ),
                      Text(
                        '1.4 min/page',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildBarChart(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required String suffix,
    required String subtitle,
    required double progress,
    required IconData icon,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: Color(0xFF5D5E66),
                  ),
                ),
              ),
              Icon(icon, size: 18, color: const Color(0xFF5D5E66)),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  suffix,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5D5E66),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF444748),
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: const Color(0xFFE2E2E2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    const values = [32, 48, 20, 64, 55, 65, 0];
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const heights = [.40, .60, .25, .80, .68, .85, .08];

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final active = i == 5;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  values[i] == 0 ? '-' : '${values[i]}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active ? Colors.black : const Color(0xFF5D5E66),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: heights[i],
                      widthFactor: .55,
                      child: Container(
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.black
                              : const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active ? Colors.black : const Color(0xFF5D5E66),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                'Actions',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              'Shortcuts',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF5D5E66),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                icon: Icons.play_arrow,
                title: 'Resume',
                subtitle: 'Page 214',
                message: 'Session initiated on Page 214',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                icon: Icons.edit_note,
                title: 'Log Pages',
                subtitle: 'Offline',
                message: 'Opening Page Logger dialog',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                icon: Icons.menu_book_outlined,
                title: 'Marginalia',
                subtitle: '18 Notes',
                message: 'Fetching 18 marginal notes',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required String message,
  }) {
    return GestureDetector(
      onTap: () => _showToast(message),
      child: _card(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 14,
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF5D5E66),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarginalNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote, size: 16, color: Color(0xFF5D5E66)),
              SizedBox(width: 5),
              Text(
                'MARGINAL NOTE OF THE DAY',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.4,
                  color: Color(0xFF5D5E66),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '“One never reads alone. Every sentence bears the silent company of the mind that set it down.”',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 18,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'From “The Metamorphosis” commentary',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5D5E66),
                  ),
                ),
              ),
              Text(
                'p. 84',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF5D5E66),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNightstand() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'On the Nightstand',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _showToast('Opening all books'),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF5D5E66),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _bookMiniCard(
                author: 'Franz Kafka',
                title: 'The Metamorphosis',
                status: 'Next up',
                icon: Icons.menu_book,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _bookMiniCard(
                author: 'Italo Calvino',
                title: 'Invisible Cities',
                status: 'Queued',
                icon: Icons.account_balance,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bookMiniCard({
    required String author,
    required String title,
    required String status,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _showToast('$title selected'),
      child: _card(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E2E2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(icon, size: 22),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      letterSpacing: .8,
                      color: Color(0xFF5D5E66),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF5D5E66),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
