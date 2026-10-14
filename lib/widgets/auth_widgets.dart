import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Label di atas field. small = true untuk gaya "EMAIL" (kapital kecil).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.small = false});
  final String text;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: small
          ? const TextStyle(
              fontSize: 11,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
              color: AppTheme.muted,
            )
          : const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
    );
  }
}

/// Garis - teks - garis, contoh: "ATAU"
class OrDivider extends StatelessWidget {
  const OrDivider(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    const line = Expanded(child: Divider(color: Color(0xFFE2E2DF), thickness: 1));
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 0.8,
              color: AppTheme.muted,
            ),
          ),
        ),
        line,
      ],
    );
  }
}

/// Tombol Google abu muda dengan logo
class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.fieldColor,
        foregroundColor: Colors.black,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/google_logo.png', height: 18),
          const SizedBox(width: 8),
          const Text('Google'),
        ],
      ),
    );
  }
}

/// Indikator "Min. 8 karakter" (berubah jadi centang hijau saat terpenuhi)
/// dan "Aman & terenkripsi".
class PasswordRequirement extends StatelessWidget {
  const PasswordRequirement({super.key, required this.met});
  final bool met;

  static const Color _green = Color(0xFF2E9E5B);

  @override
  Widget build(BuildContext context) {
    final color = met ? _green : AppTheme.muted;
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 13,
          color: color,
        ),
        const SizedBox(width: 4),
        Text('Min. 8 karakter', style: TextStyle(fontSize: 11, color: color)),
        const SizedBox(width: 10),
        const Icon(Icons.shield_outlined, size: 13, color: AppTheme.muted),
        const SizedBox(width: 4),
        const Text(
          'Aman & terenkripsi',
          style: TextStyle(fontSize: 11, color: AppTheme.muted),
        ),
      ],
    );
  }
}