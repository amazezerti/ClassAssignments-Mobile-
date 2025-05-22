import 'package:flutter/material.dart';
import 'package:class_assignments/services/auth_service.dart';
import 'home_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SignInScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signInWithEmail() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithEmail(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (user != null) {
      _navigateToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in failed. Check email/password.')),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithGoogle();
    setState(() => _isLoading = false);
    if (user != null) {
      _navigateToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In failed.')),
      );
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => HomeScreen(toggleTheme: widget.toggleTheme),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _signInWithEmail,
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(height: 16),
                    const Text('OR', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                      ),
                      onPressed: _signInWithGoogle,
                      icon: Image.asset('assets/google_logo.png', height: 24),
                      label: const Text('Sign in with Google'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignUpScreen(toggleTheme: widget.toggleTheme),
                          ),
                        );
                      },
                      child: const Text('Don\'t have an account? Sign Up'),
                    ),
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