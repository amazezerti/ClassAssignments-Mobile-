import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'calculator_screen.dart';
import 'dashboard_screen.dart';
import 'product_list_screen.dart';
import 'contacts_screen.dart';
import 'sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const CalculatorScreen(),
      DashboardScreen(toggleTheme: widget.toggleTheme),
      const ProductListScreen(),
      const ContactsScreen(),
    ];
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateWithFade(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _showLogoutDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          GestureDetector(
            onTap: _showImagePicker,
            child: CircleAvatar(
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : const AssetImage('assets/profile_avatar.jpg') as ImageProvider,
              radius: 18,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'Guest'),
              accountEmail: Text(user?.email ?? 'guest@example.com'),
              currentAccountPicture: GestureDetector(
                onTap: _showImagePicker,
                child: CircleAvatar(
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : const AssetImage('assets/profile_avatar.jpg') as ImageProvider,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Calculator'),
              onTap: () {
                _navigateWithFade(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                _navigateWithFade(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Products'),
              onTap: () {
                _navigateWithFade(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contacts'),
              onTap: () {
                _navigateWithFade(3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                if (await _showLogoutDialog()) {
                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (_, animation, __) => SignInScreen(toggleTheme: widget.toggleTheme),
                      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateWithFade,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculator'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
        ],
      ),
    );
  }
}