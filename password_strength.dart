import 'package:flutter/material.dart';

class PasswordStrengthBar extends StatelessWidget {
  final String password;
  const PasswordStrengthBar({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final s = _score(password);
    final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: s / 4,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          color: colors[s],
          backgroundColor: Colors.white.withOpacity(0.15),
        ),
        const SizedBox(height: 6),
        Text(['Very weak','Weak','Okay','Strong','Excellent'][s], style: TextStyle(color: Colors.white.withOpacity(0.9))),
      ],
    );
  }

  int _score(String p) {
    int score = 0;
    if (p.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) score++;
    return score.clamp(0, 4);
  }
}
