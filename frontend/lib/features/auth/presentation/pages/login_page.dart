import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/core/routes/app_router.dart';
// import 'package:shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUserButton(
              context,
              'User A',
              'user_a',
              Colors.blue,
            ),
            const SizedBox(height: 20),
            _buildUserButton(
              context,
              'User B',
              'user_b',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserButton(
    BuildContext context,
    String label,
    String userId,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);
        await prefs.setString('user_name', label);

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, AppRouter.home);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
