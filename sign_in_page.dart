import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/brand_button.dart';
import '../widgets/nice_field.dart';
import 'sign_up_page.dart';
import 'forgot_password_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool showPassword = false;
  bool busy = false;
  String? error;
  final auth = AuthService();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedLuxuryBackground(
        child: Center(
          child: LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 900;
            final content = GlassCard(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('Sign in to continue', style: TextStyle(color: Colors.white70)),
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
                            validator: (v) => (v==null||v.length<6) ? 'Min 6 characters' : null,
                            trailing: IconButton(
                              onPressed: () => setState(() => showPassword = !showPassword),
                              icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                            ),
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
                          await auth.signInWithEmail(email.text.trim(), password.text.trim());
                        } catch (e) {
                          setState(() { error = e.toString(); });
                        } finally {
                          if (mounted) setState(() { busy = false; });
                        }
                      },
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: Text(busy ? 'Signing in…' : 'Sign in'),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(children: const [
                      Expanded(child: Divider(color: Colors.white24)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('or', style: TextStyle(color: Colors.white70))),
                      Expanded(child: Divider(color: Colors.white24)),
                    ]),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        BrandButton(label: 'Continue with Google', icon: Icons.g_mobiledata, onPressed: () async {
                          try { await auth.signInWithGoogle(); } catch (e) { setState(() { error = e.toString(); }); }
                        }),
                        BrandButton(label: 'Continue with Apple', icon: Icons.apple, onPressed: () async {
                          try { await auth.signInWithApple(); } catch (e) { setState(() { error = e.toString(); }); }
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No account?", style: TextStyle(color: Colors.white70)),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpPage())),
                          child: const Text('Create one'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );

            if (!wide) return Padding(padding: const EdgeInsets.all(20), child: content);

            // Side-by-side layout for wide screens
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('👋 Hello again', style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 6),
                          Text('Sign in to your account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                          SizedBox(height: 10),
                          Text('Access projects, analytics and more with a single secure login.',
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: content),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
