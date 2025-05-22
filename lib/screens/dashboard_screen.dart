import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_screen.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  const DashboardScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SignInScreen(toggleTheme: toggleTheme)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Dashboard!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'User Information:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text('Email: ${user?.email ?? 'Not logged in'}'),
            Text('UID: ${user?.uid ?? 'N/A'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Explore Features'),
            ),
            const SizedBox(height: 20),
            Text(
              'Quick Actions:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: const Text('Feature 1'),
                      subtitle: const Text('Tap to explore'),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: const Text('Feature 2'),
                      subtitle: const Text('Tap to explore'),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}