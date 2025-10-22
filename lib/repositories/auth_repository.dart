import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../services/api_endpoints.dart';

class AuthRepository {
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<User?> signup(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.signup),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw Exception('Signup failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> logout() async {
    // Implement logout logic, e.g., clear tokens
    // For now, just a placeholder
  }
}
