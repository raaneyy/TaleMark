import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_mark/main.dart';

void main() {
  testWidgets('Aplikasi berhasil melewati splash screen dan menampilkan LoginScreen', (WidgetTester tester) async {
    // 1. Render aplikasi
    await tester.pumpWidget(const MyApp());

    // 2. Lewati Splash Screen (tunggu timer/animasi 4 detik)
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // 3. Verifikasi teks yang BENAR-BENAR ada di LoginScreen
    expect(find.text('Masuk'), findsWidgets); // Ditemukan pada Title & Tombol
    expect(find.text('Lanjutkan ritme membaca yang tenang.'), findsOneWidget);
    expect(find.text('Buat akun'), findsOneWidget); // Sesuai teks TextButton kamu

    // 4. Cari 2 TextFormField (Email & Password)
    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);

    // Pastikan field terlihat di layar ScrollView
    await tester.ensureVisible(emailField);
    await tester.enterText(emailField, 'calvin@talemark.id');

    await tester.ensureVisible(passwordField);
    await tester.enterText(passwordField, 'password123');

    // 5. Simulasikan klik tombol 'Masuk' (ElevatedButton)
    final buttonMasuk = find.byType(ElevatedButton);
    await tester.ensureVisible(buttonMasuk);
    await tester.tap(buttonMasuk);

    // 6. Selesaikan pemrosesan state/animasi
    await tester.pumpAndSettle();
  });
}