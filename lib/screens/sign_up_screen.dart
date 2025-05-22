import 'package:flutter/material.dart';
import 'package:class_assignments/services/auth_service.dart';
import 'home_screen.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SignUpScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signUpWithEmail() async {
    setState(() => _isLoading = true);
    final user = await _authService.signUpWithEmail(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (user != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, animation, __) => HomeScreen(toggleTheme: widget.toggleTheme),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-up failed. Try again.')),
      );
    }
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
                      'Sign Up',
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
                      onPressed: _signUpWithEmail,
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignInScreen(toggleTheme: widget.toggleTheme),
                          ),
                        );
                      },
                      child: const Text('Already have an account? Sign In'),
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