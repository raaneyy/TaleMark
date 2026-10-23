import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'auth_widgets.dart';

Future<void> showForgotPasswordDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black12,
    builder: (_) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: const _ForgotPasswordDialog(),
    ),
  );
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog();

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmController = TextEditingController();

  int _step = 0; // 0 = email, 1 = kode, 2 = kata sandi baru
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _hasMinLength = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _step--);
    }
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    if (_step == 0) {
      // TODO: kirim kode verifikasi ke _emailController.text
      setState(() => _step = 1);
    } else if (_step == 1) {
      // TODO: verifikasi kode dari _codeController.text
      setState(() => _step = 2);
    } else {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Kata sandi berhasil diubah')),
      );
    }
  }

  Widget _label(String text) =>
      Text(text, style: const TextStyle(fontSize: 11, color: Colors.black));

  List<Widget> _buildStep() {
    switch (_step) {
      case 0:
        return [
          _label('Input your account email'),
          const SizedBox(height: 8),
          TextFormField(
            key: const ValueKey('email'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Your Email'),
            validator: (String? value) {
              if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
              if (!value.contains('@')) return 'Format email tidak valid';
              return null;
            },
          ),
        ];
      case 1:
        return [
          _label('Enter code'),
          const SizedBox(height: 8),
          TextFormField(
            key: const ValueKey('code'),
            controller: _codeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Code'),
            validator: (String? value) {
              if (value == null || value.isEmpty) return 'Kode tidak boleh kosong';
              return null;
            },
          ),
        ];
      default:
        return [
          TextFormField(
            key: const ValueKey('new'),
            controller: _newPasswordController,
            obscureText: _obscureNew,
            onChanged: (value) => setState(() => _hasMinLength = value.length >= 8),
            decoration: InputDecoration(
              hintText: 'New Password',
              suffixIcon: IconButton(
                icon: Icon(_obscureNew
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
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
          const SizedBox(height: 16),
          TextFormField(
            key: const ValueKey('confirm'),
            controller: _confirmController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              hintText: 'Re-type New Password',
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) return 'Ketik ulang kata sandi';
              if (value != _newPasswordController.text) return 'Kata sandi tidak sama';
              return null;
            },
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: _back,
                  icon: const Icon(Icons.arrow_back, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Lupa Password?',
                style: AppTheme.serif(size: 26),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ..._buildStep(),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  onPressed: _next,
                  child: Text(_step == 2 ? 'Ubah Password' : 'Send Code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}