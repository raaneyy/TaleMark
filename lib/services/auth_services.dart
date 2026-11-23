import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Ganti IP ini sesuai alamat IP host server backend Anda
  // Untuk Android Emulator biasanya: http://10.0.2.2:8000/api
  // Untuk HP fisik / jaringan Wi-Fi lokal: http://192.168.1.6:8000/api atau http://10.177.231.149:8000/api
  static const String baseUrl = 'http://10.95.233.149:8000/api';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Konfigurasi GoogleSignIn dengan Web Client ID
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '253061762828-4gglpg4evvkqgdcdefh0q1igtdj6u59l.apps.googleusercontent.com',
  );

  /// Registrasi akun baru ke backend
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Accept': 'application/json'},
            body: {
              'name': name,
              'email': email,
              'password': password,
            },
          )
          .timeout(const Duration(seconds: 15));

      return await _handleResponse(response);
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server ($baseUrl). Pastikan backend aktif dan URL IP sesuai.',
      );
    } on http.ClientException {
      throw Exception('Gagal menghubungi server. Periksa koneksi jaringan Anda.');
    } on TimeoutException {
      throw Exception('Koneksi ke server waktu habis (timeout). Silakan coba lagi.');
    }
  }

  /// Login akun yang sudah terdaftar
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Accept': 'application/json'},
            body: {
              'email': email,
              'password': password,
            },
          )
          .timeout(const Duration(seconds: 15));

      return await _handleResponse(response);
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server ($baseUrl). Pastikan backend aktif dan URL IP sesuai.',
      );
    } on http.ClientException {
      throw Exception('Gagal menghubungi server. Periksa koneksi jaringan Anda.');
    } on TimeoutException {
      throw Exception('Koneksi ke server waktu habis (timeout). Silakan coba lagi.');
    }
  }

  /// Login / Daftar menggunakan akun Google
  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // 1. Tampilkan dialog pemilihan akun Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Login Google dibatalkan oleh pengguna.');
      }

      // 2. Ambil token autentikasi Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      debugPrint('Google User: ${googleUser.email}, ${googleUser.displayName}');

      // 3. Kirim ke backend Laravel
      final response = await http
          .post(
            Uri.parse('$baseUrl/login/google'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'id_token': googleAuth.idToken,
              'access_token': googleAuth.accessToken,
              'name': googleUser.displayName,
              'email': googleUser.email,
            }),
          )
          .timeout(const Duration(seconds: 15));

      return await _handleResponse(response);
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server ($baseUrl). Pastikan server backend sedang aktif.',
      );
    } on http.ClientException {
      throw Exception('Gagal menghubungi server. Periksa koneksi jaringan Anda.');
    } on TimeoutException {
      throw Exception('Koneksi ke server waktu habis (timeout). Silakan coba lagi.');
    }
  }

  /// Memproses response JSON dari backend
  static Future<Map<String, dynamic>> _handleResponse(
    http.Response response,
  ) async {
    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(response.body);
      data = decoded is Map<String, dynamic>
          ? decoded
          : Map<String, dynamic>.from(decoded as Map);
    } catch (_) {
      throw Exception('Format respon tidak valid dari server (${response.statusCode}).');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (data['token'] != null) {
        await _storage.write(
          key: 'auth_token',
          value: data['token'].toString(),
        );
      }

      if (data['user'] != null && data['user'] is Map) {
        final user = data['user'] as Map;
        if (user['name'] != null) {
          await _storage.write(key: 'user_name', value: user['name'].toString());
        }
        if (user['email'] != null) {
          await _storage.write(key: 'user_email', value: user['email'].toString());
        }
      }

      return data;
    }

    final errors = data['errors'];
    String message = data['message']?.toString() ?? 'Terjadi kesalahan pada server.';

    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        message = firstError.first.toString();
      } else if (firstError is String) {
        message = firstError;
      }
    }

    throw Exception(message);
  }

  /// Mengambil token autentikasi yang tersimpan
  static Future<String?> getToken() async {
    return _storage.read(key: 'auth_token');
  }

  /// Mengambil nama pengguna yang tersimpan
  static Future<String?> getUserName() async {
    return _storage.read(key: 'user_name');
  }

  /// Mengambil email pengguna yang tersimpan
  static Future<String?> getUserEmail() async {
    return _storage.read(key: 'user_email');
  }

  /// Cek apakah pengguna sudah login
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout dan hapus token dari storage lokal, Google session, & server
  static Future<void> logout() async {
    try {
      final token = await getToken();

      if (token != null) {
        await http
            .post(
              Uri.parse('$baseUrl/logout'),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 10));
      }

      // Logout dari Google jika sebelumnya login lewat Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {
      // Abaikan error jaringan saat logout agar sesi lokal tetap terhapus
    } finally {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_name');
      await _storage.delete(key: 'user_email');
    }
  }
}
