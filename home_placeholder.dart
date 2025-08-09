import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Signed in')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome, ${user?.displayName ?? user?.email ?? "User"}'),
            const SizedBox(height: 12),
            const Text('Replace this screen with your app home.'),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }
}
