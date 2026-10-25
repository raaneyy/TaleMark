import 'package:flutter/material.dart';

import 'dart:async';

import 'app_theme.dart';
import 'widgets/talemark_dialog.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // Data dummy buku (nanti diganti data asli dari database)
  final String judulBuku = 'Klara and the Sun';
  final String penulis = 'Kazuo Ishiguro';
  final String penerbit = 'Faber & Faber';
  final int halamanSekarang = 238;
  final int totalHalaman = 304;
  final String estimasiSisa = '~42m left';

  // Data dummy timer
  int targetMenit = 25;
  int sisaDetik = 25 * 60; // 25 menit = 1500 detik
  bool sedangBerjalan = false;
  Timer? _timer; // "alarm" yang berbunyi tiap 1 detik
  final _durasiController = TextEditingController();
  final GlobalKey<FormState> _durasiFormKey = GlobalKey<FormState>();

  // Mengubah detik menjadi format "MENIT:DETIK"
  String formatWaktu(int totalDetik) {
    int menit = totalDetik ~/ 60; // ~/ = pembagian bulat
    int detik = totalDetik % 60; // % = sisa bagi
    String m = menit.toString().padLeft(2, '0');
    String d = detik.toString().padLeft(2, '0');
    return '$m:$d';
  }

  // start atau pause timer
  void mulaiAtauJeda() {
    if (sedangBerjalan) {
      // Sedang jalan ya bisa pause
      _timer?.cancel();
      setState(() {
        sedangBerjalan = false;
      });
    } else {
      // Kalau waktu sudah habis, jangan mulai lagi
      if (sisaDetik == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Waktu sudah habis. Tekan ↻ untuk mengulang.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Sedang diam ya bisa start
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          sisaDetik--; // kurangi 1 detik
        });

        // coba cek: apakah waktunya tepat habis?
        if (sisaDetik == 0) {
          timer.cancel();
          setState(() {
            sedangBerjalan = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sesi membaca selesai! 🎉'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
      setState(() {
        sedangBerjalan = true;
      });
    }
  }

  // Kembalikan timer ke awal (RESET)
  void resetTimer() {
    ScaffoldMessenger.of(
      context,
    ).hideCurrentSnackBar(); // untuk menyembunyikan snackbar yang masih tampil
    _timer?.cancel();
    setState(() {
      sedangBerjalan = false;
      sisaDetik = targetMenit * 60;
    });
  }

  // Akhiri sesi membaca (konfirmasi)
  Future<void> stopTimer() async {
    bool tadiBerjalan = sedangBerjalan; // ingat: tadi timer jalan atau tidak
    _timer?.cancel();
    setState(() {
      sedangBerjalan = false;
    });

    int detikDibaca = targetMenit * 60 - sisaDetik;

    final String? pilihan = await showTaleMarkDialog<String>(
      context: context,
      judul: 'Akhiri sesi membaca?',
      pesan: 'Kamu sudah membaca selama ${formatWaktu(detikDibaca)}.',
      tombol: [
        TombolDialogUtama(
          label: 'Akhiri sesi',
          icon: Icons.stop_rounded,
          onPressed: () => Navigator.pop(context, 'akhiri'),
        ),
        TombolDialogKedua(
          label: 'Lanjutkan membaca',
          onPressed: () => Navigator.pop(context, 'lanjut'),
        ),
      ],
    );

    if (!mounted) return; // halaman sudah ditutup, tidak perlu lanjut

    if (pilihan == 'akhiri') {
      Navigator.pop(context); // kembali ke Home
    } else if (tadiBerjalan) {
      // "Lanjutkan", tombol ←, atau ketuk di luar kotak → timer jalan lagi
      mulaiAtauJeda();
    }
  }

  // Matikan timer pas halaman ditutup
  @override
  void dispose() {
    _timer?.cancel();
    _durasiController.dispose();
    super.dispose();
  }

  // Custom durasi membaca (inputan)
  void aturDurasi() {
    // Durasi hanya boleh diganti saat timer tidak berjalan
    if (sedangBerjalan) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jeda timer dulu sebelum mengubah durasi'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Isi awal kolom dengan durasi yang sedang dipakai
    _durasiController.text = targetMenit.toString();

    showTaleMarkDialog(
      context: context,
      judul: 'Atur durasi membaca',
      pesan: 'Masukkan durasi antara 1 sampai 180 menit.',
      isi: Form(
        key: _durasiFormKey,
        child: TextFormField(
          controller: _durasiController,
          keyboardType: TextInputType.number,
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Contoh: 30',
            suffixText: 'menit',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Durasi tidak boleh kosong';
            }
            int? menit = int.tryParse(value);
            if (menit == null) return 'Masukkan angka bulat, contoh: 30';
            if (menit < 1) return 'Minimal 1 menit';
            if (menit > 180) return 'Maksimal 180 menit';
            return null;
          },
        ),
      ),
      tombol: [
        TombolDialogUtama(
          label: 'Simpan',
          onPressed: () {
            if (_durasiFormKey.currentState!.validate()) {
              int menit = int.parse(_durasiController.text);
              setState(() {
                targetMenit = menit;
                sisaDetik = menit * 60;
              });
              Navigator.pop(context);
            }
          },
        ),
        TombolDialogKedua(
          label: 'Batal',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // tombol back yang panah itu bakal muncul otomatis
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _infoBacaan(),
              const SizedBox(height: 60),
              _lingkaranTimer(),
              const SizedBox(height: 40),
              _tombolKontrol(),
              const SizedBox(height: 40),
              _kartuProgres(),
            ],
          ),
        ),
      ),
    );
  }

  // Info buku yang sedang dibaca + suasana
  Widget _infoBacaan() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.fieldColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book_outlined, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Reading: $judulBuku · $penulis',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow
                        .ellipsis, // teksnya kalau kepanjangan jadi ...
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.fieldColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.cloud_outlined, size: 16, color: AppTheme.muted),
              SizedBox(width: 6),
              Text(
                'Soft Rain',
                style: TextStyle(fontSize: 12, color: AppTheme.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Lingkaran timer di tengah
  Widget _lingkaranTimer() {
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'DEEP READING',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              color: AppTheme.muted,
            ),
          ),
          Text(formatWaktu(sisaDetik), style: AppTheme.serif(size: 56)),
          InkWell(
            onTap: aturDurasi,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Target: $targetMenit min',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.edit_outlined, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tombol Stop, Pause/Play, Reset
  Widget _tombolKontrol() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tombolKecil(Icons.stop_outlined, stopTimer),
        const SizedBox(width: 24),
        InkWell(
          onTap: mulaiAtauJeda,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              sedangBerjalan ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 24),
        _tombolKecil(Icons.refresh, resetTimer),
      ],
    );
  }

  // Tombol abu-abu kecil, dipakai dua kali, pas: stop sama reset
  Widget _tombolKecil(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.fieldColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  // kartu progres buku
  Widget _kartuProgres() {
    double progres =
        halamanSekarang / totalHalaman; // contohnya kalau 238/304 = 0.78
    int persen = (progres * 100)
        .round(); // hasilnya bisa dibulatin kayak gini 78

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sampul buku untuk sementara kotak abu-abu
          Container(width: 56, height: 76, color: AppTheme.fieldColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'ACTIVE CODEX',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        color: AppTheme.muted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$persen%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(judulBuku, style: AppTheme.serif(size: 20)),
                Text(
                  '$penulis · $penerbit',
                  style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progres,
                  minHeight: 4,
                  color: Colors.black,
                  backgroundColor: AppTheme.fieldColor,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Page $halamanSekarang of $totalHalaman',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      estimasiSisa,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
