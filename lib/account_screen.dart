import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'widgets/setting_screen.dart';

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

/// Hanya untuk preview layar ini secara terpisah.
/// Aplikasi sebenarnya tetap dijalankan dari main.dart.
void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: AccountScreen()),
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

// ─────────────────────── Data profil & feed (dummy) ───────────────────────
const _kName = 'Agustina';
const _kHandle = '@agussmahtuah';
const _kBio =
    'Collecting editions, marginalia, and quiet hours. 34 books read this year.';

enum _PostKind { finished, notes }

class _FeedPost {
  final _PostKind kind;
  final String time; // '2 hours ago'
  final String detail; // 'Milan, Italy' atau 'Page 112'
  final String bookTitle;
  final String author;
  final double rating; // dipakai untuk post "finished"
  final String? coverAsset;
  final String text; // ulasan atau kutipan
  final String? marginalia; // catatan tepi (post "notes")
  final int likes;
  final int comments;

  const _FeedPost({
    required this.kind,
    required this.time,
    required this.detail,
    required this.bookTitle,
    required this.author,
    required this.text,
    this.rating = 0,
    this.marginalia,
    this.likes = 0,
    this.comments = 0,
  }) : coverAsset = null;
}

const List<_FeedPost> _posts = [
  _FeedPost(
    kind: _PostKind.finished,
    time: '2 hours ago',
    detail: 'Milan, Italy',
    bookTitle: 'Invisible Cities',
    author: 'Italo Calvino',
    rating: 5.0,
    text: 'A dreamlike tour of imagined cities, told in quiet little portraits. An absolute masterpiece of architectural imagination.',
    likes: 42,
    comments: 9,
  ),
  _FeedPost(
    kind: _PostKind.notes,
    time: '5 hours ago',
    detail: 'Page 112',
    bookTitle: 'The Stranger',
    author: 'Albert Camus',
    text: 'A sentence worth underlining, kept here for quiet hours and slow rereading.',
    marginalia: 'Pencil underlined, 1954 Vintage edition.',
  ),
];

// ─────────────────────── Account Screen ───────────────────────
class AccountScreen extends StatelessWidget {
  /// Tampilkan bottom navigation bar bawaan layar ini.
  /// Set false kalau navigasi sudah ditangani di main.dart / shell lain.
  final bool showBottomNav;

  /// Dipanggil saat item bottom nav ditekan (0 Home … 4 Account).
  final ValueChanged<int>? onNavTap;

  const AccountScreen({super.key, this.showBottomNav = true, this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      bottomNavigationBar: showBottomNav
          ? _BottomNav(currentIndex: 4, onTap: onNavTap)
          : null,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            const _ProfileCard(),
            const SizedBox(height: 24),
            const _FeedTab(),
            const SizedBox(height: 20),
            for (final post in _posts) ...[
              _FeedCard(post: post),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Profile Card ───────────────────────
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _Avatar(size: 56, showBadge: true),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _kName,
                      style: TextStyle(
                        fontFamily: _kSerif,
                        fontSize: 22, // was 28
                        fontWeight: FontWeight.w500,
                        color: _kInk,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      _kHandle,
                      style: TextStyle(
                        fontFamily: _kSans,
                        fontSize: 12.5, // was 14
                        color: _kMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 22, // was 26
                      color: _kBody,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 11,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: _kInk,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(
                        onLogout: () {
                          // Keluar: buka halaman Login dan hapus semua halaman sebelumnya
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.tune_rounded,
                  size: 22, // was 26
                  color: _kBody,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            _kBio,
            style: TextStyle(
              fontFamily: _kSans,
              fontSize: 14, // was 16
              height: 1.6,
              color: _kBody,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _kInset,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: _Stat(value: '34', label: 'BOOKS'),
                ),
                Expanded(
                  child: _Stat(value: '412', label: 'FOLLOWERS'),
                ),
                Expanded(
                  child: _Stat(value: '180', label: 'FOLLOWING'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: _kSerif,
            fontSize: 20, // was 26
            fontWeight: FontWeight.w500,
            color: _kInk,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: _kSans,
            fontSize: 10.5, // was 12
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
            color: _kBody,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────── Avatar ───────────────────────
class _Avatar extends StatelessWidget {
  final double size;
  final bool showBadge;

  const _Avatar({required this.size, this.showBadge = false});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: const Color(0xFFDADAD5),
      alignment: Alignment.center,
      child: Text(
        _kName.substring(0, 1),
        style: TextStyle(
          fontFamily: _kSerif,
          fontSize: size * 0.45,
          fontWeight: FontWeight.w500,
          color: _kBody,
        ),
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipOval(
              child: Image.asset(
                'assets/images/avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
            ),
          ),
          if (showBadge)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: _kInk,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────── Tab "My Feed" ───────────────────────
class _FeedTab extends StatelessWidget {
  const _FeedTab();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _kTrack.withAlpha(180),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dynamic_feed_outlined,
              size: 18,
              color: _kBody,
            ), // was 20
            SizedBox(width: 22),
            Text(
              'My Feed',
              style: TextStyle(
                fontFamily: _kSans,
                fontSize: 14, // was 16
                fontWeight: FontWeight.w500,
                color: _kInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Feed Card ───────────────────────
class _FeedCard extends StatefulWidget {
  final _FeedPost post;

  const _FeedCard({required this.post});

  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard> {
  bool _liked = false;
  bool _saved = false;

  _FeedPost get post => widget.post;

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = post.kind == _PostKind.finished;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris atas: avatar + aktivitas + waktu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Avatar(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontFamily: _kSans,
                          fontSize: 14, // was 16
                          color: _kInk,
                        ),
                        children: [
                          const TextSpan(
                            text: _kName,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: isFinished
                                ? ' finished a book'
                                : ' shared notes',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${post.time} · ${post.detail}',
                      style: const TextStyle(
                        fontFamily: _kSans,
                        fontSize: 11.5, // was 13
                        fontWeight: FontWeight.w500,
                        color: _kBody,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isFinished) ..._buildFinished() else ..._buildNotes(),
        ],
      ),
    );
  }

  // ── Isi post "finished a book" ──
  List<Widget> _buildFinished() {
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kInset,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MiniCover(asset: post.coverAsset),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.bookTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: _kSerif,
                        fontSize: 18, // was 22
                        fontWeight: FontWeight.w500,
                        color: _kInk,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: _kSans,
                        fontSize: 12.5, // was 14
                        color: _kMuted,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Icon(
                            i < post.rating.floor()
                                ? Icons.star_rounded
                                : (i < post.rating
                                      ? Icons.star_half_rounded
                                      : Icons.star_border_rounded),
                            size: 16, // was 18
                            color: _kInk,
                          ),
                        const SizedBox(width: 10),
                        Text(
                          post.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: _kSans,
                            fontSize: 12, // was 13
                            fontWeight: FontWeight.w500,
                            color: _kBody,
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
      const SizedBox(height: 16),
      Text(
        '\u201C${post.text}\u201D',
        style: const TextStyle(
          fontFamily: _kSans,
          fontSize: 14, // was 16
          height: 1.6,
          color: _kBody,
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          _ActionButton(
            icon: _liked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            label: '${post.likes + (_liked ? 1 : 0)}',
            onTap: () => setState(() => _liked = !_liked),
          ),
          const SizedBox(width: 22),
          _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: '${post.comments}',
            onTap: () {},
          ),
          const SizedBox(width: 22),
          _ActionButton(
            icon: _saved
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            onTap: () => setState(() => _saved = !_saved),
          ),
          const Spacer(),
          _ActionButton(
            icon: Icons.share_outlined,
            onTap: () => _snack('Fitur bagikan belum tersedia'),
          ),
        ],
      ),
    ];
  }

  // ── Isi post "shared notes" ──
  List<Widget> _buildNotes() {
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 18, 16, 20),
        decoration: BoxDecoration(
          color: _kInset,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book_outlined, size: 16, color: _kBody),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${post.bookTitle.toUpperCase()} · ${post.author.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: _kSans,
                      fontSize: 10.5, // was 12
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: _kBody,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _saved = !_saved),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      _saved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      size: 20,
                      color: _kInk,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '\u201C${post.text}\u201D',
              style: const TextStyle(
                fontFamily: _kSerif,
                fontSize: 22, // was 28
                height: 1.4,
                color: _kInk,
              ),
            ),
            if (post.marginalia != null) ...[
              const SizedBox(height: 16),
              Text(
                'Marginalia Note: \u201C${post.marginalia}\u201D',
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 12, // was 13
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: _kBody,
                ),
              ),
            ],
          ],
        ),
      ),
    ];
  }
}

// ─────────────────────── Komponen kecil ───────────────────────
class _MiniCover extends StatelessWidget {
  final String? asset;

  const _MiniCover({this.asset});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(color: Colors.white);

    return Container(
      width: 58,
      height: 88,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: asset == null
            ? placeholder
            : Image.asset(
                asset!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: _kBody), // was 24
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 13, // was 15
                  fontWeight: FontWeight.w600,
                  color: _kBody,
                ),
              ),
            ],
          ],
        ),
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
                          size: 22, // was 24
                          color: i == currentIndex ? _kInk : _kMuted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _items[i].$3,
                          style: TextStyle(
                            fontFamily: _kSans,
                            fontSize: 10, // was 11
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
