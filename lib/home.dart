import 'package:flutter/material.dart';

void main() => runApp(const TaleMarkApp());

// ───────────────────────── Theme & Constants ─────────────────────────

const kBg = Color(0xFFF7F7F8);
const kCard = Colors.white;
const kInk = Color(0xFF111111);
const kMuted = Color(0xFF6B6B70);
const kChip = Color(0xFFEDEDF0);
const kSerif = 'Georgia'; // ganti dengan font serif pilihan (mis. google_fonts)

class TaleMarkApp extends StatelessWidget {
  const TaleMarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaleMark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBg,
        colorScheme: ColorScheme.fromSeed(seedColor: kInk),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: kBg,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
                fontSize: 11,
                fontWeight:
                    s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
                color: s.contains(WidgetState.selected) ? kInk : kMuted,
              )),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ───────────────────────── Data Models ─────────────────────────

class Book {
  final String title, author, genre;
  final double rating;
  final int? pages;
  final int? match;
  final String? note;
  final String? friends;

  const Book({
    required this.title,
    required this.author,
    this.genre = '',
    required this.rating,
    this.pages,
    this.match,
    this.note,
    this.friends,
  });
}

const kaftaPicks = [
  Book(title: 'The Trial', author: 'Franz Kafka', rating: 4.3, pages: 228, match: 98),
  Book(title: 'The Stranger', author: 'Albert Camus', rating: 4.5, pages: 123, match: 94),
  Book(title: 'Blindness', author: 'José Saramago', rating: 4.2, pages: 352, match: 91),
];

const trending = [
  Book(
      title: "If on a winter's night a traveler",
      author: 'Italo Calvino',
      genre: 'METANARRATIVE',
      rating: 4.6,
      pages: 260,
      friends: '14 friends read this'),
  Book(
      title: 'Ficciones',
      author: 'Jorge Luis Borges',
      genre: 'SHORT STORIES',
      rating: 4.7,
      pages: 174,
      note: 'Philosophical canon'),
  Book(
      title: 'The Myth of Sisyphus',
      author: 'Albert Camus',
      genre: 'ESSAY · EXISTENTIALISM',
      rating: 4.5,
      pages: 212,
      note: 'Trending this week'),
];

// ───────────────────────── Home Screen ─────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  int _chip = 0;
  final _chips = const ['All', 'Fiction', 'Philosophy', 'Sci-Fi'];

  // ── state pop up tombol + ──
  bool _menuOpen = false;

  void _toggleMenu() => setState(() => _menuOpen = !_menuOpen);
  void _closeMenu() => setState(() => _menuOpen = false);

  void _onAddBook() {
    _closeMenu();
    // TODO: arahkan ke halaman Tambah Buku, mis.
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBookPage()));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Add Book dipilih')));
  }

  void _onSetTimer() {
    _closeMenu();
    // TODO: arahkan ke halaman Pomodoro / Set Timer
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Set Timer dipilih')));
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFabMenu() {
    return IgnorePointer(
      ignoring: !_menuOpen,
      child: AnimatedScale(
        scale: _menuOpen ? 1 : 0.6,
        alignment: Alignment.bottomRight,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _menuOpen ? 1 : 0,
          duration: const Duration(milliseconds: 160),
          child: Material(
            color: kInk,
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuItem(Icons.book, 'Add Book', _onAddBook),
                  _menuItem(Icons.schedule, 'Set Timer', _onSetTimer),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 90),
              children: [
                const _Header(),
                const _SearchBar(),
                const SizedBox(height: 10),
                _buildChips(),
                const SizedBox(height: 14),
                const _ScanCard(),
                const SizedBox(height: 20),
                const _SectionTitle(eyebrow: 'SELECTED EDITION', title: 'Recommendation'),
                const SizedBox(height: 10),
                const _FeaturedCard(),
                const SizedBox(height: 22),
                const SizedBox(height: 10),
                _buildAffinityList(),
                const SizedBox(height: 22),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Trending Now',
                      style: TextStyle(
                          fontFamily: kSerif, fontSize: 20, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
                for (final b in trending) _TrendingTile(book: b),
              ],
            ),
          ),
          // area transparan: tap di luar menu untuk menutup
          if (_menuOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeMenu,
                child: const SizedBox.expand(),
              ),
            ),
          // menu pop up di atas tombol + (FAB 50 + margin 16 + jarak 8)
          Positioned(right: 16, bottom: 16 + 50 + 8, child: _buildFabMenu()),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          onPressed: _toggleMenu,
          backgroundColor: kInk,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: AnimatedRotation(
            turns: _menuOpen ? 0.125 : 0, // + berputar jadi ×
            duration: const Duration(milliseconds: 160),
            child: const Icon(Icons.add, size: 24),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        height: 62,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 22),
              selectedIcon: Icon(Icons.home, size: 22),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined, size: 22),
              selectedIcon: Icon(Icons.menu_book, size: 22),
              label: 'Library'),
          NavigationDestination(
              icon: Icon(Icons.explore_outlined, size: 22),
              selectedIcon: Icon(Icons.explore, size: 22),
              label: 'Feed'),
          NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined, size: 22),
              selectedIcon: Icon(Icons.bar_chart, size: 22),
              label: 'Stats'),
          NavigationDestination(
              icon: Icon(Icons.account_circle_outlined, size: 22),
              selectedIcon: Icon(Icons.account_circle, size: 22),
              label: 'Account'),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (int i = 0; i < _chips.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(_chips[i]),
                selected: _chip == i,
                onSelected: (_) => setState(() => _chip = i),
                showCheckmark: false,
                selectedColor: kInk,
                backgroundColor: kChip,
                side: BorderSide.none,
                shape: const StadiumBorder(),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _chip == i ? Colors.white : kInk,
                ),
              ),
            ),
          ActionChip(
            avatar: const Icon(Icons.tune, size: 14, color: kMuted),
            label: const Text('More', style: TextStyle(color: kMuted, fontSize: 12)),
            onPressed: () {},
            backgroundColor: kChip,
            side: BorderSide.none,
            shape: const StadiumBorder(),
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            labelPadding: const EdgeInsets.symmetric(horizontal: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildAffinityList() {
    return SizedBox(
      height: 245,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kaftaPicks.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _AffinityCard(book: kaftaPicks[i]),
      ),
    );
  }
}

// ───────────────────────── Header & Search ─────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo_talemark.png',
            height: 36,
            width: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const Text('TaleMark',
              style: TextStyle(fontFamily: kSerif, fontSize: 20, fontWeight: FontWeight.w600)),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, size: 24, color: kMuted)),
              Positioned(
                right: 10,
                top: 8,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: kInk, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search, color: kMuted, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search books, authors, ISBN, genres…',
                  hintStyle: TextStyle(color: kMuted, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: kChip,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(Icons.qr_code_scanner, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Scan Card ─────────────────────────

class _ScanCard extends StatelessWidget {
  const _ScanCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.photo_camera_outlined, size: 18),
              SizedBox(width: 6),
              Text('INSTANT SHELF SCAN',
                  style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.8, fontSize: 11)),
            ]),
            SizedBox(height: 6),
            Text('Scan any book spine or barcode to log in seconds.',
                style: TextStyle(fontFamily: kSerif, fontSize: 15, fontWeight: FontWeight.w600, height: 1.25)),
            SizedBox(height: 4),
            Text('Autofills publication date, page count, and editions.',
                style: TextStyle(color: kMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Section Title ─────────────────────────

class _SectionTitle extends StatelessWidget {
  final String eyebrow, title;
  final bool small;
  const _SectionTitle({required this.eyebrow, required this.title}) : small = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow,
              style: const TextStyle(
                  color: kMuted, letterSpacing: 1.0, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(title,
              style: TextStyle(
                  fontFamily: kSerif, fontSize: small ? 18 : 22, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ───────────────────────── Shared Widgets ─────────────────────────

class _Stars extends StatelessWidget {
  final double rating;
  const _Stars(this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(i <= rating.round() ? Icons.star : Icons.star_border, size: 15),
        const SizedBox(width: 4),
        Text(rating.toString(), style: const TextStyle(color: kMuted, fontSize: 13)),
      ],
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  final double? width, height;
  const _CoverPlaceholder({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
    );
  }
}

// ───────────────────────── Featured Card ─────────────────────────

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Stack(
              children: [
                Container(
                  width: 95,
                  height: 140,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF4FB4D8), Color(0xFFBEE6F2)],
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x22000000), blurRadius: 6, offset: Offset(0, 3))
                    ],
                  ),
                  child: const Text('HUJAN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1)),
                ),
                Positioned(
                  left: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration:
                        BoxDecoration(color: kInk, borderRadius: BorderRadius.circular(4)),
                    child: const Text('Staff',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('FIKSI ILMIAH, DISTOPIA, ROMANCE',
                      style: TextStyle(
                          color: kMuted, fontSize: 10, letterSpacing: 0.8, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  const Text('Hujan',
                      style: TextStyle(fontFamily: kSerif, fontSize: 18, fontWeight: FontWeight.w600)),
                  const Text('Tere Liye · 2016', style: TextStyle(color: kMuted, fontSize: 12)),
                  const SizedBox(height: 4),
                  const _Stars(4.4),
                  const SizedBox(height: 6),
                  const Text(
                    'Novel Hujan mengisahkan Lail yang berjuang mengatasi trauma masa lalu dan kerinduan.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: kMuted, fontSize: 11, height: 1.35),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                            label: const Text('+Library',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            style: FilledButton.styleFrom(
                              backgroundColor: kInk,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.horizontal(left: Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 38,
                        decoration: const BoxDecoration(
                          color: kChip,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                        ),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: const Icon(Icons.visibility_outlined, size: 18)),
                      ),
                    ],
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

// ───────────────────────── Affinity Card ─────────────────────────

class _AffinityCard extends StatelessWidget {
  final Book book;
  const _AffinityCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 165,
            decoration:
                BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Positioned(
                  right: 6,
                  top: 6,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 1.5,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
                      child: const Padding(
                          padding: EdgeInsets.all(5), child: Icon(Icons.add, size: 16)),
                    ),
                  ),
                ),
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration:
                        BoxDecoration(color: kInk, borderRadius: BorderRadius.circular(4)),
                    child: Text('${book.match}% match',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: kSerif, fontSize: 14, fontWeight: FontWeight.w600)),
          Text(book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: kMuted, fontSize: 11)),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(Icons.star_border, size: 14),
              const SizedBox(width: 3),
              Text('${book.rating}', style: const TextStyle(fontSize: 12)),
              const Spacer(),
              Text('${book.pages}p', style: const TextStyle(color: kMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Trending Tile ─────────────────────────

class _TrendingTile extends StatelessWidget {
  final Book book;
  const _TrendingTile({required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CoverPlaceholder(width: 70, height: 105),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 105,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(book.genre,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: kMuted,
                                  fontSize: 10,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const Icon(Icons.star_border, size: 14),
                        const SizedBox(width: 2),
                        Text('${book.rating}', style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: kSerif, fontSize: 15, fontWeight: FontWeight.w600, height: 1.15)),
                    const SizedBox(height: 2),
                    Text('${book.author} · ${book.pages} pages',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: kMuted, fontSize: 11)),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(book.friends ?? book.note ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: kMuted, fontWeight: FontWeight.w600, fontSize: 10)),
                        ),
                        SizedBox(
                          height: 30,
                          child: FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: const Icon(Icons.bookmark_add_outlined, size: 14),
                            label: const Text('Add', style: TextStyle(fontSize: 11)),
                            style: FilledButton.styleFrom(
                              backgroundColor: kChip,
                              foregroundColor: kInk,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}