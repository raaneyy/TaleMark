import 'package:flutter/material.dart';
import 'book_detail_screen.dart';

<<<<<<< HEAD
// ─────────────────────── Shared constants ───────────────────────
const _kBg = Color(0xFFF7F7F5);
const _kCard = Colors.white;
const _kInk = Color(0xFF111111);
const _kMuted = Color(0xFF6B6B6B);
const _kChip = Color(0xFFEDEDF0);
const _kSerif = 'Georgia';

// ─────────────────────── Book Model ───────────────────────
=======
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LibraryScreen(),
  ));
}

// Model data buku
>>>>>>> eef0dbd3401b6719c950b641ae73f265e0401fed
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
  });
}

// ─────────────────────── Dummy data ───────────────────────
final List<BookModel> _allBooks = [
  const BookModel(
    title: 'Hujan',
    author: 'Tere Liye',
    genre: 'History',
    coverTopColor: Color(0xFF4FB4D8),
    coverBottomColor: Color(0xFFBEE6F2),
    progress: 0.24,
    totalPages: 320,
    currentPage: 50,
    rating: 5.0,
    description: 'Novel tentang persahabatan, harapan, dan kenangan masa lalu yang tak bisa dilupakan.',
    isFavorite: true,
    isArchivePick: true,
  ),
  const BookModel(
    title: 'Aldebaran',
    author: 'Tere Liye',
    genre: 'Essays',
    coverTopColor: Color(0xFF1E5C3A),
    coverBottomColor: Color(0xFF0D3020),
    progress: 0.0,
    totalPages: 400,
    currentPage: 0,
    rating: 4.9,
    description: 'Petualangan epik di negeri yang penuh misteri dan sihir.',
    isFavorite: true,
    isArchivePick: false,
  ),
  const BookModel(
    title: 'Hujan',
    author: 'Tere Liye',
    genre: 'History',
    coverTopColor: Color(0xFF4FB4D8),
    coverBottomColor: Color(0xFFBEE6F2),
    progress: 0.24,
    totalPages: 320,
    currentPage: 50,
    rating: 4.7,
    description: 'Novel tentang persahabatan, harapan, dan kenangan masa lalu.',
    isFavorite: false,
    isArchivePick: false,
  ),
  const BookModel(
    title: 'Aldebaran Bagian 1',
    author: 'Tere Liye',
    genre: 'Essays',
    coverTopColor: Color(0xFF1E5C3A),
    coverBottomColor: Color(0xFF0D3020),
    progress: 0.0,
    totalPages: 400,
    currentPage: 0,
    rating: 4.5,
    description: 'Bagian pertama dari seri Aldebaran yang memukau.',
    isFavorite: false,
    isArchivePick: false,
  ),
];

// ─────────────────────── Library Screen ───────────────────────
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _showBanner = true;
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
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildStatsTabs()),
            if (_showBanner) SliverToBoxAdapter(child: _buildBanner()),
            SliverToBoxAdapter(child: _buildFavoritesSection()),
            SliverToBoxAdapter(child: _buildSortChips()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.55,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _BookGridCard(book: _gridBooks[index]),
                  childCount: _gridBooks.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'TaleMark',
                style: TextStyle(
                  fontFamily: _kSerif,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _kInk,
                ),
              ),
              const Spacer(),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _kChip,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.search_rounded, size: 20, color: _kInk),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'My Library',
            style: TextStyle(
              fontFamily: _kSerif,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _kInk,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '42 Editions Curated',
            style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: _kMuted),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildStatsTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E3), width: 1)),
      ),
      child: Row(
        children: const [
          _StatsTab(label: 'Currently Reading', count: 2, isSelected: false),
          _StatsTab(label: 'Read', count: 28, isSelected: true),
          _StatsTab(label: 'Want to Read', count: 12, isSelected: false),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5E3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1EF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.timer_outlined, size: 18, color: _kMuted),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'READING TRACKER RECOVERY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: _kMuted,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Forgot to turn on the Pomodoro during reading?',
                        style: TextStyle(
                          fontFamily: _kSerif,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _kInk,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showBanner = false),
                  child: const Icon(Icons.close_rounded, size: 18, color: _kMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Your reading tracker still important.\nInput reading progress manually to keep up the reading synchronization.',
              style: TextStyle(fontSize: 12, color: _kMuted, height: 1.5),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_outlined, size: 15),
                      label: const Text(
                        'Record reading progress manually',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kInk,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => setState(() => _showBanner = false),
                  style: TextButton.styleFrom(
                    foregroundColor: _kMuted,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Skip for now', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 22, 16, 12),
          child: Row(
            children: [
              Icon(Icons.star_outline_rounded, size: 17, color: _kInk),
              SizedBox(width: 6),
              Text(
                'Favorite Volumes',
                style: TextStyle(
                  fontFamily: _kSerif,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _kInk,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < _favoriteBooks.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(child: _FavoriteCard(book: _favoriteBooks[i])),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          _SortChip(
            label: 'Recently Added',
            icon: Icons.schedule_rounded,
            isSelected: _sortIndex == 0,
            onTap: () => setState(() => _sortIndex = 0),
          ),
          const SizedBox(width: 8),
          _SortChip(
            label: 'Highest Rated',
            icon: Icons.star_outline_rounded,
            isSelected: _sortIndex == 1,
            onTap: () => setState(() => _sortIndex = 1),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Stats Tab ───────────────────────
class _StatsTab extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;

  const _StatsTab({
    required this.label,
    required this.count,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: isSelected ? _kInk : _kMuted,
                ),
                children: [
                  TextSpan(text: label),
                  TextSpan(
                    text: '  $count',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: isSelected ? _kInk : _kMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(height: 2, color: isSelected ? _kInk : Colors.transparent),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _kInk : _kCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _kInk : const Color(0xFFDDDDDB),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : _kMuted),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : _kInk,
              ),
            ),
          ],
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
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => BookDetailScreen(book: book),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 280),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.68,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (book.isArchivePick)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'ARCHIVE PICK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star_border_rounded, size: 15, color: _kInk),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kInk,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: _kMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 12, color: _kInk),
              const SizedBox(width: 3),
              Text(
                '${book.rating}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _kInk,
                ),
              ),
              const Text(' · ', style: TextStyle(fontSize: 11, color: _kMuted)),
              Expanded(
                child: Text(
                  book.genre,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: _kMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => BookDetailScreen(book: book),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 280),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [book.coverTopColor, book.coverBottomColor],
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          book.title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (hasProgress)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _kInk,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '$progressPct%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kInk,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: _kMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 12, color: _kInk),
              const SizedBox(width: 3),
              Text(
                '${book.rating}',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: _kMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}