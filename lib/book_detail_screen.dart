import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'library_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: CustomScrollView(
        slivers: [
          // Hero App Bar dengan cover buku
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: book.coverColor,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_horiz_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'book-${book.title}',
                child: Container(
                  color: book.coverColor,
                  child: Stack(
                    children: [
                      // Decorative pattern
                      ...List.generate(5, (i) {
                        return Positioned(
                          top: -20 + (i * 60.0),
                          right: -40 + (i * 15.0),
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withAlpha(10),
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      }),
                      // Content
                      Positioned(
                        bottom: 40,
                        left: 32,
                        right: 32,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                book.genre.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                  fontFamily: 'Inter',
                                  color: Colors.white.withAlpha(200),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontFamily: 'Newsreader',
                                fontSize: 30,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              book.author,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.white.withAlpha(180),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Detail konten
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'PROGRES MEMBACA',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 0.8,
                                color: AppTheme.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              book.progress >= 1.0
                                  ? 'Selesai ✓'
                                  : book.progress == 0
                                      ? 'Belum dibaca'
                                      : '${(book.progress * 100).round()}%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: book.progress >= 1.0
                                    ? const Color(0xFF2D7D32)
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: book.progress,
                            backgroundColor: const Color(0xFFF1F1EF),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              book.progress >= 1.0
                                  ? const Color(0xFF2D7D32)
                                  : Colors.black,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatChip(
                              label: 'Halaman',
                              value: book.totalPages.toString(),
                            ),
                            _StatChip(
                              label: 'Dibaca',
                              value: book.currentPage.toString(),
                            ),
                            _StatChip(
                              label: 'Tersisa',
                              value:
                                  (book.totalPages - book.currentPage).toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol aksi
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.menu_book_rounded, size: 16),
                          label: Text(
                            book.progress == 0
                                ? 'Mulai Membaca'
                                : book.progress >= 1.0
                                    ? 'Baca Ulang'
                                    : 'Lanjut Membaca',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1EF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_border_rounded,
                              size: 20),
                          onPressed: () {},
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sinopsis
                  const Text(
                    'SINOPSIS',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3A3A38),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Informasi buku
                  const Text(
                    'INFORMASI BUKU',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Penulis', value: book.author),
                  _InfoRow(label: 'Genre', value: book.genre),
                  _InfoRow(
                      label: 'Total Halaman', value: '${book.totalPages} hal.'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.muted),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppTheme.muted),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
