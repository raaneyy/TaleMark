import 'package:flutter/material.dart';

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

  // Variabel untuk visibilitas sandi
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Container(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Icon(Icons.menu_book, size: 60), 
                  const SizedBox(height: 16),
                  const Text(
                    'Start your reading tracker',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Panggilan Pembaca',
                      hintText: 'Misal: Leila Chudori',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Email',
                      hintText: 'nama@domain.com',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    // Perbaikan validasi email yang lebih lengkap
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                      if (!value.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure, // Menggunakan state visibilitas
                    decoration: InputDecoration( // const dihapus karena isinya dinamis
                      labelText: 'Kata Sandi',
                      hintText: 'Minimal 8 karakter rahasia',
                      prefixIcon: const Icon(Icons.lock_outline),
                      // Ikon mata yang bisa ditekan
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    // Perbaikan validasi sandi
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Kata sandi tidak boleh kosong';
                      if (value.length < 8) return 'Minimal 8 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    // style dihapus karena sudah diurus tema
                    onPressed: () {
                      // Validasi dipanggil dari objek FormState
                      if (formKey.currentState!.validate()) { 
                        // Proses registrasi
                        final name = _nameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;
                        // TODO: Jalankan fungsi registrasi
                      }
                    },
                    child: const Text('Buat Akun TaleMark →'),
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