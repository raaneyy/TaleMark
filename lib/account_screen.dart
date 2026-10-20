import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header / Profile Hero
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE8E8E6), width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF1F1EF),
                            border: Border.all(
                              color: const Color(0xFFE8E8E6),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'CV',
                              style: TextStyle(
                                fontFamily: 'Newsreader',
                                fontSize: 30,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Nama
                    Text(
                      'Calvin Valentino',
                      style: AppTheme.serif(size: 22),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'calvin@talemark.id',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Statistik baris
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatCard(value: '6', label: 'Koleksi'),
                        _VerticalDivider(),
                        _StatCard(value: '1', label: 'Selesai'),
                        _VerticalDivider(),
                        _StatCard(value: '4', label: 'Dibaca'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Reading Activity Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AKTIVITAS MEMBACA',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(6),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Weekly streak indicator
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F9F7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.local_fire_department_rounded,
                                  size: 20,
                                  color: Color(0xFFE65100),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '5 hari beruntun',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Pertahankan ritme membacamu!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Day streak dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _DayDot(day: 'Sen', done: true),
                              _DayDot(day: 'Sel', done: true),
                              _DayDot(day: 'Rab', done: true),
                              _DayDot(day: 'Kam', done: true),
                              _DayDot(day: 'Jum', done: true),
                              _DayDot(day: 'Sab', done: false),
                              _DayDot(day: 'Min', done: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Pengaturan Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PENGATURAN',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsCard(
                      children: [
                        _SettingsTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Edit Profil',
                          onTap: () {},
                        ),
                        _Divider(),
                        _SettingsTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifikasi',
                          onTap: () {},
                          trailing: _ToggleChip(label: 'Aktif'),
                        ),
                        _Divider(),
                        _SettingsTile(
                          icon: Icons.dark_mode_outlined,
                          title: 'Mode Gelap',
                          onTap: () {},
                          trailing: _ToggleChip(label: 'Nonaktif'),
                        ),
                        _Divider(),
                        _SettingsTile(
                          icon: Icons.language_rounded,
                          title: 'Bahasa',
                          onTap: () {},
                          trailing: const Text(
                            'Indonesia',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Lainnya Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LAINNYA',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsCard(
                      children: [
                        _SettingsTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Bantuan & FAQ',
                          onTap: () {},
                        ),
                        _Divider(),
                        _SettingsTile(
                          icon: Icons.shield_outlined,
                          title: 'Kebijakan Privasi',
                          onTap: () {},
                        ),
                        _Divider(),
                        _SettingsTile(
                          icon: Icons.info_outline_rounded,
                          title: 'Tentang TaleMark',
                          onTap: () {},
                          trailing: const Text(
                            'v1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Keluar Tombol
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(
                            'Keluar dari akun?',
                            style: AppTheme.serif(size: 20),
                          ),
                          content: const Text(
                            'Kamu akan keluar dari TaleMark. Progres membacamu tetap tersimpan.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.muted,
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text(
                                'Batal',
                                style: TextStyle(color: AppTheme.muted),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Keluar',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: const Text('Keluar dari Akun'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade200),
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
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Newsreader',
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFFE8E8E6),
    );
  }
}

class _DayDot extends StatelessWidget {
  final String day;
  final bool done;

  const _DayDot({required this.day, required this.done});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: done ? Colors.black : const Color(0xFFF1F1EF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            done ? Icons.check_rounded : Icons.circle_outlined,
            size: done ? 16 : 10,
            color: done ? Colors.white : const Color(0xFFD0D0CE),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            fontSize: 11,
            color: done ? Colors.black : AppTheme.muted,
            fontWeight: done ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.black.withAlpha(60),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: Color(0xFFF1F1EF),
      indent: 48,
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;

  const _ToggleChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.muted,
        ),
      ),
    );
  }
}
