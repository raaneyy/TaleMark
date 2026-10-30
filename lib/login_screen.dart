import 'package:flutter/material.dart';
import 'package:tale_mark/home.dart';
import 'register_screen.dart';
import 'app_theme.dart';
import 'widgets/auth_widgets.dart';
import 'widgets/forgot_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Konstruktor gaya baru

  @override
  State<LoginScreen> createState() => _LoginScreenState(); // Tipe createState baru
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Tambahan Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variabel untuk visibilitas sandi
  bool _obscure = true;

  // Wajib menambahkan dispose untuk mencegah memory leak
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        // Perbaikan 1: Membungkus dengan SingleChildScrollView
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center dihapus karena di dalam scroll
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // TODO: kirim data ke backend untuk autentikasi
                      debugPrint('Login: ${_emailController.text.trim()}');
                      
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    }
                  },
                  child: const Text('Masuk'),
                ),
                const SizedBox(height: 24),

                const OrDivider('ATAU'),
                const SizedBox(height: 24),

                GoogleButton(
                  onPressed: () {
                    // TODO: login dengan Google
                  },
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