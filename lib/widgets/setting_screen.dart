import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_theme.dart';

// ─────────────────────── Konstanta desain ───────────────────────
const _kBg = Color(0xFFFAFAF8);
const _kCard = Colors.white;
const _kInk = Color(0xFF111111);
const _kMuted = Color(0xFF8A8A86);
const _kBody = Color(0xFF4A4A48);
const _kSub = Color(0xFF6B6B6B);
const _kInset = Color(0xFFF4F4F2);
const _kDivider = Color(0xFFF0F0EE);
const _kSwitchOff = Color(0xFFE0E0DE);
const _kDanger = Color(0xFFC62828);
const _kSerif = 'Newsreader';
const _kSans = 'Inter';

/// Hanya untuk preview layar ini secara terpisah.
/// Aplikasi sebenarnya tetap dijalankan dari main.dart.
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsScreen(),
    ),
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

// ─────────────────────── Data pilihan tema ───────────────────────
class _ThemeOption {
  final String name;
  final String type;
  final Color previewBg;
  final Color previewInk;

  const _ThemeOption({
    required this.name,
    required this.type,
    required this.previewBg,
    required this.previewInk,
  });
}

const _themeOptions = [
  _ThemeOption(
    name: 'Kertas Hangat',
    type: 'Kertas',
    previewBg: Color(0xFFF7F7F5),
    previewInk: Color(0xFF2A2A28),
  ),
  _ThemeOption(
    name: 'Gelap Lilin',
    type: 'Sepia',
    previewBg: Color(0xFFF5EBD3),
    previewInk: Color(0xFF4A3F2A),
  ),
  _ThemeOption(
    name: 'Malam Pekat',
    type: 'OLED',
    previewBg: Colors.black,
    previewInk: Colors.white,
  ),
];

const _languages = ['Bahasa Indonesia', 'English'];

// ─────────────────────── Settings Screen ───────────────────────
class SettingsScreen extends StatefulWidget {
  /// Dipanggil setelah pengguna mengonfirmasi keluar dari akun.
  final VoidCallback? onLogout;

  const SettingsScreen({super.key, this.onLogout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _themeIndex = 0;
  bool _themeSwitch = false;
  bool _notifOn = true;
  String _language = _languages.first;

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _soon() => _snack('Fitur ini segera hadir');

  Future<void> _pickLanguage() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bahasa Aplikasi',
                style: TextStyle(
                  fontFamily: _kSerif,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: _kInk,
                ),
              ),
              const SizedBox(height: 8),
              for (final lang in _languages)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    lang,
                    style: const TextStyle(
                      fontFamily: _kSans,
                      fontSize: 16,
                      color: _kInk,
                    ),
                  ),
                  trailing: lang == _language
                      ? const Icon(Icons.check_rounded, color: _kInk)
                      : null,
                  onTap: () => Navigator.pop(ctx, lang),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _language = picked);
  }

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black12,
      builder: (ctx) => BackdropFilter(
        // Latar belakang diburamkan, sama seperti dialog Lupa Password
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tombol kembali (←) di kiri atas
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    icon: const Icon(Icons.arrow_back, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Keluar dari akun?',
                  style: AppTheme.serif(size: 26),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kamu perlu masuk lagi untuk melanjutkan membaca.',
                  style: TextStyle(fontSize: 14, color: AppTheme.muted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Tombol utama: hitam (mengikuti tema TaleMark)
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(ctx, true),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Ya, keluar'),
                ),
                const SizedBox(height: 8),
                // Tombol kedua: abu-abu
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.fieldColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Tetap masuk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (ok == true && mounted) {
      if (widget.onLogout != null) {
        widget.onLogout!();
      } else {
        _snack('Berhasil keluar (demo)');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 40),
          children: [
            _buildTopBar(),
            const SizedBox(height: 8),
            _buildProfileCard(),
            const SizedBox(height: 32),

            const _SectionLabel('PREFERENSI MEMBACA & TAMPILAN'),
            _SettingsCard(
              children: [
                _buildThemeBlock(),
                _SettingRow(
                  icon: Icons.translate_rounded,
                  title: 'Bahasa',
                  trailing: _LanguagePill(label: _language),
                  showChevron: true,
                  onTap: _pickLanguage,
                ),
              ],
            ),
            const SizedBox(height: 32),

            const _SectionLabel('KEAMANAN AKUN'),
            _SettingsCard(
              children: [
                _SettingRow(
                  icon: Icons.lock_outline_rounded,
                  title: 'Ganti Kata Sandi',
                  subtitle: 'Terakhir diubah 3 bulan lalu',
                  showChevron: true,
                  onTap: _soon,
                ),
              ],
            ),
            const SizedBox(height: 32),

            const _SectionLabel('PUSTAKA'),
            _SettingsCard(
              children: [
                _SettingRow(
                  icon: Icons.alarm_rounded,
                  title: 'Notifikasi',
                  trailing: _Toggle(
                    value: _notifOn,
                    onChanged: (v) => setState(() => _notifOn = v),
                  ),
                  onTap: () => setState(() => _notifOn = !_notifOn),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const _SectionLabel('TENTANG & DUKUNGAN'),
            _SettingsCard(
              children: [
                _SettingRow(
                  icon: Icons.auto_stories_outlined,
                  title: 'Tentang TaleMark',
                  subtitle: 'Edisi Cetak Ke-IV',
                  trailing: const Text(
                    'v2.4.0',
                    style: TextStyle(
                      fontFamily: _kSans,
                      fontSize: 14,
                      color: _kSub,
                    ),
                  ),
                  showChevron: true,
                  onTap: _soon,
                ),
                _SettingRow(
                  icon: Icons.menu_book_outlined,
                  title: 'Panduan Komunitas & Syarat',
                  subtitle: 'Etika kurasi catatan buku',
                  showChevron: true,
                  onTap: _soon,
                ),
              ],
            ),
            const SizedBox(height: 40),

            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──
  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.chevron_left_rounded, size: 34, color: _kInk),
        ),
        const SizedBox(width: 6),
        const Text(
          'Pengaturan',
          style: TextStyle(
            fontFamily: _kSerif,
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: _kInk,
          ),
        ),
      ],
    );
  }

  // ── Kartu profil ──
  Widget _buildProfileCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _soon,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                _Avatar(size: 54),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agustina',
                        style: TextStyle(
                          fontFamily: _kSerif,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: _kInk,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '@agussmahtuah  •  Pembaca sejak 2023',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: _kSans,
                          fontSize: 13,
                          color: _kSub,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, size: 24, color: _kBody),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Blok Tema Tampilan (judul + switch + pilihan tema) ──
  Widget _buildThemeBlock() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.palette_outlined, size: 26, color: _kBody),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tema Tampilan',
                      style: TextStyle(
                        fontFamily: _kSans,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: _kInk,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pilihan nuansa membaca',
                      style: TextStyle(
                        fontFamily: _kSans,
                        fontSize: 14,
                        color: _kSub,
                      ),
                    ),
                  ],
                ),
              ),
              _Toggle(
                value: _themeSwitch,
                onChanged: (v) => setState(() => _themeSwitch = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < _themeOptions.length; i++)
                _ThemeTile(
                  option: _themeOptions[i],
                  selected: _themeIndex == i,
                  onTap: () => setState(() => _themeIndex = i),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Tombol keluar ──
  Widget _buildLogoutButton() {
    return Material(
      color: const Color(0xFFF1F1EF),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _confirmLogout,
        child: const SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, size: 22, color: _kDanger),
              SizedBox(width: 12),
              Text(
                'Keluar dari Akun',
                style: TextStyle(
                  fontFamily: _kSans,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _kDanger,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────── Komponen ───────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 0, 12),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: _kSans,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.6,
          color: _kBody,
        ),
      ),
    );
  }
}

/// Kartu putih yang memisahkan setiap anak dengan garis tipis.
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0)
                  const Divider(height: 1, thickness: 1, color: _kDivider),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 26, color: _kBody),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: _kSans,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: _kInk,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontFamily: _kSans,
                        fontSize: 14,
                        height: 1.4,
                        color: _kSub,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 10), trailing!],
            if (showChevron) ...[
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, size: 24, color: _kBody),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String label;

  const _LanguagePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _kInset,                       // warna latar box
        borderRadius: BorderRadius.circular(8), // lengkung sudut
      ),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: _kSans,
          fontSize: 13,                       // ukuran teks
          fontWeight: FontWeight.w500,
          height: 1.2,
          color: _kInk,
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? _kInk : _kSwitchOff,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final _ThemeOption option;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE9E5DE) : _kInset,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: option.previewBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Aa',
                  style: TextStyle(
                    fontFamily: _kSerif,
                    fontSize: 15,
                    color: option.previewInk,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                option.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: _kSans,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? _kInk : _kBody,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                selected ? 'Aktif' : option.type,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: _kSans,
                  fontSize: 11,
                  color: _kSub,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final double size;

  const _Avatar({required this.size});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: const Color(0xFFDADAD5),
      alignment: Alignment.center,
      child: Text(
        'A',
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
