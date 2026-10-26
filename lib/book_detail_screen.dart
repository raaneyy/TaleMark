import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'library_screen.dart';

// ─────────────────────── Konstanta desain ───────────────────────
const _kBg = Color(0xFFFAFAF8);
const _kCard = Colors.white;
const _kInk = Color(0xFF111111);
const _kMuted = Color(0xFF8A8A86);
const _kBody = Color(0xFF4A4A48);
const _kTrack = Color(0xFFF1F1EF);
const _kInset = Color(0xFFF4F4F2);
const _kSerif = 'Newsreader';
const _kSans = 'Inter';

const _kStatusLabels = ['Want to Read', 'Reading', 'Finished'];

/// Hanya untuk preview layar ini secara terpisah.
/// Aplikasi sebenarnya tetap dijalankan dari main.dart.
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BookDetailScreen(
      book: BookModel(
        title: 'Hujan',
        author: 'Tere Liye',
        genre: 'Fiction',
        subGenres: 'Fiksi Ilmiah, Distopia, Romance',
        year: 2016,
        format: 'Novella',
        readers: 1240,
        coverTopColor: const Color(0xFF4FB4D8),
        coverBottomColor: const Color(0xFFBEE6F2),
        coverAsset: 'assets/covers/hujan.png',
        progress: 0.24,
        totalPages: 320,
        currentPage: 77,
        rating: 4.6,
        description:
            'Novel tentang persahabatan, harapan, dan kenangan masa lalu. Lail berusaha mengatasi trauma masa lalu dan kerinduan mendalam pada sahabatnya, Esok. Di tengah dunia yang terus berubah, ia belajar menerima apa yang telah hilang.',
        quotes: const [
          BookQuote(
            label: 'ENDING',
            text: 'Contoh kutipan pertama. Ganti dengan kutipan favoritmu.',
          ),
        ],
      ),
    ),
  ));
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

// ─────────────────────── Book Detail Screen ───────────────────────
class BookDetailScreen extends StatefulWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  /// Asumsi kecepatan baca, dipakai untuk estimasi waktu.
  static const double _minutesPerPage = 0.5;

  late int _status; // 0 = Want to Read, 1 = Reading, 2 = Finished
  late int _currentPage;
  late final TextEditingController _pageCtrl;
  late final List<BookQuote> _quotes;
  bool _expanded = false;
  int _myScore = 0;

  BookModel get book => widget.book;

  @override
  void initState() {
    super.initState();
    final p = book.progress;
    _status = p >= 1.0 ? 2 : (p > 0 ? 1 : 0);
    _currentPage = book.currentPage.clamp(0, book.totalPages).toInt();
    _pageCtrl = TextEditingController(text: '$_currentPage');
    _quotes = List<BookQuote>.of(book.quotes);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  // ── Helper hitung ──
  int get _percent => book.totalPages == 0
      ? 0
      : (_currentPage / book.totalPages * 100).round();

  double get _progressValue => book.totalPages == 0
      ? 0.0
      : (_currentPage / book.totalPages).clamp(0.0, 1.0).toDouble();

  String get _timeLeft {
    final mins = ((book.totalPages - _currentPage) * _minutesPerPage).round();
    if (mins <= 0) return 'Finished';
    final h = mins ~/ 60;
    final m = mins % 60;
    if (h == 0) return '$m mins';
    if (m == 0) return '$h hr';
    return '$h hr $m mins';
  }

  String get _totalHours {
    final h = (book.totalPages * _minutesPerPage / 60 * 2).round() / 2;
    return h == h.roundToDouble() ? h.toInt().toString() : h.toStringAsFixed(1);
  }

  String _fmtNumber(int n) => n.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => ',',
      );

  // ── Aksi ──
  void _saveProgress() {
    final v = int.tryParse(_pageCtrl.text.trim());
    if (v == null) {
      _snack('Masukkan nomor halaman yang valid');
      return;
    }
    final page = v.clamp(0, book.totalPages).toInt();
    setState(() {
      _currentPage = page;
      _pageCtrl.text = '$page';
    });
    FocusScope.of(context).unfocus();
    _snack('Progres tersimpan: halaman $page dari ${book.totalPages}');
  }

  Future<void> _addQuote() async {
    final ctrl = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'New Quote',
          style: TextStyle(fontFamily: _kSerif, fontSize: 22),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          minLines: 3,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'Tulis kutipan dari buku ini...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (text == null || text.isEmpty || !mounted) return;
    setState(() => _quotes.add(BookQuote(label: 'PAGE $_currentPage', text: text)));
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ─────────────────────── BUILD ───────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(),
              const SizedBox(height: 8),
              _buildCover(),
              const SizedBox(height: 28),
              _buildTitleBlock(),
              const SizedBox(height: 20),
              _buildRatingPill(),
              const SizedBox(height: 24),
              _buildStatusTabs(),
              if (_status == 1) ...[
                const SizedBox(height: 12),
                _buildProgressCard(),
              ],
              const SizedBox(height: 20),
              _buildOverview(),
              const SizedBox(height: 20),
              _buildVerdict(),
              const SizedBox(height: 28),
              _buildMarginaliaHeader(),
              const SizedBox(height: 12),
              ..._buildQuoteCards(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tombol kembali ──
  Widget _buildTopBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.arrow_back_rounded, color: _kInk, size: 24),
      ),
    );
  }

  // ── Cover ──
  Widget _buildCover() {
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              height: 1.1,
            ),
          ),
        ),
      ),
    );

    return Center(
      child: Container(
        width: 160,
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Positioned.fill(
                child: book.coverAsset == null
                    ? fallback
                    : Image.asset(
                        book.coverAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => fallback,
                      ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B6B6B).withAlpha(210),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    book.genre.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: _kSans,
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sub-genre, judul, penulis, meta ──
  Widget _buildTitleBlock() {
    return Column(
      children: [
        Text(
          (book.subGenres ?? book.genre).toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: _kSans,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
            color: _kBody,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          book.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: _kSerif,
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: _kInk,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          book.author,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: _kSerif,
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 14),
        _buildMeta(),
      ],
    );
  }

  Widget _buildMeta() {
    final parts = <String>[
      if (book.year != null) '${book.year}',
      if (book.format != null) book.format!,
      '${book.totalPages} pages',
      '~$_totalHours hrs',
    ];

    final spans = <InlineSpan>[];
    for (int i = 0; i < parts.length; i++) {
      if (i > 0) {
        spans.add(const TextSpan(
          text: '  •  ',
          style: TextStyle(color: Color(0xFFC8C8C4)),
        ));
      }
      spans.add(TextSpan(text: parts[i]));
    }

    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontFamily: _kSans,
          fontSize: 14,
          color: _kBody,
        ),
        children: spans,
      ),
      textAlign: TextAlign.center,
    );
  }

  // ── Pil rating ──
  Widget _buildRatingPill() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _kTrack,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _stars(book.rating),
            const SizedBox(width: 10),
            Text(
              book.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontFamily: _kSans,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _kInk,
              ),
            ),
            if (book.readers != null) ...[
              const SizedBox(width: 10),
              const Text(
                '/',
                style: TextStyle(fontSize: 15, color: Color(0xFFC8C8C4)),
              ),
              const SizedBox(width: 10),
              Text(
                '${_fmtNumber(book.readers!)} readers',
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 14,
                  color: _kMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _stars(double rating, {double size = 18}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final v = rating - i;
        final icon = v >= 0.75
            ? Icons.star_rounded
            : v >= 0.25
                ? Icons.star_half_rounded
                : Icons.star_border_rounded;
        return Icon(icon, size: size, color: _kInk);
      }),
    );
  }

  // ── Tab status: Want to Read / Reading / Finished ──
  Widget _buildStatusTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _kTrack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (int i = 0; i < _kStatusLabels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _status = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _status == i ? _kInk : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_status == i && i == 1) ...[
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _kStatusLabels[i],
                        style: TextStyle(
                          fontFamily: _kSans,
                          fontSize: 14,
                          fontWeight:
                              _status == i ? FontWeight.w600 : FontWeight.w500,
                          color: _status == i ? Colors.white : _kBody,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Kartu progres sesi membaca ──
  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'CURRENT SESSION PROGRESS',
                  style: TextStyle(
                    fontFamily: _kSans,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: _kBody,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'p. $_currentPage of ${book.totalPages} ($_percent%)',
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _kInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progressValue,
              minHeight: 6,
              backgroundColor: _kTrack,
              valueColor: const AlwaysStoppedAnimation<Color>(_kInk),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Estimated time left: $_timeLeft',
            style: const TextStyle(
              fontFamily: _kSans,
              fontSize: 13,
              color: _kMuted,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _kInset,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'LAST PAGE',
                  style: TextStyle(
                    fontFamily: _kSans,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    color: _kBody,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 76,
                      child: TextField(
                        controller: _pageCtrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontFamily: _kSerif,
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          color: _kInk,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Text(
                      '/${book.totalPages}',
                      style: const TextStyle(
                        fontFamily: _kSerif,
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        color: _kBody,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _saveProgress,
              icon: const Icon(Icons.bookmark_added_outlined, size: 20),
              label: const Text(
                'Save reading progress',
                style: TextStyle(
                  fontFamily: _kSans,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Overview ──
  Widget _buildOverview() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontFamily: _kSerif,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: _kInk,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: Text(
              book.description,
              maxLines: _expanded ? null : 2,
              overflow: _expanded ? TextOverflow.visible : TextOverflow.fade,
              style: const TextStyle(
                fontFamily: _kSans,
                fontSize: 16,
                height: 1.6,
                color: _kBody,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _expanded ? 'Read less' : 'Read more',
                  style: const TextStyle(
                    fontFamily: _kSans,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _kInk,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: _kInk,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Penilaian pribadi ──
  Widget _buildVerdict() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRIVATE LEDGER',
            style: TextStyle(
              fontFamily: _kSans,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: _kBody,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your Critical Verdict',
            style: TextStyle(
              fontFamily: _kSerif,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: _kInk,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              color: _kInset,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text(
                  'Score',
                  style: TextStyle(
                    fontFamily: _kSans,
                    fontSize: 15,
                    color: _kBody,
                  ),
                ),
                const Spacer(),
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () =>
                        setState(() => _myScore = _myScore == i ? 0 : i),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Icon(
                        i <= _myScore
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 28,
                        color: _kInk,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Marginalia & Excerpts ──
  Widget _buildMarginaliaHeader() {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Marginalia & Excerpts',
                  style: TextStyle(
                    fontFamily: _kSerif,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: _kInk,
                  ),
                ),
                TextSpan(
                  text: '   (${_quotes.length} Saved)',
                  style: const TextStyle(
                    fontFamily: _kSans,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _addQuote,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text(
            'New Quote',
            style: TextStyle(
              fontFamily: _kSans,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: _kInk,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildQuoteCards() {
    if (_quotes.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: const Center(
            child: Text(
              'Belum ada kutipan tersimpan.',
              style: TextStyle(
                fontFamily: _kSans,
                fontSize: 14,
                color: _kMuted,
              ),
            ),
          ),
        ),
      ];
    }

    return [
      for (final q in _quotes)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _QuoteCard(
            quote: q,
            onPost: () => _snack('Fitur posting belum tersedia'),
          ),
        ),
    ];
  }
}

// ─────────────────────── Quote Card ───────────────────────
class _QuoteCard extends StatelessWidget {
  final BookQuote quote;
  final VoidCallback onPost;

  const _QuoteCard({required this.quote, required this.onPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                quote.label.toUpperCase(),
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: _kBody,
                ),
              ),
              const Spacer(),
              const Icon(Icons.bookmark_added_outlined,
                  size: 22, color: _kBody),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '\u201C${quote.text}\u201D',
            style: const TextStyle(
              fontFamily: _kSerif,
              fontSize: 22,
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: _kInk,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onPost,
              icon: const Icon(Icons.ios_share_rounded, size: 18),
              label: const Text(
                'Post',
                style: TextStyle(
                  fontFamily: _kSans,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(foregroundColor: _kBody),
            ),
          ),
        ],
      ),
    );
  }
}