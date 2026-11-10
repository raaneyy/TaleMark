import 'dart:ui';
import 'package:flutter/material.dart';

/// Menampilkan popup dialog untuk menambah kutipan (quote) baru dengan desain konsisten TaleMark.
Future<String?> showAddQuoteDialog(
  BuildContext context, {
  String? initialQuote,
}) async {
  final quoteCtrl = TextEditingController(text: initialQuote ?? '');

  const kInk = Color(0xFF111111);
  const kMuted = Color(0xFF6B6B70);
  const kChip = Color(0xFFF7F7F8);
  const kBorder = Color(0xFFE5E5EA);

  final result = await showDialog<String>(
    context: context,
    barrierColor: Colors.black38,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header popup
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.format_quote_rounded, size: 24, color: kInk),
                      SizedBox(width: 8),
                      Text(
                        'Tambah Kutipan',
                        style: TextStyle(
                          fontFamily: 'Newsreader',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kInk,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, size: 20, color: kMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Tutup',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Input teks kutipan
              Container(
                decoration: BoxDecoration(
                  color: kChip,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBorder),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: TextField(
                  controller: quoteCtrl,
                  autofocus: true,
                  minLines: 4,
                  maxLines: 7,
                  style: const TextStyle(
                    fontFamily: 'Newsreader',
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    height: 1.45,
                    color: kInk,
                  ),
                  decoration: const InputDecoration(
                    hintText: '“Tulis kutipan yang berkesan di sini…”',
                    hintStyle: TextStyle(
                      fontFamily: 'Newsreader',
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF8E8E93),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Batal & Simpan
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: Color(0xFFD1D1D6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: kInk,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final text = quoteCtrl.text.trim();
                        if (text.isEmpty) return;
                        Navigator.pop(ctx, text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kInk,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  quoteCtrl.dispose();

  if (result != null && result.isNotEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kutipan berhasil disimpan!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  return result;
}
