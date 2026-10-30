import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

const _bg = Color(0xFFF9F8F5);
const _ink = Color(0xFF111111);
const _muted = Color(0xFF6B6B70);
const _cardBg = Color(0xFFF1F0EE);
const _cameraBg = Color(0xFF1C1C1C);
const _serif = 'Georgia';

class ScannedBook {
  final String publisher, title, author, isbn;
  final int year, pages;
  final double rating;
  final String reviews;

  const ScannedBook({
    required this.publisher,
    required this.title,
    required this.author,
    required this.year,
    required this.pages,
    required this.isbn,
    required this.rating,
    required this.reviews,
  });
}

class ScanBookPage extends StatefulWidget {
  /// Buku hasil pindai. Null = kamera aktif memindai.
  final ScannedBook? book;
  final ValueChanged<ScannedBook>? onSave;

  const ScanBookPage({super.key, this.book, this.onSave});

  @override
  State<ScanBookPage> createState() => _ScanBookPageState();
}

class _ScanBookPageState extends State<ScanBookPage> with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
        ..repeat(reverse: true);

  late final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  ScannedBook? _scannedBook;
  String? _currentBarcode;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _scannedBook = widget.book;
    if (_scannedBook != null) {
      _currentBarcode = _scannedBook!.isbn;
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _rescan() {
    setState(() {
      _scannedBook = null;
      _currentBarcode = null;
      _isProcessing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kamera siap, silakan scan barcode baru…'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _isProcessing = true);
      final BarcodeCapture? barcodes = await _controller.analyzeImage(image.path);
      if (barcodes != null && barcodes.barcodes.isNotEmpty) {
        final code = barcodes.barcodes.first.rawValue ?? barcodes.barcodes.first.displayValue;
        if (code != null && code.trim().isNotEmpty) {
          await _handleBarcode(code.trim());
          return;
        }
      }
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada barcode yang terdeteksi pada foto tersebut.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menganalisis gambar: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _manualIsbnDialog() async {
    final textController = TextEditingController(text: '978-6020324784');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ketik Nomor Barcode / ISBN'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Contoh: 978-6020324784',
            labelText: 'ISBN / Barcode',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _ink),
            onPressed: () => Navigator.pop(ctx, textController.text.trim()),
            child: const Text('Cari'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      _handleBarcode(result);
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing || _scannedBook != null) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue ?? barcode.displayValue;
      if (value != null && value.trim().isNotEmpty) {
        _handleBarcode(value.trim());
        break;
      }
    }
  }

  Future<void> _handleBarcode(String rawCode) async {
    setState(() {
      _isProcessing = true;
      _currentBarcode = rawCode;
    });

    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}

    final cleanCode = rawCode.replaceAll(RegExp(r'[\s-]'), '');

    // 1. Cek katalog lokal
    ScannedBook? foundBook = _lookupLocalCatalog(cleanCode);

    // 2. Jika tidak ada di katalog lokal, coba ambil dari Open Library API
    foundBook ??= await _fetchOnlineBook(cleanCode, rawCode);

    // 3. Fallback jika offline/tidak ditemukan
    foundBook ??= ScannedBook(
      publisher: 'PUSTAKA UMUM',
      title: 'Buku ISBN $rawCode',
      author: 'Penulis Buku',
      year: DateTime.now().year,
      pages: 200,
      isbn: rawCode,
      rating: 4.5,
      reviews: 'Barcode Terdeteksi',
    );

    if (mounted) {
      setState(() {
        _scannedBook = foundBook;
        _isProcessing = false;
      });
    }
  }

  ScannedBook? _lookupLocalCatalog(String cleanCode) {
    final catalog = <String, ScannedBook>{
      '9780143105244': const ScannedBook(
        publisher: 'PENGUIN CLASSICS',
        title: 'The Metamorphosis',
        author: 'Franz Kafka',
        year: 1915,
        pages: 224,
        isbn: '978-0143105244',
        rating: 4.3,
        reviews: '412k ulasan',
      ),
      '9780679720201': const ScannedBook(
        publisher: 'VINTAGE INTERNATIONAL',
        title: 'The Stranger',
        author: 'Albert Camus',
        year: 1942,
        pages: 123,
        isbn: '978-0679720201',
        rating: 4.5,
        reviews: '380k ulasan',
      ),
      '9780156027601': const ScannedBook(
        publisher: 'HARCOURT BRACE',
        title: 'Blindness',
        author: 'José Saramago',
        year: 1995,
        pages: 352,
        isbn: '978-0156027601',
        rating: 4.2,
        reviews: '210k ulasan',
      ),
      '9786020324784': const ScannedBook(
        publisher: 'GRAMEDIA PUSTAKA UTAMA',
        title: 'Hujan',
        author: 'Tere Liye',
        year: 2016,
        pages: 320,
        isbn: '978-6020324784',
        rating: 4.6,
        reviews: '52k ulasan',
      ),
      '9789792219463': const ScannedBook(
        publisher: 'BENTANG PUSTAKA',
        title: 'Laskar Pelangi',
        author: 'Andrea Hirata',
        year: 2005,
        pages: 529,
        isbn: '978-9792219463',
        rating: 4.7,
        reviews: '89k ulasan',
      ),
      '9789799731234': const ScannedBook(
        publisher: 'HASTA MITRA',
        title: 'Bumi Manusia',
        author: 'Pramoedya Ananta Toer',
        year: 1980,
        pages: 535,
        isbn: '978-9799731234',
        rating: 4.8,
        reviews: '115k ulasan',
      ),
      '9780156439619': const ScannedBook(
        publisher: 'HARCOURT HARVEST',
        title: "If on a winter's night a traveler",
        author: 'Italo Calvino',
        year: 1979,
        pages: 260,
        isbn: '978-0156439619',
        rating: 4.6,
        reviews: '142k ulasan',
      ),
      '9780802130303': const ScannedBook(
        publisher: 'GROVE PRESS',
        title: 'Ficciones',
        author: 'Jorge Luis Borges',
        year: 1944,
        pages: 174,
        isbn: '978-0802130303',
        rating: 4.7,
        reviews: '168k ulasan',
      ),
      '9780679733737': const ScannedBook(
        publisher: 'VINTAGE',
        title: 'The Myth of Sisyphus',
        author: 'Albert Camus',
        year: 1942,
        pages: 212,
        isbn: '978-0679733737',
        rating: 4.5,
        reviews: '95k ulasan',
      ),
    };

    return catalog[cleanCode];
  }

  Future<ScannedBook?> _fetchOnlineBook(String cleanCode, String rawCode) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 4);
      final uri = Uri.parse(
          'https://openlibrary.org/api/books?bibkeys=ISBN:$cleanCode&format=json&jscmd=data');
      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        final bookKey = 'ISBN:$cleanCode';
        if (data.containsKey(bookKey)) {
          final b = data[bookKey] as Map<String, dynamic>;
          final title = b['title'] as String? ?? 'Buku ($rawCode)';
          String author = 'Penulis Buku';
          if (b['authors'] != null && (b['authors'] as List).isNotEmpty) {
            author = (b['authors'] as List).first['name'] as String? ?? author;
          }
          String publisher = 'PENERBIT';
          if (b['publishers'] != null && (b['publishers'] as List).isNotEmpty) {
            publisher = (b['publishers'] as List).first['name'] as String? ?? publisher;
          }
          int pages = (b['number_of_pages'] as num?)?.toInt() ?? 200;
          int year = DateTime.now().year;
          if (b['publish_date'] != null) {
            final match = RegExp(r'\b(19\d\d|20\d\d)\b').firstMatch(b['publish_date'].toString());
            if (match != null) {
              year = int.tryParse(match.group(0)!) ?? year;
            }
          }
          return ScannedBook(
            publisher: publisher.toUpperCase(),
            title: title,
            author: author,
            year: year,
            pages: pages,
            isbn: rawCode,
            rating: 4.5,
            reviews: 'OpenLibrary Verified',
          );
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Container(
                color: _cameraBg,
                child: Column(
                  children: [
                    Expanded(child: _buildCameraArea()),
                    if (_scannedBook != null) _buildResultSheet(_scannedBook!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────── Top bar ─────────────

  Widget _buildTopBar() {
    return Container(
      color: _bg,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Tutup',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.close, size: 26),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Pindai Barcode Buku',
              style: TextStyle(fontFamily: _serif, fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) {
              final isOn = state.torchState == TorchState.on;
              return IconButton(
                tooltip: isOn ? 'Matikan Lampu' : 'Nyalakan Lampu',
                onPressed: () => _controller.toggleTorch(),
                icon: Icon(
                  isOn ? Icons.flash_on : Icons.flash_off,
                  size: 26,
                  color: isOn ? Colors.amber[800] : _ink,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ───────────── Area kamera ─────────────

  Widget _buildCameraArea() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Live Camera Scanner
        Positioned.fill(
          child: MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => _buildCameraError(error),
          ),
        ),

        // 2. Vignette gradient di pinggir kamera
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.9,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 3. Central frame dengan brackets dan laser pemindai
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: _buildFrame(),
            ),
          ),
        ),

        // 4. Petunjuk di atas area scan
        Positioned(
          top: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0E0E0E).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.center_focus_strong_outlined, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  _isProcessing
                      ? 'Sedang membaca barcode…'
                      : 'Arahkan kamera ke barcode buku (ISBN)',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),

        // 5. Action bar di bawah kamera (Galeri, Ketik ISBN, Putar Kamera)
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _cameraActionButton(
                icon: Icons.photo_library_outlined,
                label: 'Galeri',
                onTap: _pickFromGallery,
              ),
              _cameraActionButton(
                icon: Icons.keyboard_outlined,
                label: 'Ketik ISBN',
                onTap: _manualIsbnDialog,
              ),
              _cameraActionButton(
                icon: Icons.flip_camera_ios_outlined,
                label: 'Putar',
                onTap: () => _controller.switchCamera(),
              ),
            ],
          ),
        ),

        // 6. Loading overlay
        if (_isProcessing)
          Positioned.fill(
            child: Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _cameraActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C).withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraError(MobileScannerException error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_outlined, color: Colors.white70, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Kamera Tidak Tersedia',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Pastikan izin kamera aktif, atau gunakan pemindaian dari Galeri / input manual.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _controller.start(),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _manualIsbnDialog,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Ketik Barcode'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                ),
                OutlinedButton.icon(
                  onPressed: () => _handleBarcode('978-6020324784'),
                  icon: const Icon(Icons.auto_stories, size: 16),
                  label: const Text('Simulasi (Hujan)'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrame() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(child: CustomPaint(painter: _BracketsPainter())),
        // Barcode grafis + kode terbaca
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(size: const Size(100, 48), painter: _BarcodePainter()),
            const SizedBox(height: 8),
            Text(
              _currentBarcode ?? 'SCAN ISBN',
              style: TextStyle(
                color: _currentBarcode != null ? Colors.white : const Color(0xFF8E8E93),
                fontFamily: 'monospace',
                fontSize: 13,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        // Garis pemindai merah bergerak
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) => Align(
                alignment: Alignment(0, -1 + 2 * _anim.value),
                child: Container(
                  height: 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(colors: [
                      Colors.red.withValues(alpha: 0),
                      Colors.redAccent,
                      Colors.red.withValues(alpha: 0),
                    ]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Pill status
        Positioned(
          bottom: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, child) => Opacity(
                    opacity: 0.4 + 0.6 * _anim.value,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC62828),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _currentBarcode != null ? 'Barcode Terdeteksi' : 'Membaca Barcode…',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ───────────── Bottom sheet hasil ─────────────

  Widget _buildResultSheet(ScannedBook b) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D8D4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // kartu buku
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(18)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover
                Container(
                  width: 68,
                  height: 98,
                  decoration: BoxDecoration(
                    color: _ink,
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x22000000), blurRadius: 5, offset: Offset(0, 2))
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book, color: Colors.white60, size: 30),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.publisher,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        b.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: _serif,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        b.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text('${b.year}', style: const TextStyle(color: _muted, fontSize: 13)),
                          const Text('•', style: TextStyle(color: _muted, fontSize: 10)),
                          Text('${b.pages} Halaman',
                              style: const TextStyle(color: _muted, fontSize: 13)),
                          const Text('•', style: TextStyle(color: _muted, fontSize: 10)),
                          Text(
                            b.isbn,
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 12,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 17, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${b.rating}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 6),
                          Text('(${b.reviews})',
                              style: const TextStyle(color: _muted, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: () {
                widget.onSave?.call(b);
                Navigator.maybePop(context, b);
              },
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('Simpan ke Rak Bacaan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              style: FilledButton.styleFrom(
                backgroundColor: _ink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextButton.icon(
            onPressed: _rescan,
            icon: const Icon(Icons.refresh, size: 18, color: _muted),
            label: const Text('Bukan buku ini? Pindai ulang barcode',
                style: TextStyle(color: _muted, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Painters
// ═══════════════════════════════════════════════════════════════

/// Empat sudut siku (bracket) bercahaya di sekeliling area pindai.
class _BracketsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const arm = 30.0;
    const inset = 2.0;
    final w = size.width, h = size.height;

    final glow = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    final line = Paint()
      ..color = const Color(0xFFF1EDE4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    Path corner(double x, double y, double dx, double dy) => Path()
      ..moveTo(x + dx * arm, y)
      ..lineTo(x, y)
      ..lineTo(x, y + dy * arm);

    final paths = [
      corner(inset, inset, 1, 1), // kiri atas
      corner(w - inset, inset, -1, 1), // kanan atas
      corner(inset, h - inset, 1, -1), // kiri bawah
      corner(w - inset, h - inset, -1, -1), // kanan bawah
    ];
    for (final p in paths) {
      canvas.drawPath(p, glow);
      canvas.drawPath(p, line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Gambar barcode sederhana (dekoratif).
class _BarcodePainter extends CustomPainter {
  static const _pattern = [
    2, 1, 1, 2, 3, 1, 1, 1, 2, 2, 1, 3, 1, 1, 2, 1, 3, 2, 1, 1, 2, 3, 1, 2, 1, 1, 3, 1, 2, 2,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final total = _pattern.fold<int>(0, (a, b) => a + b);
    final unit = size.width / total;
    final paint = Paint()..color = const Color(0xFF7A7A7A);
    double x = 0;
    for (int i = 0; i < _pattern.length; i++) {
      final w = _pattern[i] * unit;
      if (i.isEven) {
        canvas.drawRect(Rect.fromLTWH(x, 0, w * 0.9, size.height), paint);
      }
      x += w;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}