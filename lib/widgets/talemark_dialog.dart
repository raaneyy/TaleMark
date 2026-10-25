import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Template dialog buat TaleMark. Isinya: latar blur, kotak putih, judul pake font serif, tombol kembali, dan tombol bertumpuk.
/// Gaya yang sama dengan dialog Lupa Password & konfirmasi Logout. Dilakuin biar konsisten
Future<T?> showTaleMarkDialog<T>({
  required BuildContext context,
  required String judul,
  String? pesan, // teks penjelasan (opsional)
  Widget? isi, // isian tambahan, misalnya kolom ketik (opsional)
  required List<Widget> tombol,
}) {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.black12,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tombol kembali (←)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                judul,
                style: AppTheme.serif(size: 26),
                textAlign: TextAlign.center,
              ),
              if (pesan != null) ...[
                const SizedBox(height: 12),
                Text(
                  pesan,
                  style: const TextStyle(fontSize: 14, color: AppTheme.muted),
                  textAlign: TextAlign.center,
                ),
              ],
              if (isi != null) ...[
                const SizedBox(height: 24),
                isi,
              ],
              const SizedBox(height: 24),
              // Tombol - tombol disusun ke bawah dengan jarak 8
              for (int i = 0; i < tombol.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                tombol[i],
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

/// Tombol utama dialog berwarna hitam, ngikutin app_theme.dart
class TombolDialogUtama extends StatelessWidget {
  const TombolDialogUtama({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return ElevatedButton(onPressed: onPressed, child: Text(label));
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

/// Tombol kedua dialog berwarna abu - abu
class TombolDialogKedua extends StatelessWidget {
  const TombolDialogKedua({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppTheme.fieldColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}