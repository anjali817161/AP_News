// lib/modules/auth/login_signup_page.dart
import 'package:ap_news/modules/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({Key? key}) : super(key: key);

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  int _selectedIndex = 0; // 0: Login, 1: Signup

  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  final _loginEmail = TextEditingController();
  final _loginPass = TextEditingController();
  bool _loginObscure = true;

  final _signName = TextEditingController();
  final _signEmail = TextEditingController();
  final _signPass = TextEditingController();
  bool _signObscure = true;

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPass.dispose();
    _signName.dispose();
    _signEmail.dispose();
    _signPass.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_loginKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login (demo)')));
    }
    Get.off(() => HomePage());
  }

  void _onSignup() {
    if (_signupKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signup (demo)')));
    }
  }

  Widget _logo(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/ap_icon.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Text(
            'AP',
            style: TextStyle(
              color: Colors.red[900],
              fontSize: size * 0.36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _segmentToggle() {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: _selectedIndex == 0
                      ? const LinearGradient(
                          colors: [Color(0xFFe53935), Color(0xFFb71c1c)],
                        )
                      : null,
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.white : Colors.red[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: _selectedIndex == 1
                      ? const LinearGradient(
                          colors: [Color(0xFFe53935), Color(0xFFb71c1c)],
                        )
                      : null,
                ),
                child: Text(
                  'Signup',
                  style: TextStyle(
                    color: _selectedIndex == 1 ? Colors.white : Colors.red[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    IconData? prefix,
    Widget? suffix,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefix != null
              ? Icon(prefix, color: Colors.red[900])
              : null,
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _gradientButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFe53935), Color(0xFFb71c1c)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final logoSize = 94.0;
    // white panel starts at 40% from top and covers down to bottom
    final panelTop = mq.size.height * 0.20;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Red gradient full screen background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 192, 14, 14),
                  Color.fromARGB(255, 183, 31, 31),
                ],
              ),
            ),
          ),

          // White rounded panel that starts from top-half-ish to bottom
          Positioned(
            top: panelTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 28, left: 18, right: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // small handle
                    Center(
                      child: Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),

                    // Toggle
                    _segmentToggle(),
                    const SizedBox(height: 18),

                    // Forms
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      firstChild: Form(
                        key: _loginKey,
                        child: Column(
                          children: [
                            _textField(
                              controller: _loginEmail,
                              hint: 'Email Address',
                              prefix: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || !v.contains('@')
                                  ? 'Enter valid email'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            _textField(
                              controller: _loginPass,
                              hint: 'Password',
                              prefix: Icons.lock_outline,
                              obscure: _loginObscure,
                              suffix: IconButton(
                                icon: Icon(
                                  _loginObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.red[900],
                                ),
                                onPressed: () => setState(
                                  () => _loginObscure = !_loginObscure,
                                ),
                              ),
                              validator: (v) => v == null || v.length < 4
                                  ? 'Min 4 chars'
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _gradientButton('Login', _onLogin),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                      secondChild: Form(
                        key: _signupKey,
                        child: Column(
                          children: [
                            _textField(
                              controller: _signName,
                              hint: 'Full Name',
                              prefix: Icons.person_outline,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Enter name' : null,
                            ),
                            const SizedBox(height: 12),
                            _textField(
                              controller: _signEmail,
                              hint: 'Email Address',
                              prefix: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || !v.contains('@')
                                  ? 'Enter valid email'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            _textField(
                              controller: _signPass,
                              hint: 'Password',
                              prefix: Icons.lock_outline,
                              obscure: _signObscure,
                              suffix: IconButton(
                                icon: Icon(
                                  _signObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.red[900],
                                ),
                                onPressed: () => setState(
                                  () => _signObscure = !_signObscure,
                                ),
                              ),
                              validator: (v) => v == null || v.length < 6
                                  ? 'Min 6 chars'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _gradientButton('Signup', _onSignup),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                      crossFadeState: _selectedIndex == 0
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                    ),

                    // switch text
                    GestureDetector(
                      onTap: () =>
                          setState(() => _selectedIndex = 1 - _selectedIndex),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text: _selectedIndex == 0
                                  ? "Not a member? "
                                  : "Already a member? ",
                              style: const TextStyle(color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: _selectedIndex == 0
                                      ? "Signup now"
                                      : "Login now",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),

          // Logo + heading that sit above the white panel and overlap
          Positioned(
            top: panelTop - 60, // place logo so it overlaps
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _logo(96),
                const SizedBox(height: 12),
                Text(
                  _selectedIndex == 0 ? 'Welcome Back!' : 'Create an Account',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _selectedIndex == 0
                      ? 'Sign in to continue'
                      : 'Sign up to get started',
                  style: TextStyle(color: Colors.blueGrey.withOpacity(0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
