import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'app_theme.dart';
import 'widgets/auth_widgets.dart';

class TambahBukuScreen extends StatefulWidget {
  const TambahBukuScreen({super.key});

  @override
  State<TambahBukuScreen> createState() => _TambahBukuScreenState();
}

class _TambahBukuScreenState extends State<TambahBukuScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controller untuk setiap kolom inputan yang nanti diisi
  final _isbnController = TextEditingController();
  final _judulController = TextEditingController();
  final _penulisController = TextEditingController();
  final _penerbitController = TextEditingController();
  final _tahunController = TextEditingController();
  final _halamanController = TextEditingController();

  // Bahasa dari bukunya, cuman bisa milih 1
  final List<String> daftarBahasa = ['Bahasa Indonesia', 'English', 'Lainnya'];
  String bahasaTerpilih = 'Bahasa Indonesia';

  // Genre buku, bisa milih lebih dari satu
  // Ini masih daftar sementara, nanti diganti data dari database
  final List<String> daftarGenre = [
    'Fiksi Ilmiah',
    'Fiksi Spekulatif',
    'Distopia',
    'Romance',
    'Sastra Klasik',
    'Realisme Magis',
    'Filsafat',
    'Esai',
    'Sejarah',
    'Biografi',
    'Pengembangan Diri',
    'Lainnya',
  ];
  List<String> genreTerpilih = [];

  // Status buku, hanya boleh pilih 1
  String statusTerpilih = 'Sedang Dibaca';
  // Foto sampul yang dipilih pengguna (null berarti belum ada foto)
  File? fotoSampul;

  @override
  void dispose() {
    _isbnController.dispose();
    _judulController.dispose();
    _penulisController.dispose();
    _penerbitController.dispose();
    _tahunController.dispose();
    _halamanController.dispose();
    super.dispose();
  }

  // Saat tombol Simpan ditekan
  void simpanBuku() {
    if (formKey.currentState!.validate()) {
      // TODO (backend): kirim data buku ke server/database.
      // Data yang sudah tersedia: _isbnController.text, _judulController.text,
      // _penulisController.text, _penerbitController.text, _tahunController.text,
      // _halamanController.text, bahasaTerpilih, genreTerpilih, statusTerpilih

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Buku "${_judulController.text.trim()}" berhasil ditambahkan',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context); // kembali ke Home
    } else {
      // Ada kolom yang belum benar, kasih tahu pembaca
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Masih ada kolom yang belum diisi dengan benar. Cek tulisan merah di atas.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // tombol kembali (←) muncul otomatis
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _kotakInfo(),
                const SizedBox(height: 32),
                _pratinjauSampul(),
                const SizedBox(height: 32),
                _bagianInformasiUtama(),
                const SizedBox(height: 32),
                _bagianSpesifikasi(),
                const SizedBox(height: 32),
                _bagianStatus(),
                const SizedBox(height: 32),
                _tombolSimpan(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Ambil foto sampul dari kamera atau galeri
  Future<void> ambilFoto(ImageSource sumber) async {
    final picker = ImagePicker();
    final XFile? hasil = await picker.pickImage(
      source: sumber,
      maxWidth: 1200, // perkecil ukuran supaya tidak terlalu berat
      imageQuality: 85, // kualitas 85% sudah cukup tajam
    );

    // Kalau batal, nggak jadi memilih foto, hasilnya null
    if (hasil == null) return;

    setState(() {
      fotoSampul = File(hasil.path);
    });
  }

  // BAGIAN-BAGIAN TAMPILAN

  // 1. Kotak info di paling atas
  Widget _kotakInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.fieldColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.menu_book_outlined, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TAMBAHKAN BUKU MANUAL',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Buku fisik tidak terdaftar di database? Lengkapi detail karya secara manual agar dapat dimasukkan ke perpustakaan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.muted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Pratinjau sampul buku dan tombol foto
  Widget _pratinjauSampul() {
    // Kalau kolom masih kosong, tampilkan tulisan contoh
    String judul = _judulController.text.isEmpty
        ? 'Judul Buku'
        : _judulController.text;
    String penulis = _penulisController.text.isEmpty
        ? 'Nama Penulis'
        : _penulisController.text;

    return Column(
      children: [
        Container(
          width: 170,
          height: 250,
          // Kalau sudah ada foto, jarak dalam dihapus biar foto memenuhi kotak
          padding: fotoSampul == null
              ? const EdgeInsets.all(16)
              : EdgeInsets.zero,
          clipBehavior:
              Clip.antiAlias, // foto terpotong otomatis, ngikutin bentuk yang membulat
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDEB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: fotoSampul != null
              // Sudah ada foto berarti tampilkan fotonya
              ? Image.file(fotoSampul!, fit: BoxFit.cover)
              // Belum ada foto berarti tampilkan pratinjau tulisan seperti sebelumnya
              : Column(
                  children: [
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.photo_camera_outlined,
                      size: 32,
                      color: AppTheme.muted,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'PRATINJAU SAMPUL',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: AppTheme.muted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      judul,
                      style: AppTheme.serif(size: 20),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      penulis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.muted,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    const Text(
                      'Min. 600 × 900 px',
                      style: TextStyle(fontSize: 10, color: Color(0xFFB0B0AD)),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _tombolAbu(
              Icons.photo_camera_outlined,
              'Foto Sampul',
              () => ambilFoto(ImageSource.camera),
            ),
            const SizedBox(width: 12),
            _tombolAbu(
              Icons.upload_file_outlined,
              'Unggah Foto',
              () => ambilFoto(ImageSource.gallery),
            ),
          ],
        ),
        // Tombol hapus hanya muncul kalau sudah ada foto
        if (fotoSampul != null)
          TextButton(
            onPressed: () {
              setState(() {
                fotoSampul = null;
              });
            },
            child: const Text(
              'Hapus foto',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  // Tombol abu-abu berbentuk kapsul, dipakai dua kali, pas: Foto Sampul & Unggah Foto
  Widget _tombolAbu(IconData icon, String label, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        backgroundColor: AppTheme.fieldColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: const StadiumBorder(),
      ),
    );
  }

  // Judul bagian, contoh: "Informasi Utama Karya"
  Widget _judulBagian(String teks) {
    return Text(teks, style: AppTheme.serif(size: 22));
  }

  // Label di atas kolom, artinya wajib diisi: true → bakalan muncul tanda * merah
  Widget _label(String teks, {bool wajib = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          FieldLabel(teks),
          if (wajib) const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  // 3. Informasi Utama Karya
  Widget _bagianInformasiUtama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _judulBagian('Informasi Utama Karya')),
            const Text(
              'WAJIB DIISI *',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.8,
                color: AppTheme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ISBN (opsional)
        Row(
          children: [
            Expanded(child: _label('ISBN / Nomor Barcode')),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Opsional',
                style: TextStyle(fontSize: 12, color: AppTheme.muted),
              ),
            ),
          ],
        ),
        TextFormField(
          controller: _isbnController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Contoh: 978-602-03-8594-5',
            suffixIcon: Padding(
              padding: const EdgeInsets.all(6),
              child: TextButton.icon(
                onPressed: () {}, // Tahap 4: buka halaman Pindai
                icon: const Icon(Icons.qr_code_scanner, size: 16),
                label: const Text('Pindai'),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFE2E2DF),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) return null; // boleh kosong
            String angka = value.replaceAll('-', '').replaceAll(' ', '');
            if (angka.length != 10 && angka.length != 13) {
              return 'ISBN harus 10 atau 13 digit';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Judul (wajib)
        _label('Judul Lengkap Buku', wajib: true),
        TextFormField(
          controller: _judulController,
          decoration: const InputDecoration(
            hintText: 'Masukkan judul lengkap beserta subjudul...',
          ),
          onChanged: (value) => setState(() {}), // perbarui pratinjau sampul
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Judul buku wajib diisi';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Penulis (wajib)
        _label('Penulis / Pengarang Utama', wajib: true),
        TextFormField(
          controller: _penulisController,
          decoration: const InputDecoration(
            hintText: 'Misal: Pramoedya Ananta Toer',
          ),
          onChanged: (value) => setState(() {}), // perbarui pratinjau sampul
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama penulis wajib diisi';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Penerbit & Tahun Terbit (berdampingan)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Penerbit'),
                  TextFormField(
                    controller: _penerbitController,
                    decoration: const InputDecoration(
                      hintText: 'Gramedia Pustaka',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Tahun Terbit'),
                  TextFormField(
                    controller: _tahunController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '2024'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return null; // boleh kosong
                      int? tahun = int.tryParse(value);
                      int tahunIni = DateTime.now().year;
                      if (tahun == null) return 'Harus berupa angka';
                      if (tahun < 1000 || tahun > tahunIni) {
                        return 'Tahun tidak valid';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 4. Spesifikasi Fisik & Bacaan
  Widget _bagianSpesifikasi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulBagian('Spesifikasi Fisik & Bacaan'),
        const SizedBox(height: 20),

        // Total halaman (wajib)
        _label('Total Halaman', wajib: true),
        TextFormField(
          controller: _halamanController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Misal: 384',
            suffixText: 'Hlm',
            helperText: 'Dibutuhkan untuk sinkronisasi persentase baca dan sesi timer TaleMark.',
            helperMaxLines: 2,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Total halaman wajib diisi';
            }
            int? halaman = int.tryParse(value);
            if (halaman == null) return 'Masukkan angka bulat, contoh: 384';
            if (halaman < 1) return 'Minimal 1 halaman';
            if (halaman > 5000) return 'Maksimal 5000 halaman';
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Bahasa (pilih 1)
        _label('Bahasa Teks'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (String bahasa in daftarBahasa)
              ChoiceChip(
                label: Text(bahasa),
                selected: bahasaTerpilih == bahasa,
                onSelected: (value) {
                  setState(() {
                    bahasaTerpilih = bahasa;
                  });
                },
                showCheckmark: false,
                selectedColor: Colors.black,
                backgroundColor: AppTheme.fieldColor,
                side: BorderSide.none,
                shape: const StadiumBorder(),
                labelStyle: TextStyle(
                  color: bahasaTerpilih == bahasa ? Colors.white : Colors.black,
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),

        // Genre (boleh lebih dari 1)
        _label('Genre / Tema Sastra'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (String genre in daftarGenre)
              FilterChip(
                label: Text(genre),
                selected: genreTerpilih.contains(genre),
                onSelected: (dipilih) {
                  setState(() {
                    if (dipilih) {
                      genreTerpilih.add(genre);
                    } else {
                      genreTerpilih.remove(genre);
                    }
                  });
                },
                selectedColor: const Color(0xFFDADAD7),
                backgroundColor: AppTheme.fieldColor,
                side: BorderSide.none,
                shape: const StadiumBorder(),
              ),
          ],
        ),
      ],
    );
  }

  // 5. Status Buku
  Widget _bagianStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _judulBagian('Status Buku'),
        const SizedBox(height: 16),
        _label('Tambahkan di Perpustakaan'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _kartuStatus(
                Icons.menu_book_outlined,
                'Sedang Dibaca',
                null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _kartuStatus(
                Icons.bookmark_add_outlined,
                'Akan Dibaca (TBR)',
                null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _kartuStatus(
                Icons.check_circle_outline,
                'Sudah Selesai',
                'Arsip catatan & rating',
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: SizedBox(),
            ), // ruang kosong biar lebarnya sama
          ],
        ),
      ],
    );
  }

  // Kartu pilihan status (dipakai 3x)
  Widget _kartuStatus(IconData icon, String label, String? keterangan) {
    bool dipilih = statusTerpilih == label;
    Color warnaTeks = dipilih ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        setState(() {
          statusTerpilih = label;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: dipilih ? Colors.black : AppTheme.fieldColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: warnaTeks),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 13, color: warnaTeks)),
            if (keterangan != null)
              Text(
                keterangan,
                style: TextStyle(
                  fontSize: 11,
                  color: dipilih ? Colors.white70 : AppTheme.muted,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 6. Tombol Simpan
  Widget _tombolSimpan() {
    return ElevatedButton.icon(
      onPressed: simpanBuku,
      icon: const Icon(Icons.bookmark_border),
      label: const Text('Simpan & Tambahkan ke Library'),
      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
    );
  }
}
