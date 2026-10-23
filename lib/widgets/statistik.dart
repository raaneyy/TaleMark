import 'package:flutter/material.dart';

// ─────────────────────── Konstanta desain ───────────────────────
const _kBg = Color(0xFFFAFAF8);
const _kCard = Colors.white;
const _kInk = Color(0xFF111111);
const _kMuted = Color(0xFF8A8A86);
const _kBody = Color(0xFF4A4A48);
const _kTrack = Color(0xFFE9E9E6);
const _kInset = Color(0xFFF4F4F2);
const _kChip = Color(0xFFEFEFED);
const _kSerif = 'Newsreader';
const _kSans = 'Inter';

/// Hanya untuk preview layar ini secara terpisah.
void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: StatsScreen()),
  );
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: _kCard,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withAlpha(10),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ],
);

// ─────────────────────── Data (dummy) ───────────────────────
const _filters = ['Minggu Ini', 'Bulan Ini', 'Tahun 2024', 'Semua'];

const _streakDays = [
  ('S', '5'),
  ('S', '6'),
  ('R', '7'),
  ('K', '8'),
  ('J', '9'),
  ('S', '10'),
  ('M', '11'),
];

class _FavBook {
  final String title;
  final String author;
  final String days;
  final String? coverAsset;

  const _FavBook(this.title, this.author, this.days, {this.coverAsset});
}

const _favBooks = [
  _FavBook(
    'Hujan',
    'Tere Liye',
    '10 Days',
    coverAsset: 'assets/images/hujan.png',
  ),
  _FavBook(
    'Hujan',
    'Tere Liye',
    '22 Days',
    coverAsset: 'assets/images/hujan.png',
  ),
  _FavBook(
    'Hujan',
    'Tere Liye',
    '24 Days',
    coverAsset: 'assets/images/hujan.png',
  ),
];

class _Genre {
  final String name;
  final int percent;
  final int books;
  final Color color;

  const _Genre(this.name, this.percent, this.books, this.color);
}

const _genres = [
  _Genre('Sastra Klasik', 45, 15, Color(0xFF111111)),
  _Genre('Filsafat & Eksistensialisme', 30, 10, Color(0xFF5E5A52)),
  _Genre('Realisme Magis', 15, 5, Color(0xFF6E6E6B)),
  _Genre('Lainnya / Esai Kritik', 10, 4, Color(0xFFC4C6C4)),
];

// ─────────────────────── Stats Screen ───────────────────────
class StatsScreen extends StatefulWidget {
  /// Tampilkan bottom navigation bar bawaan layar ini.
  /// Set false kalau navigasi sudah ditangani di main.dart / shell lain.
  final bool showBottomNav;

  /// Dipanggil saat item bottom nav ditekan (0 Home … 4 Account).
  final ValueChanged<int>? onNavTap;

  const StatsScreen({super.key, this.showBottomNav = true, this.onNavTap});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      bottomNavigationBar: widget.showBottomNav
          ? _BottomNav(currentIndex: 3, onTap: widget.onNavTap)
          : null,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            const _Brand(),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Statistik Baca',
                style: TextStyle(
                  fontFamily: _kSerif,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: _kInk,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _FilterChips(
              selected: _filter,
              onChanged: (i) => setState(() => _filter = i),
            ),
            const SizedBox(height: 22),
            const _StreakCard(),
            const SizedBox(height: 14),
            const _SummaryGrid(),
            const SizedBox(height: 22),
            const _FavoriteBooksCard(),
            const SizedBox(height: 22),
            const _GenreCard(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Brand ───────────────────────
class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 4),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            'assets/images/logo_talemark.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.auto_stories_outlined, size: 20, color: _kInk),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'TaleMark',
          style: TextStyle(
            fontFamily: _kSerif,
            fontSize: 22,
            fontWeight: FontWeight.w700, // bold
            color: _kInk,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────── Filter chips ───────────────────────
class _FilterChips extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _FilterChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          for (int i = 0; i < _filters.length; i++) ...[
            GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: i == selected ? _kInk : _kChip,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    fontFamily: _kSans,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: i == selected ? Colors.white : _kBody,
                  ),
                ),
              ),
            ),
            if (i != _filters.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────── Streak card ───────────────────────
class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_fire_department_rounded, size: 18, color: _kInk),
              SizedBox(width: 2),
              Text(
                '7 DAYS STREAK IN THIS WEEK',
                style: TextStyle(
                  fontFamily: _kSans,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: _kInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final d in _streakDays)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        d.$1,
                        style: const TextStyle(
                          fontFamily: _kSans,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _kBody,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 26,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _kInk,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          d.$2,
                          style: const TextStyle(
                            fontFamily: _kSans,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Summary grid ───────────────────────
class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _MetricCard(
                label: 'BOOK REVIEW',
                icon: Icons.menu_book_outlined,
                minHeight: 112,
                child: Text(
                  '10 Books',
                  style: TextStyle(
                    fontFamily: _kSerif,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: _kInk,
                  ),
                ),
              ),
              SizedBox(height: 12),
              _MetricCard(
                label: 'HALAMAN',
                icon: Icons.menu_book_outlined,
                minHeight: 112,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '9.840',
                      style: TextStyle(
                        fontFamily: _kSerif,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: _kInk,
                      ),
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '~317 hal/buku',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: _kSerif,
                          fontSize: 11,
                          color: _kBody,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            label: 'BUKU TUNTAS',
            icon: Icons.auto_stories_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '20 Buku',
                  style: TextStyle(
                    fontFamily: _kSerif,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: _kInk,
                  ),
                ),
                SizedBox(height: 14),
                _ProgressBar(value: 0.83),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  final double minHeight;

  const _MetricCard({
    required this.label,
    required this.icon,
    required this.child,
    this.minHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _kSans,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: _kBody,
                  ),
                ),
              ),
              Icon(icon, size: 18, color: _kBody),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value; // 0..1

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        height: 6,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: _kTrack)),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(color: _kInk),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Favorite books ───────────────────────
class _FavoriteBooksCard extends StatelessWidget {
  const _FavoriteBooksCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Favorite Books',
              style: TextStyle(
                fontFamily: _kSerif,
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: _kInk,
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < _favBooks.length; i++) ...[
            _FavBookTile(book: _favBooks[i]),
            if (i != _favBooks.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _FavBookTile extends StatelessWidget {
  final _FavBook book;

  const _FavBookTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(color: const Color(0xFF4DB6C8));

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _kInset,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              width: 34,
              height: 48,
              child: book.coverAsset == null
                  ? placeholder
                  : Image.asset(
                      book.coverAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => placeholder,
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _kSerif,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: _kInk,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _kSans,
                    fontSize: 12.5,
                    color: _kMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _kInk,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              book.days,
              style: const TextStyle(
                fontFamily: _kSans,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ─────────────────────── Genre card ───────────────────────
class _GenreCard extends StatelessWidget {
  const _GenreCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final g in _genres)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: g.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      g.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: _kSans,
                        fontSize: 14,
                        color: _kInk,
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontFamily: _kSans,
                        fontSize: 13.5,
                        color: _kBody,
                      ),
                      children: [
                        TextSpan(
                          text: '${g.percent}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _kInk,
                          ),
                        ),
                        TextSpan(text: ' (${g.books} buku)'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          const Text(
            'GENRE & TEMATIK',
            style: TextStyle(
              fontFamily: _kSans,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
              color: _kBody,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Preferensi Bacaan',
            style: TextStyle(
              fontFamily: _kSerif,
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: _kInk,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  for (final g in _genres)
                    Expanded(
                      flex: g.percent,
                      child: Container(color: g.color),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Bottom Navigation ───────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const _BottomNav({required this.currentIndex, this.onTap});

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.local_library_outlined, Icons.local_library_rounded, 'Library'),
    (Icons.explore_outlined, Icons.explore_rounded, 'Feed'),
    (Icons.bar_chart_rounded, Icons.bar_chart_rounded, 'Stats'),
    (Icons.account_circle_outlined, Icons.account_circle_rounded, 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kBg,
        border: Border(
          top: BorderSide(color: Colors.black.withAlpha(10), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              for (int i = 0; i < _items.length; i++)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap?.call(i),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          i == currentIndex ? _items[i].$2 : _items[i].$1,
                          size: 22,
                          color: i == currentIndex ? _kInk : _kMuted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _items[i].$3,
                          style: TextStyle(
                            fontFamily: _kSans,
                            fontSize: 10,
                            fontWeight: i == currentIndex
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: i == currentIndex ? _kInk : _kMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
