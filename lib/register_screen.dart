import 'package:flutter/material.dart';
import 'home.dart';
import 'app_theme.dart';
import 'services/auth_services.dart';
import 'widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key}); // Konstruktor gaya baru

  @override
  State<RegisterScreen> createState() => _RegisterScreenState(); // Tipe createState baru
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Tambahan Controller (termasuk nameController)
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variabel untuk visibilitas sandi & status loading
  bool _obscure = true;
  bool _hasMinLength = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_isLoading) return;
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      final userName = result['user']?['name'] ?? _nameController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun berhasil dibuat! Selamat datang, $userName.'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      String message = e.toString().replaceFirst('Exception: ', '');
      if (message.contains('Api10') || message.contains('ApiException: 10')) {
        message = 'Google Sign-In ditolak (Error 10). Tunggu 3–5 menit hingga Google Cloud tersinkron atau restart aplikasi/HP.';
      } else if (message.contains('12500')) {
        message = 'Periksa OAuth Consent Screen atau tambahkan email Anda ke Test Users di Google Cloud Console.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    if (_isLoading || _isGoogleLoading) return;

    FocusScope.of(context).unfocus();
    setState(() => _isGoogleLoading = true);

    try {
      final result = await AuthService.loginWithGoogle();

      if (!mounted) return;

      final userName = result['user']?['name'] ?? 'Pembaca';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun Google terhubung! Selamat datang, $userName.'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      String message = e.toString().replaceFirst('Exception: ', '');
      if (message.contains('Api10') || message.contains('ApiException: 10')) {
        message = 'Google Sign-In ditolak (Error 10). Tunggu 3–5 menit hingga Google Cloud tersinkron atau restart aplikasi/HP.';
      } else if (message.contains('12500')) {
        message = 'Periksa OAuth Consent Screen atau tambahkan email Anda ke Test Users di Google Cloud Console.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Container(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo_talemark.png',
                    height: 110,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start your reading tracker',
                    style: AppTheme.serif(size: 28),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  const FieldLabel('Nama Panggilan Pembaca'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Misal: Leila Chudori',
                      hintStyle: TextStyle(fontSize: 14, color: Color(0xFFC4C4C2)),
                      prefixIcon: Icon(Icons.edit_note),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  const FieldLabel('Alamat Email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'nama@domain.com',
                      hintStyle: TextStyle(fontSize: 14, color: Color(0xFFC4C4C2)),
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                      if (!value.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  const FieldLabel('Kata Sandi'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    onChanged: (value) =>
                        setState(() => _hasMinLength = value.length >= 8),
                    decoration: InputDecoration(
                      hintText: 'Minimal 8 karakter rahasia',
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Color(0xFFC4C4C2)),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Kata sandi tidak boleh kosong';
                      if (value.length < 8) return 'Minimal 8 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  PasswordRequirement(met: _hasMinLength),
                  const SizedBox(height: 20),

                  const Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 12, color: AppTheme.muted, height: 1.5),
                      children: [
                        TextSpan(text: 'Dengan mendaftar, Anda menyetujui '),
                        TextSpan(
                          text: 'Ketentuan Layanan',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' TaleMark.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Buat Akun TaleMark →'),
                  ),
                  const SizedBox(height: 20),

                  const OrDivider('ATAU DAFTAR DENGAN'),
                  const SizedBox(height: 20),

                  GoogleButton(
                    onPressed: _handleGoogleLogin,
                    isLoading: _isGoogleLoading,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah memiliki akun? ',
                        style: TextStyle(fontSize: 13, color: AppTheme.muted),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Masuk›',
                          style: AppTheme.serif(size: 18).copyWith(
                            decoration: TextDecoration.underline,
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
      ),
    );
  }
}