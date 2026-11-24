import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────── Konstanta desain ───────────────────────
const _kBg = Color(0xFFFAFAF8);
const _kCard = Colors.white;
const _kInk = Color(0xFF111111);
const _kMuted = Color(0xFF8A8A86);
const _kBody = Color(0xFF4A4A48);
const _kTrack = Color(0xFFF1F1EF);
const _kInset = Color(0xFFF4F4F2);
const _kChip = Color(0xFFEFEFED);
const _kSerif = 'Newsreader';
const _kSans = 'Inter';
const _kAmber = Color(0xFFFFA726);

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

// ─────────────────────── Model Kutipan ───────────────────────
class SavedQuote {
  final String bookTitle;
  final String author;
  final String label; // e.g. 'PAGE 42', 'ENDING', 'PEMBUKA'
  final String text;
  final String? coverAsset;
  bool isFavorite;

  SavedQuote({
    required this.bookTitle,
    required this.author,
    required this.label,
    required this.text,
    this.coverAsset,
    this.isFavorite = false,
  });
}

// ─────────────────────── Dummy data ───────────────────────
final List<SavedQuote> _allQuotes = [
  SavedQuote(
    bookTitle: 'Hujan',
    author: 'Tere Liye',
    label: 'ENDING',
    text: 'Bukan seberapa lama umat manusia bisa bertahan hidup sebagai ukuran kebahagiaan, tapi seberapa besar kemampuan mereka memeluk erat-erat semua hal menyakitkan yang mereka alami.',
    coverAsset: 'assets/images/hujan.jpeg',
    isFavorite: true,
  ),
  SavedQuote(
    bookTitle: 'Hujan',
    author: 'Tere Liye',
    label: 'HALAMAN 77',
    text: 'Jangan pernah menyesal mengenal seseorang dalam hidupmu. Karena dalam setiap pengalaman buruk, ada pelajaran yang bisa diambil.',
    coverAsset: 'assets/images/hujan.jpeg',
    isFavorite: true,
  ),
  SavedQuote(
    bookTitle: 'Aldebaran',
    author: 'Tere Liye',
    label: 'PEMBUKA',
    text: 'Ketika seseorang memutuskan untuk pergi, biarkan dia pergi. Takdirmu tidak pernah bergantung pada siapapun yang meninggalkanmu.',
    coverAsset: 'assets/images/aldebaran.jpeg',
    isFavorite: true,
  ),
  SavedQuote(
    bookTitle: 'The Stranger',
    author: 'Albert Camus',
    label: 'HALAMAN 112',
    text: 'In the depth of winter, I finally learned that within me there lay an invincible summer.',
    isFavorite: false,
  ),
  SavedQuote(
    bookTitle: 'Invisible Cities',
    author: 'Italo Calvino',
    label: 'HALAMAN 55',
    text: 'Kota-kota, seperti mimpi, dibangun dari keinginan dan ketakutan.',
    isFavorite: true,
  ),
  SavedQuote(
    bookTitle: 'The Myth of Sisyphus',
    author: 'Albert Camus',
    label: 'PENUTUP',
    text: 'One must imagine Sisyphus happy.',
    isFavorite: false,
  ),
  SavedQuote(
    bookTitle: 'Ficciones',
    author: 'Jorge Luis Borges',
    label: 'HALAMAN 23',
    text: 'Waktu bercabang terus-menerus menuju tak terhitung masa depan.',
    isFavorite: true,
  ),
];

// ─────────────────────── Filter ───────────────────────
enum _QuoteFilter { semua, favorit }

// ─────────────────────── Kutipan Favorit Screen ───────────────────────
class KutipanFavoritScreen extends StatefulWidget {
  const KutipanFavoritScreen({super.key});

  @override
  State<KutipanFavoritScreen> createState() => _KutipanFavoritScreenState();
}

class _KutipanFavoritScreenState extends State<KutipanFavoritScreen> {
  _QuoteFilter _filter = _QuoteFilter.semua;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  List<SavedQuote> get _filteredQuotes {
    var list = _allQuotes.toList();
    if (_filter == _QuoteFilter.favorit) {
      list = list.where((q) => q.isFavorite).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((q) =>
        q.text.toLowerCase().contains(query) ||
        q.bookTitle.toLowerCase().contains(query) ||
        q.author.toLowerCase().contains(query)
      ).toList();
    }
    return list;
  }

  int get _totalFavorites => _allQuotes.where((q) => q.isFavorite).length;

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ));
  }

  Future<void> _addNewQuote() async {
    final bookCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final quoteCtrl = TextEditingController();
    final pageCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Kutipan Baru',
          style: TextStyle(
            fontFamily: _kSerif,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bookCtrl,
                decoration: InputDecoration(
                  labelText: 'Judul Buku',
                  filled: true,
                  fillColor: _kInset,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: authorCtrl,
                decoration: InputDecoration(
                  labelText: 'Penulis',
                  filled: true,
                  fillColor: _kInset,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pageCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Halaman (opsional)',
                  filled: true,
                  fillColor: _kInset,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: quoteCtrl,
                autofocus: true,
                minLines: 3,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Kutipan',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: _kInset,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: _kBody)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: _kInk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final book = bookCtrl.text.trim();
      final author = authorCtrl.text.trim();
      final quote = quoteCtrl.text.trim();
      final page = pageCtrl.text.trim();

      if (book.isEmpty || quote.isEmpty) {
        _snack('Judul buku dan kutipan tidak boleh kosong');
        return;
      }

      setState(() {
        _allQuotes.insert(0, SavedQuote(
          bookTitle: book,
          author: author.isEmpty ? 'Penulis' : author,
          label: page.isNotEmpty ? 'HALAMAN $page' : 'CATATAN',
          text: quote,
          isFavorite: false,
        ));
      });
      _snack('Kutipan baru berhasil disimpan');
    }

    bookCtrl.dispose();
    authorCtrl.dispose();
    quoteCtrl.dispose();
    pageCtrl.dispose();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotes = _filteredQuotes;

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Top bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_rounded, color: _kInk, size: 22),
                    ),
                    const Expanded(
                      child: Text(
                        'Kutipan Favorit',
                        style: TextStyle(
                          fontFamily: _kSerif,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: _kInk,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addNewQuote,
                      tooltip: 'Tambah kutipan',
                      icon: const Icon(Icons.add_rounded, color: _kInk, size: 24),
                    ),
                  ],
                ),
              ),
            ),

            // ── Statistik kutipan ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _kInset,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _QuoteStat(
                        icon: Icons.format_quote_rounded,
                        value: '${_allQuotes.length}',
                        label: 'Total Kutipan',
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: _kTrack,
                      ),
                      _QuoteStat(
                        icon: Icons.star_rounded,
                        value: '$_totalFavorites',
                        label: 'Favorit',
                        iconColor: _kAmber,
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: _kTrack,
                      ),
                      _QuoteStat(
                        icon: Icons.menu_book_rounded,
                        value: '${_allQuotes.map((q) => q.bookTitle).toSet().length}',
                        label: 'Buku',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Search bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: _kCard,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontFamily: _kSans, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Cari kutipan, buku, atau penulis…',
                      hintStyle: const TextStyle(color: _kMuted, fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded, color: _kMuted, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                            icon: const Icon(Icons.close_rounded, color: _kMuted, size: 18),
                          )
                        : null,
                      filled: true,
                      fillColor: _kCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),

            // ── Filter chips ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Semua',
                      count: _allQuotes.length,
                      isSelected: _filter == _QuoteFilter.semua,
                      onTap: () => setState(() => _filter = _QuoteFilter.semua),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: '⭐ Favorit',
                      count: _totalFavorites,
                      isSelected: _filter == _QuoteFilter.favorit,
                      onTap: () => setState(() => _filter = _QuoteFilter.favorit),
                    ),
                  ],
                ),
              ),
            ),

            // ── Quote list ──
            if (quotes.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          _filter == _QuoteFilter.favorit
                            ? Icons.star_border_rounded
                            : Icons.format_quote_rounded,
                          size: 48,
                          color: _kTrack,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _filter == _QuoteFilter.favorit
                            ? 'Belum ada kutipan favorit'
                            : 'Belum ada kutipan tersimpan',
                          style: const TextStyle(
                            fontFamily: _kSans,
                            fontSize: 15,
                            color: _kMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tambahkan kutipan dari buku yang kamu baca',
                          style: TextStyle(
                            fontFamily: _kSans,
                            fontSize: 13,
                            color: _kMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _QuoteCard(
                        quote: quotes[index],
                        onToggleFavorite: () {
                          setState(() {
                            quotes[index].isFavorite = !quotes[index].isFavorite;
                          });
                          _snack(
                            quotes[index].isFavorite
                              ? 'Kutipan ditandai sebagai favorit ⭐'
                              : 'Kutipan dihapus dari favorit',
                          );
                        },
                        onCopy: () {
                          Clipboard.setData(ClipboardData(text: quotes[index].text));
                          _snack('Kutipan disalin ke clipboard');
                        },
                        onShare: () {
                          _snack('Fitur berbagi kutipan segera hadir');
                        },
                        onDelete: () {
                          final removed = quotes[index];
                          setState(() {
                            _allQuotes.remove(removed);
                          });
                          _snack('Kutipan dihapus');
                        },
                      ),
                    ),
                    childCount: quotes.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Statistik kutipan ───────────────────────
class _QuoteStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;

  const _QuoteStat({
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: iconColor ?? _kInk),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: _kSerif,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _kInk,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: _kSans,
              fontSize: 11,
              color: _kMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Filter Chip ───────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? _kInk : _kChip,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: _kSans,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : _kBody,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withAlpha(50) : _kTrack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontFamily: _kSans,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : _kMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Quote Card ───────────────────────
class _QuoteCard extends StatelessWidget {
  final SavedQuote quote;
  final VoidCallback onToggleFavorite;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const _QuoteCard({
    required this.quote,
    required this.onToggleFavorite,
    required this.onCopy,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final coverPlaceholder = Container(
      decoration: BoxDecoration(
        color: _kInk.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Icon(Icons.menu_book_rounded, size: 16, color: _kMuted),
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Baris atas: info buku + favorit ──
          Row(
            children: [
              // Mini cover
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 28,
                  height: 40,
                  child: quote.coverAsset != null
                    ? Image.asset(
                        quote.coverAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => coverPlaceholder,
                      )
                    : coverPlaceholder,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.bookTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: _kSerif,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _kInk,
                      ),
                    ),
                    Text(
                      '${quote.author} · ${quote.label}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: _kSans,
                        fontSize: 11.5,
                        color: _kMuted,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onToggleFavorite,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    quote.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 24,
                    color: quote.isFavorite ? _kAmber : _kBody,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Kutipan ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: _kInset,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '\u201C${quote.text}\u201D',
              style: const TextStyle(
                fontFamily: _kSerif,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.5,
                color: _kInk,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Tombol aksi ──
          Row(
            children: [
              _ActionBtn(
                icon: Icons.copy_rounded,
                label: 'Salin',
                onTap: onCopy,
              ),
              const SizedBox(width: 6),
              _ActionBtn(
                icon: Icons.share_rounded,
                label: 'Bagikan',
                onTap: onShare,
              ),
              const Spacer(),
              _ActionBtn(
                icon: Icons.delete_outline_rounded,
                onTap: onDelete,
                isDanger: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Action Button ───────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final bool isDanger;

  const _ActionBtn({
    required this.icon,
    required this.onTap,
    this.label,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? const Color(0xFFC62828) : _kBody;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label!,
                style: TextStyle(
                  fontFamily: _kSans,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
