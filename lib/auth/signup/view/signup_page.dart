import 'package:ap_news/auth/login/view/login_view.dart';
import 'package:ap_news/modules/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/language_controller.dart';
import '../../../utils/localization.dart';
import '../../../views/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final languageController = Provider.of<LanguageController>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.signup)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: localizations.name),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: localizations.email),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: localizations.password),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            authController.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      try {
                        await authController.signup(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Signup failed: $e')),
                        );
                      }
                    },
                    child: Text(localizations.signup),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(localizations.login),
            ),
          ],
        ),
      ),
    );
  }
}
