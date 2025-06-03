import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences.dart';
import 'package:frontend/core/routes/app_router.dart';
import 'package:frontend/features/call/presentation/pages/call_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentUserId;
  String? currentUserName;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('user_id');
      currentUserName = prefs.getString('user_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $currentUserName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pushReplacementNamed(context, AppRouter.login);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUserCard(
            'User A',
            'user_a',
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildUserCard(
            'User B',
            'user_b',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(String name, String userId, Color color) {
    final isCurrentUser = userId == currentUserId;

    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            name[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(name),
        subtitle: Text(isCurrentUser ? 'You' : 'Tap to call'),
        trailing: isCurrentUser
            ? const Icon(Icons.check_circle, color: Colors.green)
            : IconButton(
                icon: const Icon(Icons.video_call),
                onPressed: () => _initiateCall(userId, name),
              ),
      ),
    );
  }

  void _initiateCall(String targetUserId, String targetUserName) async{
    // In a real app, you would generate a channel name and token from your backend
    final channelName = '${currentUserId}_$targetUserId';
    print("channelName===>${channelName}");
    final token = 'YOUR_AGORA_TOKEN'; // Replace with actual token generation

    String? deveiceToken=await FirebaseMessaging.instance.getToken();
    print("deveiceToken===>${deveiceToken}");

    Navigator.pushNamed(
      context,
      AppRouter.call,
      arguments: {
        'channelName': 'useb_usera',
        'token': '0068d22cb493d054b3794615e4e85d70544IABFgFcDk3xcTwy/Xcq4trW2T0CMk1cZnvf5NYyhSRpMSDezJmKFOa53IgA1j0BXe1FAaAQAAQALDj9oAgALDj9oAwALDj9oBAALDj9o',
        'isIncoming': false,
      },
    );
  }
}
