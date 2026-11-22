import 'package:flutter/material.dart';
import 'package:tale_mark/home.dart';
import 'register_screen.dart';
import 'app_theme.dart';
import 'services/auth_services.dart';
import 'widgets/auth_widgets.dart';
import 'widgets/forgot_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      final userName = result['user']?['name'] ?? 'Pembaca';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat datang kembali, $userName!'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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

  // Fungsi untuk menangani login Google
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
          content: Text('Selamat datang, $userName!'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40),
                Text(
                  'Masuk',
                  style: AppTheme.serif(size: 34),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lanjutkan ritme membaca yang tenang.',
                  style: TextStyle(fontSize: 14, color: AppTheme.muted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                const FieldLabel('EMAIL', small: true),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'nama@pustaka.com'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FieldLabel('KATA SANDI', small: true),
                    GestureDetector(
                      onTap: () => showForgotPasswordDialog(context),
                      child: const Text(
                        'Lupa?',
                        style: TextStyle(fontSize: 12, color: AppTheme.muted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Masuk'),
                ),
                const SizedBox(height: 24),

                const OrDivider('ATAU'),
                const SizedBox(height: 24),

                // Tombol Google sudah dihubungkan ke _handleGoogleLogin
                GoogleButton(
                  onPressed: _handleGoogleLogin,
                  isLoading: _isGoogleLoading,
                ),
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun?',
                      style: TextStyle(fontSize: 13, color: AppTheme.muted),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Buat akun',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
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
  }
}
