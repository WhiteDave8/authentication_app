import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/brand_button.dart';
import '../widgets/nice_field.dart';
import '../widgets/password_strength.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool showPassword = false;
  bool busy = false;
  String? error;
  final auth = AuthService();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirm.dispose();
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
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Create your account', style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('Join us and unlock premium features.',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 22),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          NiceField(
                            controller: email,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v==null||v.isEmpty||!v.contains('@')) ? 'Enter a valid email' : null,
                          ),
                          const SizedBox(height: 12),
                          NiceField(
                            controller: password,
                            label: 'Password',
                            obscure: !showPassword,
                            validator: (v) => (v==null||v.length<8) ? 'Min 8 characters' : null,
                            trailing: IconButton(
                              onPressed: () => setState(() => showPassword = !showPassword),
                              icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                          const SizedBox(height: 10),
                          PasswordStrengthBar(password: password.text),
                          const SizedBox(height: 12),
                          NiceField(
                            controller: confirm,
                            label: 'Confirm password',
                            obscure: true,
                            validator: (v) => (v!=password.text) ? 'Passwords do not match' : null,
                          ),
                        ],
                      ),
                    ),
                    if (error != null) ...[const SizedBox(height: 8), Text(error!, style: const TextStyle(color: Colors.redAccent))],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: busy ? null : () async {
                        if (!formKey.currentState!.validate()) return;
                        setState(() { busy = true; error = null; });
                        try {
                          await auth.signUpWithEmail(email.text.trim(), password.text.trim());
                          if (mounted) Navigator.of(context).pop();
                        } catch (e) {
                          setState(() { error = e.toString(); });
                        } finally {
                          if (mounted) setState(() { busy = false; });
                        }
                      },
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: Text(busy ? 'Creating…' : 'Create account'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Have an account?", style: TextStyle(color: Colors.white70)),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Sign in'),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'By continuing you agree to our Terms and Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    )
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
