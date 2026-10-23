import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: FeedPage(),
));

const _bg = Color(0xFFF9F8F5);
const _card = Colors.white;
const _ink = Color(0xFF111111);
const _muted = Color(0xFF6B6B70);
const _chip = Color(0xFFF1F0EE);
const _accent = Color(0xFFB45F06);
const _accentBg = Color(0xFFFCEFD2);
const _serif = 'Georgia';

const _quoteText =
    'Bukan seberapa lama umat manusia bisa bertahan hidup sebagai ukuran kebahagiaan, '
    'tapi seberapa besar kemampuan mereka memeluk erat-erat semua hal menyakitkan yang mereka alami.';

const _descText =
    'Novel Hujan mengisahkan Lail yang berjuang mengatasi trauma masa lalu dan kerinduan '
    'mendalam pada sahabatnya, Esok. Di tengah dunia masa depan, Lail hampir menghapus '
    'ingatannya demi menghilangkan rasa sakit itu. Namun, ia akhirnya menyadari bahwa '
    'kebahagiaan sejati diraih dengan menerima dan berdamai dengan setiap kepedihan.';

// ═══════════════════════════════════════════════════════════════
//  1. FEED PAGE
// ═══════════════════════════════════════════════════════════════

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const _FeedHeader(),
            const SizedBox(height: 6),
            _TabChips(
              labels: const ['Aktivitas', 'Catatan Pinggir', 'Klub'],
              trailing: PopupMenuButton<String>(
                onSelected: (_) {},
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'terbaru', child: Text('Terbaru')),
                  PopupMenuItem(value: 'populer', child: Text('Populer')),
                ],
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('TERBARU',
                        style: TextStyle(
                            color: _muted, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                    Icon(Icons.keyboard_arrow_down, color: _muted),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _Composer(),
            const SizedBox(height: 16),
            const _QuotePostCard(
              name: 'Julian Mahesa',
              handle: '@julianm',
              time: '2 JAM LALU',
              showReadingLabel: true,
              avatarColors: [Color(0xFF5B3A29), Color(0xFFB08968)],
            ),
            const SizedBox(height: 16),
            const _DiscussionPostCard(),
          ],
        ),
      ),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('TaleMark',
              style: TextStyle(fontFamily: _serif, fontSize: 28, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('· FEED',
                style: TextStyle(color: _muted, fontSize: 13, letterSpacing: 1.5)),
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: _muted, size: 28)),
          Stack(children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: _muted, size: 28)),
            Positioned(
              right: 12,
              top: 10,
              child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(color: _ink, shape: BoxShape.circle)),
            ),
          ]),
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune, color: _muted, size: 28)),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
            icon: const Icon(Icons.account_circle_outlined, color: _muted, size: 26),
            tooltip: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            const _Avatar(size: 52, colors: [Color(0xFF6D4C41), Color(0xFFD7B899)]),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => showShareQuoteSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration:
                      BoxDecoration(color: _chip, borderRadius: BorderRadius.circular(14)),
                  child: const Text('Bagikan kutipan atau refleksi bacaan hari ini…',
                      style: TextStyle(color: _muted, fontSize: 17, height: 1.4)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscussionPostCard extends StatelessWidget {
  const _DiscussionPostCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _Avatar(size: 48, colors: [Color(0xFF37474F), Color(0xFF90A4AE)]),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text('Marcus Chen',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        SizedBox(width: 8),
                        Text('•  @marcusread', style: TextStyle(color: _muted, fontSize: 15)),
                      ]),
                      SizedBox(height: 2),
                      Text('KEMARIN',
                          style: TextStyle(
                              color: _muted, fontSize: 13, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                _Pill(label: 'Diskusi', bg: _chip, fg: _muted, bold: true),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: _chip, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text('THE STRANGER — ALBERT CAMUS',
                            style: TextStyle(
                                color: _muted,
                                fontSize: 13,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Text('Edisi Cetak 1954',
                            style: TextStyle(color: _muted, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '“In the depth of winter, I finally learned that within me there lay an invincible summer.”',
                    style: TextStyle(
                        fontFamily: _serif,
                        fontStyle: FontStyle.italic,
                        fontSize: 22,
                        height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: _chip, borderRadius: BorderRadius.circular(14)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('Nadia Pramudita',
                        style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    SizedBox(width: 10),
                    Text('18 jam lalu', style: TextStyle(color: _muted, fontSize: 13)),
                  ]),
                  SizedBox(height: 6),
                  Text(
                    'Selalu menemukan kekuatan baru dari baris ini setiap kali menghadapi masa-masa sulit dalam penulisan tesis.',
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _PostActions(likes: 64, commentLabel: '19 Komentar', showShare: false),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  2. PROFILE PAGE
// ═══════════════════════════════════════════════════════════════

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 22)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.share_outlined, color: _muted)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                ],
              ),
            ),
            // avatar + follow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const _Avatar(size: 100, colors: [Color(0xFF4E342E), Color(0xFFA1887F)]),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _ink,
                            shape: BoxShape.circle,
                            border: Border.all(color: _bg, width: 2),
                          ),
                          child: const Icon(Icons.verified, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => setState(() => _following = !_following),
                    icon: Icon(_following ? Icons.check : Icons.add),
                    label: Text(_following ? 'Mengikuti' : 'Ikuti'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _following ? _chip : _ink,
                      foregroundColor: _following ? _ink : Colors.white,
                      minimumSize: const Size(0, 46),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                        color: _chip, borderRadius: BorderRadius.circular(14)),
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.auto_stories_outlined)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Julian Mahesa',
                      style: TextStyle(
                          fontFamily: _serif, fontSize: 32, fontWeight: FontWeight.w600)),
                  SizedBox(height: 2),
                  Text('@julianm', style: TextStyle(color: _muted, fontSize: 17)),
                  SizedBox(height: 10),
                  Text(
                    'Menjelajahi fiksi spekulatif, arsitektur imajinasi, dan filsafat eksistensial. '
                    'Menulis catatan pinggir di malam hari.',
                    style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _StatsCard(),
            const SizedBox(height: 18),
            const _TabChips(labels: ['Semua Feed', 'Catatan & Kutipan', 'Ulasan Buku']),
            const SizedBox(height: 14),
            const _QuotePostCard(
              name: 'Julian Mahesa',
              handle: '@julianm',
              time: '2 JAM LALU',
              bigQuote: true,
              avatarColors: [Color(0xFF7CB342), Color(0xFF81D4FA)],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    Widget stat(String n, String l) => Expanded(
          child: Column(children: [
            Text(n,
                style: const TextStyle(
                    fontFamily: _serif, fontSize: 28, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(l, style: const TextStyle(color: _muted, fontSize: 15)),
          ]),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: _chip, borderRadius: BorderRadius.circular(22)),
        child: Row(children: [
          stat('42', 'Buku'),
          stat('185', 'Kutipan'),
          stat('1.2k', 'Pengikut'),
          stat('320', 'Mengikuti'),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  3. SHARED: kartu kutipan, tab chips, aksi, avatar, dll.
// ═══════════════════════════════════════════════════════════════

class _QuotePostCard extends StatelessWidget {
  final String name, handle, time;
  final bool showReadingLabel;
  final bool bigQuote;
  final List<Color> avatarColors;

  const _QuotePostCard({
    required this.name,
    required this.handle,
    required this.time,
    required this.avatarColors,
    this.showReadingLabel = false,
    this.bigQuote = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              children: [
                _Avatar(size: 48, colors: avatarColors),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                          child: Text(name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: bigQuote ? _serif : null,
                                  fontWeight: bigQuote ? FontWeight.w600 : FontWeight.w700,
                                  fontSize: bigQuote ? 22 : 16)),
                        ),
                        const SizedBox(width: 8),
                        Text('•  $handle',
                            style: const TextStyle(color: _muted, fontSize: 15)),
                      ]),
                      const SizedBox(height: 2),
                      Text(time,
                          style: const TextStyle(
                              color: _muted,
                              fontSize: 13,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _BookBox(showLabel: showReadingLabel, bigTitle: bigQuote),
            const SizedBox(height: 10),
            if (!bigQuote)
              const Icon(Icons.format_quote, color: _muted, size: 22),
            Padding(
              padding: EdgeInsets.symmetric(vertical: bigQuote ? 10 : 4),
              child: Text(
                bigQuote ? '“$_quoteText”' : _quoteText,
                style: TextStyle(
                  fontFamily: _serif,
                  fontStyle: FontStyle.italic,
                  fontSize: bigQuote ? 34 : 17,
                  height: bigQuote ? 1.45 : 1.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: bigQuote ? 14 : 28),
              decoration: BoxDecoration(color: _chip, borderRadius: BorderRadius.circular(14)),
              alignment: Alignment.center,
              child: const Text('ENDING',
                  style: TextStyle(
                      color: _muted, fontWeight: FontWeight.w700, letterSpacing: 2)),
            ),
            const SizedBox(height: 14),
            const Text(_descText, style: TextStyle(fontSize: 14, height: 2.0)),
            const SizedBox(height: 12),
            const _PostActions(likes: 48, comments: 12),
          ],
        ),
      ),
    );
  }
}

class _BookBox extends StatelessWidget {
  final bool showLabel;
  final bool bigTitle;
  const _BookBox({required this.showLabel, required this.bigTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: _chip, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HujanCover(width: 56, height: 84),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showLabel)
                  const Text('MEMBACA',
                      style: TextStyle(
                          color: _muted,
                          fontSize: 13,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600)),
                const Text('Hujan',
                    style: TextStyle(
                        fontFamily: _serif, fontSize: 24, fontWeight: FontWeight.w600)),
                const Text('Tere Liye', style: TextStyle(color: _muted, fontSize: 16)),
                const SizedBox(height: 6),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE6E5E2), borderRadius: BorderRadius.circular(6)),
                    child: const Text('Selesai Membaca',
                        style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                  ),
                  const SizedBox(width: 10),
                  const Text('5.0', style: TextStyle(fontSize: 16)),
                  const Icon(Icons.star, size: 18),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostActions extends StatefulWidget {
  final int likes;
  final int? comments;
  final String? commentLabel;
  final bool showShare;

  const _PostActions({
    required this.likes,
    this.comments,
    this.commentLabel,
    this.showShare = true,
  });

  @override
  State<_PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<_PostActions> {
  bool _liked = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final likes = widget.likes + (_liked ? 1 : 0);
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => _liked = !_liked),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(children: [
              Icon(_liked ? Icons.favorite : Icons.favorite_border,
                  color: _liked ? Colors.red : _ink, size: 28),
              const SizedBox(width: 6),
              Text('$likes', style: const TextStyle(fontSize: 17, color: _muted)),
            ]),
          ),
        ),
        const SizedBox(width: 14),
        Row(children: [
          const Icon(Icons.mode_comment_outlined, size: 26),
          const SizedBox(width: 6),
          Text(widget.commentLabel ?? '${widget.comments ?? 0}',
              style: const TextStyle(fontSize: 17, color: _muted)),
        ]),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => _saved = !_saved),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: _chip, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Icon(_saved ? Icons.bookmark : Icons.bookmark_border, size: 20),
              const SizedBox(width: 6),
              Text(_saved ? 'Tersimpan' : '+ Simpan Kutipan',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
        if (widget.showShare) ...[
          const SizedBox(width: 10),
          const Icon(Icons.share_outlined, color: _muted),
        ],
      ],
    );
  }
}

class _TabChips extends StatefulWidget {
  final List<String> labels;
  final Widget? trailing;
  const _TabChips({required this.labels, this.trailing});

  @override
  State<_TabChips> createState() => _TabChipsState();
}

class _TabChipsState extends State<_TabChips> {
  int _sel = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.labels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ChoiceChip(
                label: Text(widget.labels[i]),
                selected: _sel == i,
                showCheckmark: false,
                onSelected: (_) => setState(() => _sel = i),
                selectedColor: _ink,
                backgroundColor: _chip,
                side: BorderSide.none,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _sel == i ? Colors.white : _muted),
              ),
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final double size;
  final List<Color> colors;
  final String? initials;
  final String? imageUrl; // isi bila pakai foto profil asli
  const _Avatar({required this.size, required this.colors, this.initials, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        image: imageUrl == null
            ? null
            : DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover),
      ),
      child: initials == null
          ? null
          : Text(initials!,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: _serif,
                  fontStyle: FontStyle.italic,
                  fontSize: size * 0.34)),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bg, fg;
  final bool bold;
  const _Pill({required this.label, required this.bg, required this.fg, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: TextStyle(
              color: fg, fontWeight: bold ? FontWeight.w700 : FontWeight.w500, letterSpacing: 0.5)),
    );
  }
}

class _HujanCover extends StatelessWidget {
  final double width, height;
  const _HujanCover({required this.width, required this.height});

  // Ganti isi build dengan Image.network / Image.asset untuk sampul asli.
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4FB4D8), Color(0xFFBEE6F2)],
        ),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Text('HUJAN',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: width * 0.2,
              letterSpacing: 0.5)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  4. BOTTOM SHEET: BAGIKAN KUTIPAN
// ═══════════════════════════════════════════════════════════════

Future<void> showShareQuoteSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: _bg,
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    builder: (_) => const ShareQuoteSheet(),
  );
}

class _Tag {
  final String label;
  final bool mood;
  const _Tag(this.label, {this.mood = false});
}

class ShareQuoteSheet extends StatefulWidget {
  const ShareQuoteSheet({super.key});

  @override
  State<ShareQuoteSheet> createState() => _ShareQuoteSheetState();
}

class _ShareQuoteSheetState extends State<ShareQuoteSheet> {
  final _ctrl = TextEditingController(text: '“$_quoteText”');
  bool _public = true;
  bool _bold = false, _italic = true, _underline = false;

  final List<_Tag> _tags = [
    const _Tag('#KotaDanKeinginan'),
    const _Tag('Suasana: Kopi & Hujan', mood: true),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _addMood() async {
    final c = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Mood'),
        content: TextField(
            controller: c, autofocus: true, decoration: const InputDecoration(hintText: 'mis. Senja')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Tambah')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _tags.add(_Tag('Suasana: $result', mood: true)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                  color: const Color(0xFFD0CFCB), borderRadius: BorderRadius.circular(3)),
            ),
          ),
          // title
          SizedBox(
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ),
                const Text('Bagikan Kutipan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE6E5E2)),
          // body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // user row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFFE0A23B)),
                        child: const _Avatar(
                            size: 62,
                            initials: 'JM',
                            colors: [Color(0xFF2B2623), Color(0xFF2B2623)]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(children: [
                              Text('Julian Mahesa',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                              SizedBox(width: 8),
                              Text('@julianm', style: TextStyle(color: _muted)),
                            ]),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.only(left: 12, right: 4),
                              decoration: BoxDecoration(
                                color: _chip,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE0DFDB)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_public ? Icons.public : Icons.lock_outline, size: 18),
                                  const SizedBox(width: 8),
                                  Text(_public ? 'Publik' : 'Privat',
                                      style: const TextStyle(fontSize: 16)),
                                  Switch(
                                    value: _public,
                                    onChanged: (v) => setState(() => _public = v),
                                    activeColor: Colors.white,
                                    activeTrackColor: _ink,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // toolbar B I U
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _chip,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0DFDB)),
                        ),
                        child: Row(children: [
                          _FmtButton(
                              child: const Text('B',
                                  style: TextStyle(
                                      fontFamily: _serif,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20)),
                              active: _bold,
                              onTap: () => setState(() => _bold = !_bold)),
                          _FmtButton(
                              child: const Text('I',
                                  style: TextStyle(
                                      fontFamily: _serif,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20)),
                              active: _italic,
                              onTap: () => setState(() => _italic = !_italic)),
                          _FmtButton(
                              child: const Text('U',
                                  style: TextStyle(
                                      fontFamily: _serif,
                                      decoration: TextDecoration.underline,
                                      fontSize: 20)),
                              active: _underline,
                              onTap: () => setState(() => _underline = !_underline)),
                        ]),
                      ),
                      const Spacer(),
                      const Icon(Icons.format_quote, color: _muted, size: 30),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // editor
                  TextField(
                    controller: _ctrl,
                    maxLines: null,
                    cursorColor: _accent,
                    style: TextStyle(
                      fontFamily: _serif,
                      fontSize: 30,
                      height: 1.5,
                      fontWeight: _bold ? FontWeight.w700 : FontWeight.w400,
                      fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                      decoration: _underline ? TextDecoration.underline : TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Tulis kutipan…',
                    ),
                  ),
                  const SizedBox(height: 18),
                  // related book
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE0DFDB)),
                    ),
                    child: Row(
                      children: [
                        const _HujanCover(width: 56, height: 84),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                _Pill(
                                    label: 'BUKU TERKAIT',
                                    bg: _accentBg,
                                    fg: _accent,
                                    bold: true),
                                const SizedBox(width: 10),
                                const Text('Hal. 42', style: TextStyle(color: _muted)),
                              ]),
                              const SizedBox(height: 6),
                              const Text('Hujan',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                              const Text('Tere Liye  •  2016',
                                  style: TextStyle(color: _muted, fontSize: 16)),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_outlined, color: _muted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // tags
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final t in _tags)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: t.mood ? _accentBg : _chip,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(t.mood ? '☕ ${t.label}' : '🏷️ ${t.label}',
                                style: TextStyle(
                                    fontSize: 16, color: t.mood ? _accent : _ink)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => setState(() => _tags.remove(t)),
                              child: Icon(Icons.close,
                                  size: 16, color: t.mood ? _accent : _muted),
                            ),
                          ]),
                        ),
                      TextButton(
                        onPressed: _addMood,
                        style: TextButton.styleFrom(foregroundColor: _accent),
                        child: const Text('+ Tambah Mood',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // send button
          Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE6E5E2)))),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton(
                onPressed: () {
                  // TODO: kirim _ctrl.text, _public, dan _tags ke backend
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _ink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Kirim Kutipan',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FmtButton extends StatelessWidget {
  final Widget child;
  final bool active;
  final VoidCallback onTap;
  const _FmtButton({required this.child, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 52,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}