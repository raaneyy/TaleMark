import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'book_detail_screen.dart';

// Model data buku
class BookModel {
  final String title;
  final String author;
  final String genre;
  final Color coverColor;
  final double progress; // 0.0 - 1.0
  final int totalPages;
  final int currentPage;
  final String description;

  const BookModel({
    required this.title,
    required this.author,
    required this.genre,
    required this.coverColor,
    required this.progress,
    required this.totalPages,
    required this.currentPage,
    required this.description,
  });
}

// Data dummy buku
final List<BookModel> _dummyBooks = [
  const BookModel(
    title: 'Bumi',
    author: 'Tere Liye',
    genre: 'Fiksi',
    coverColor: Color(0xFF2D5016),
    progress: 0.65,
    totalPages: 440,
    currentPage: 286,
    description:
        'Novel tentang Raib, seorang gadis remaja yang ternyata memiliki kemampuan luar biasa untuk menghilang. Ia pun akhirnya mengetahui bahwa ada dunia lain selain bumi.',
  ),
  const BookModel(
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    genre: 'Biografi',
    coverColor: Color(0xFF1A3A5C),
    progress: 1.0,
    totalPages: 529,
    currentPage: 529,
    description:
        'Kisah sepuluh anak kampung Belitung yang berjuang keras untuk mendapatkan pendidikan di sekolah yang nyaris roboh namun penuh semangat.',
  ),
  const BookModel(
    title: 'Hujan',
    author: 'Tere Liye',
    genre: 'Romance',
    coverColor: Color(0xFF4A2060),
    progress: 0.3,
    totalPages: 320,
    currentPage: 96,
    description:
        'Novel tentang persahabatan, harapan, dan kenangan masa lalu yang tak bisa dilupakan. Berlatar di masa depan di tahun 2040-2050.',
  ),
  const BookModel(
    title: 'Perahu Kertas',
    author: 'Dee Lestari',
    genre: 'Romance',
    coverColor: Color(0xFF8B3A1A),
    progress: 0.0,
    totalPages: 444,
    currentPage: 0,
    description:
        'Kisah cinta antara Kugy dan Keenan yang terpisah oleh jarak dan waktu, namun takdir terus mempertemukan mereka.',
  ),
  const BookModel(
    title: 'Sang Pemimpi',
    author: 'Andrea Hirata',
    genre: 'Fiksi',
    coverColor: Color(0xFF1A5C4A),
    progress: 0.5,
    totalPages: 292,
    currentPage: 146,
    description:
        'Sekuel Laskar Pelangi. Kisah Ikal dan Arai yang bermimpi besar untuk mengubah nasib dan merantau ke Perancis.',
  ),
  const BookModel(
    title: 'Negeri 5 Menara',
    author: 'A. Fuadi',
    genre: 'Fiksi',
    coverColor: Color(0xFF5C3A1A),
    progress: 0.8,
    totalPages: 423,
    currentPage: 338,
    description:
        'Novel tentang enam santri yang bermimpi meraih cita-cita setinggi langit dengan prinsip "man jadda wajada".',
  ),
];

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';
  bool _isSearchFocused = false;
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchFocus.addListener(() {
      setState(() => _isSearchFocused = _searchFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<BookModel> get _filteredBooks {
    final query = _searchQuery.toLowerCase();
    return _dummyBooks.where((book) {
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.genre.toLowerCase().contains(query);
    }).toList();
  }

  List<BookModel> get _inProgressBooks =>
      _filteredBooks.where((b) => b.progress > 0 && b.progress < 1).toList();
  List<BookModel> get _finishedBooks =>
      _filteredBooks.where((b) => b.progress >= 1.0).toList();
  List<BookModel> get _unreadBooks =>
      _filteredBooks.where((b) => b.progress == 0).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perpustakaan',
                    style: AppTheme.serif(size: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_dummyBooks.length} buku dalam koleksi',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _isSearchFocused
                          ? Colors.white
                          : const Color(0xFFF1F1EF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isSearchFocused
                            ? Colors.black.withAlpha(30)
                            : Colors.transparent,
                        width: 1,
                      ),
                      boxShadow: _isSearchFocused
                          ? [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Cari judul, penulis, atau genre...',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8E8E8C),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppTheme.muted,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded,
                                    size: 18, color: AppTheme.muted),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: AppTheme.muted,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      insets: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    dividerColor: const Color(0xFFE8E8E6),
                    padding: EdgeInsets.zero,
                    tabs: [
                      Tab(text: 'Semua (${_filteredBooks.length})'),
                      Tab(text: 'Dibaca (${_inProgressBooks.length})'),
                      Tab(text: 'Selesai (${_finishedBooks.length})'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _BookGrid(books: _filteredBooks),
                  _BookGrid(books: _inProgressBooks),
                  _BookGrid(books: _finishedBooks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookGrid extends StatelessWidget {
  final List<BookModel> books;

  const _BookGrid({required this.books});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 48, color: Colors.black12),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada buku ditemukan',
              style: TextStyle(fontSize: 14, color: AppTheme.muted),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.62,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _BookCard(book: books[index]);
      },
    );
  }
}

class _BookCard extends StatelessWidget {
  final BookModel book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => BookDetailScreen(book: book),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Expanded(
            child: Hero(
              tag: 'book-${book.title}',
              child: Container(
                decoration: BoxDecoration(
                  color: book.coverColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: book.coverColor.withAlpha(80),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative lines on book cover
                    Positioned(
                      left: 16,
                      bottom: 40,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              fontFamily: 'Newsreader',
                              fontSize: 16,
                              color: Colors.white.withAlpha(230),
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            book.author,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: Colors.white.withAlpha(160),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Genre chip
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          book.genre,
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Inter',
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ),
                    ),
                    // Progress indicator at bottom of cover
                    if (book.progress > 0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          child: LinearProgressIndicator(
                            value: book.progress,
                            backgroundColor: Colors.white.withAlpha(30),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Book info
          Text(
            book.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.muted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (book.progress > 0 && book.progress < 1) ...[
            const SizedBox(height: 4),
            Text(
              'Hal. ${book.currentPage} dari ${book.totalPages}',
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.muted,
              ),
            ),
          ] else if (book.progress >= 1.0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 12, color: Color(0xFF2D7D32)),
                const SizedBox(width: 3),
                const Text(
                  'Selesai',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF2D7D32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
