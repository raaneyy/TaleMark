import 'package:flutter/material.dart';

/// Header brand TaleMark yang konsisten untuk digunakan di berbagai halaman (Home, Statistik, dsb).
/// Menampilkan logo TaleMark, teks nama aplikasi, dan tombol notifikasi dengan unread badge.
class TaleMarkHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const TaleMarkHeader({
    super.key,
    this.onNotificationTap,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(16, 6, 16, 8),
  });

  @override
  Widget build(BuildContext context) {
    const kInk = Color(0xFF111111);
    const kMuted = Color(0xFF6B6B70);

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo_talemark.png',
            height: 36,
            width: 36,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, stack) => const Icon(
              Icons.auto_stories_outlined,
              size: 26,
              color: kInk,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'TaleMark',
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: kInk,
            ),
          ),
          const Spacer(),
          trailing ??
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      if (onNotificationTap != null) {
                        onNotificationTap!();
                      } else {
                        showTaleMarkNotifications(context);
                      }
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      size: 24,
                      color: kMuted,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: kInk,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

/// Menampilkan bottom sheet notifikasi TaleMark
void showTaleMarkNotifications(BuildContext context) {
  const kInk = Color(0xFF111111);
  const kMuted = Color(0xFF6B6B70);
  const kChip = Color(0xFFEDEDF0);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifikasi',
              style: TextStyle(
                fontFamily: 'Newsreader',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: kInk,
              ),
            ),
            const SizedBox(height: 16),
            _notifItem(
              Icons.auto_stories,
              'Buku baru ditambahkan ke library',
              '5 menit lalu',
              kChip,
              kInk,
              kMuted,
            ),
            _notifItem(
              Icons.timer,
              'Sesi membaca selesai: 45 menit',
              '1 jam lalu',
              kChip,
              kInk,
              kMuted,
            ),
            _notifItem(
              Icons.star_border,
              'Rekomendasi baru berdasarkan bacaanmu',
              '3 jam lalu',
              kChip,
              kInk,
              kMuted,
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    color: kMuted,
                    fontWeight: FontWeight.w600,
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

Widget _notifItem(
  IconData icon,
  String text,
  String time,
  Color chipColor,
  Color inkColor,
  Color mutedColor,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: chipColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: inkColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: mutedColor),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

