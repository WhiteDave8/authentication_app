import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/glass_card.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final email = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  final auth = AuthService();
  String? info;
  bool busy = false;

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedLuxuryBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GlassCard(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Reset your password', style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    const Text('Enter your account email and we\'ll send a reset link.',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 18),
                    Form(
                      key: keyForm,
                      child: TextFormField(
                        controller: email,
                        validator: (v) => (v==null||!v.contains('@')) ? 'Enter a valid email' : null,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: busy ? null : () async {
                        if (!keyForm.currentState!.validate()) return;
                        setState(() { busy = true; info = null; });
                        await auth.sendResetEmail(email.text.trim());
                        if (mounted) setState(() {
                          busy = false;
                          info = 'If an account exists for ${email.text}, a reset link has been sent.';
                        });
                      },
                      child: Text(busy ? 'Sending…' : 'Send reset link'),
                    ),
                    if (info != null) ...[const SizedBox(height: 10), Text(info!, style: const TextStyle(color: Colors.white70))],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
