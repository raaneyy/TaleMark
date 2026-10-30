import 'package:flutter/material.dart';

import 'book_detail_screen.dart';

// ─────────────────────── Konstanta desain ───────────────────────
const _kBg = Color(0xFFFAFAF8);
const _kCard = Colors.white;
const _kInk = Color(0xFF111111);
const _kMuted = Color(0xFF8A8A86);
const _kTrack = Color(0xFFF1F1EF); // latar tab & chip tidak aktif
const _kSerif = 'Newsreader';
const _kSans = 'Inter';

/// Hanya untuk preview layar ini secara terpisah.
/// Aplikasi sebenarnya tetap dijalankan dari main.dart.
void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: LibraryScreen()),
  );
}

// ─────────────────────── Book Model ───────────────────────
class BookModel {
  final String title;
  final String author;
  final String genre;
  final Color coverTopColor;
  final Color coverBottomColor;
  final double progress; // 0.0 – 1.0
  final int totalPages;
  final int currentPage;
  final double rating;
  final String description;
  final bool isFavorite;
  final bool isArchivePick;

  /// Path gambar cover (opsional). Kalau null / gagal dimuat,
  /// cover otomatis memakai gradient dari dua warna di atas.
  final String? coverAsset;

  /// Info tambahan untuk halaman detail (semua opsional).
  final String? subGenres; // contoh: 'Fiksi Ilmiah, Distopia, Romance'
  final int? year;
  final String? format; // contoh: 'Novella'
  final int? readers; // jumlah pembaca
  final List<BookQuote> quotes; // kutipan yang tersimpan

  const BookModel({
    required this.title,
    required this.author,
    required this.genre,
    required this.coverTopColor,
    required this.coverBottomColor,
    required this.progress,
    required this.totalPages,
    required this.currentPage,
    required this.rating,
    required this.description,
    this.isFavorite = false,
    this.isArchivePick = false,
    this.coverAsset,
    this.subGenres,
    this.year,
    this.format,
    this.readers,
    this.quotes = const [],
  });
}

/// Kutipan / marginalia yang disimpan pembaca.
class BookQuote {
  final String label; // contoh: 'ENDING'
  final String text;

  const BookQuote({required this.label, required this.text});
}

const _hujanQuotes = [
  BookQuote(
    label: 'ENDING',
    text: 'Bukan seberapa lama umat manusia bisa bertahan hidup sebagai ukuran kebahagiaan, tapi seberapa besar kemampuan mereka memeluk erat-erat semua hal menyakitkan yang mereka alami.',
  ),
  BookQuote(
    label: 'CONTOH',
    text: 'Contoh kutipan kedua. Ganti dengan kutipan favoritmu.',
  ),
  BookQuote(
    label: 'CONTOH',
    text: 'Contoh kutipan ketiga. Tekan "New Quote" untuk menambah sendiri.',
  ),
];

// ─────────────────────── Dummy data ───────────────────────
final List<BookModel> _allBooks = [
  const BookModel(
    title: 'Hujan',
    author: 'Tere Liye',
    genre: 'History',
    coverTopColor: Color(0xFF4FB4D8),
    coverBottomColor: Color(0xFFBEE6F2),
    coverAsset: 'assets/images/hujan.jpeg',
    progress: 0.24,
    totalPages: 320,
    currentPage: 77,
    rating: 5.0,
    description: 'Novel tentang persahabatan, harapan, dan kenangan masa lalu yang tak bisa dilupakan.',
    isFavorite: true,
    isArchivePick: true,
    subGenres: 'Fiksi Ilmiah, Distopia, Romance',
    year: 2016,
    format: 'Novella',
    readers: 1240,
    quotes: _hujanQuotes,
  ),
  const BookModel(
    title: 'Aldebaran',
    author: 'Tere Liye',
    genre: 'Essays',
    coverTopColor: Color(0xFF3F8F78),
    coverBottomColor: Color(0xFF16402F),
    coverAsset: 'assets/images/aldebaran.jpeg',
    progress: 0.0,
    totalPages: 400,
    currentPage: 0,
    rating: 4.9,
    description: 'Petualangan epik di negeri yang penuh misteri dan sihir.',
    isFavorite: true,
  ),
];

// ─────────────────────── Library Screen ───────────────────────
class LibraryScreen extends StatefulWidget {
  /// Tampilkan bottom navigation bar bawaan layar ini.
  /// Set false kalau navigasi sudah ditangani di main.dart / shell lain.
  final bool showBottomNav;

  /// Dipanggil saat item bottom nav ditekan (0 Home … 4 Account).
  final ValueChanged<int>? onNavTap;

  const LibraryScreen({super.key, this.showBottomNav = true, this.onNavTap});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _tabIndex = 0;
  int _sortIndex = 0;

  List<BookModel> get _gridBooks {
    final list = _allBooks.toList();
    if (_sortIndex == 1) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  List<BookModel> get _favoriteBooks =>
      _allBooks.where((b) => b.isFavorite).toList();

  @override
  Widget build(BuildContext context) {
    final gridBooks = _gridBooks;

    return Scaffold(
      backgroundColor: _kBg,
      bottomNavigationBar: widget.showBottomNav
          ? _BottomNav(currentIndex: 1, onTap: widget.onNavTap)
          : null,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildTabs()),
            SliverToBoxAdapter(child: _buildFavoritesSection()),
            SliverToBoxAdapter(child: _buildSortChips()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  mainAxisExtent: 340,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _BookGridCard(book: gridBooks[index]),
                  childCount: gridBooks.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header: logo, judul, "My Library", tombol search ──
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 36),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Library',
                      style: TextStyle(
                        fontFamily: _kSerif,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: _kInk,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '42 Editions Curated',
                      style: TextStyle(
                        fontFamily: _kSans,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withAlpha(220),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _kTrack,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.search_rounded, size: 20, color: _kInk),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Tab segmented: Currently Reading / Read / Want to Read ──
  Widget _buildTabs() {
    const tabs = [('Currently Reading', 2), ('Read', 28), ('Want to Read', 12)];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _kTrack.withAlpha(180),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            for (int i = 0; i < tabs.length; i++)
              Expanded(
                child: _SegmentTab(
                  label: tabs[i].$1,
                  count: tabs[i].$2,
                  isSelected: _tabIndex == i,
                  onTap: () => setState(() => _tabIndex = i),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Favorite Volumes ──
  Widget _buildFavoritesSection() {
    final favorites = _favoriteBooks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 26, 20, 14),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_outlined, size: 18, color: _kInk),
              SizedBox(width: 8),
              Text(
                'Favorite Volumes',
                style: TextStyle(
                  fontFamily: _kSerif,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: _kInk,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < favorites.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(child: _FavoriteCard(book: favorites[i])),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ── Chip urutan ──
  Widget _buildSortChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Row(
        children: [
          _SortChip(
            label: 'Recently Added',
            icon: Icons.history_rounded,
            isSelected: _sortIndex == 0,
            onTap: () => setState(() => _sortIndex = 0),
          ),
          const SizedBox(width: 8),
          _SortChip(
            label: 'Highest Rated',
            icon: Icons.auto_awesome_outlined,
            isSelected: _sortIndex == 1,
            onTap: () => setState(() => _sortIndex = 1),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Segment Tab ───────────────────────
class _SegmentTab extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: _kSans,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: _kInk,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count',
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _kMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────── Sort Chip ───────────────────────
class _SortChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? _kCard : _kTrack,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(14),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: _kInk),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: _kSans,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _kInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Navigasi ke detail ───────────────────────
void _openDetail(BuildContext context, BookModel book) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => BookDetailScreen(book: book),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 280),
    ),
  );
}

// ─────────────────────── Cover buku (gambar / gradient) ───────────────────────
class _CoverArt extends StatelessWidget {
  final BookModel book;
  final double radius;
  final double titleSize;

  const _CoverArt({required this.book, this.titleSize = 20}) : radius = 12;

  @override
  Widget build(BuildContext context) {
    final fallback = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [book.coverTopColor, book.coverBottomColor],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            book.title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
              height: 1.1,
            ),
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.expand(
        child: book.coverAsset == null
            ? fallback
            : Image.asset(
                book.coverAsset!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback,
              ),
      ),
    );
  }
}

// ─────────────────────── Favorite Card ───────────────────────
class _FavoriteCard extends StatelessWidget {
  final BookModel book;

  const _FavoriteCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context, book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.74,
            child: Stack(
              children: [
                Positioned.fill(child: _CoverArt(book: book)),
                if (book.isArchivePick)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 22, 12, 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(150),
                            ],
                          ),
                        ),
                        child: const Text(
                          'ARCHIVE PICK',
                          style: TextStyle(
                            fontFamily: _kSans,
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: _kInk,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_border_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: _kSerif,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: _kInk,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: _kSans,
              fontSize: 12,
              color: _kMuted,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                book.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _kInk,
                ),
              ),
              const Text(
                '  ·  ',
                style: TextStyle(fontSize: 12, color: _kMuted),
              ),
              Expanded(
                child: Text(
                  book.genre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _kSans,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Book Grid Card ───────────────────────
class _BookGridCard extends StatelessWidget {
  final BookModel book;

  const _BookGridCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final hasProgress = book.progress > 0;
    final progressPct = (book.progress * 100).round();

    return GestureDetector(
      onTap: () => _openDetail(context, book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: _CoverArt(book: book, titleSize: 18)),
                  if (hasProgress) ...[
                    // Bar progres di dasar cover
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: LinearProgressIndicator(
                          value: book.progress.clamp(0.0, 1.0),
                          minHeight: 4,
                          backgroundColor: Colors.black.withAlpha(40),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            _kInk,
                          ),
                        ),
                      ),
                    ),
                    // Badge persen di kiri atas
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _kInk,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$progressPct%',
                          style: const TextStyle(
                            fontFamily: _kSans,
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: _kSerif,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: _kInk,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: _kSans,
              fontSize: 12,
              color: _kMuted,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                book.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _kMuted,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star_border_rounded, size: 14, color: _kInk),
            ],
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
                          size: 24,
                          color: i == currentIndex ? _kInk : _kMuted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _items[i].$3,
                          style: TextStyle(
                            fontFamily: _kSans,
                            fontSize: 11,
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
