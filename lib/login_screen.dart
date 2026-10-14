import 'package:flutter/material.dart';
import 'register_screen.dart';

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
                const SizedBox(height: 60), // Memberi sedikit jarak dari atas karena tidak di-center lagi
                const Text(
                  'Masuk',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lanjutkan ritme membaca yang tenang.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController, // Memasang controller
                  decoration: const InputDecoration(
                    labelText: 'EMAIL',
                    hintText: 'nama@pustaka.com',
                    // border dihapus, sudah diurus tema
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController, // Memasang controller
                  obscureText: _obscure, // Menggunakan state visibilitas
                  decoration: InputDecoration( // Hapus const di sini karena isinya dinamis
                    labelText: 'KATA SANDI',
                    hintText: '••••••••',
                    // Ikon mata yang bisa ditekan
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
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
                const SizedBox(height: 30),

                ElevatedButton(
                  // style ElevatedButton dihapus, sudah diurus tema
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Cara memakai data controller saat login ditekan
                      final email = _emailController.text.trim();
                      final password = _passwordController.text;
                      // TODO: Lakukan proses login di sini menggunakan email & password
                    }
                  },
                  child: const Text('Masuk'), // Warna putih diurus tema
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun? '),
                    // Perbaikan: Mengganti GestureDetector dengan TextButton
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Buat akun',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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