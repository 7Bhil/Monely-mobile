import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/auth_repository.dart';
import 'package:go_router/go_router.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final _pinController = TextEditingController();
  String? _error;

  void _login() {
    final isValid = sl<AuthRepository>().verifyPin(_pinController.text);
    if (isValid) {
      context.go('/');
    } else {
      setState(() {
        _error = 'Code PIN incorrect';
      });
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.lock_person_outlined, size: 70, color: Color(0xFF38BDF8)),
              const SizedBox(height: 24),
              const Text(
                'Accès Sécurisé',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Entrez votre code PIN pour continuer',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: TextField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 32, letterSpacing: 16),
                  maxLength: 4,
                  onChanged: (value) {
                    if (value.length == 4) {
                      _login();
                    }
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _error != null ? Colors.red : Colors.white24),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF38BDF8)),
                    ),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
