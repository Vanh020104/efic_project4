import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api/v1/auth/login';

  Future<Map<String, dynamic>> login(String username, String password, String platform, String version) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'platform': platform, 'version': version}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final token = responseBody['accessToken'];
      final refreshToken = responseBody['refreshToken'];
      final userId = responseBody['id'];
      final roles = responseBody['roles'];

      // In ra dữ liệu trả về
      print('Login successful:');
      print('Access Token: $token');
      print('Refresh Token: $refreshToken');
      print('User ID: $userId');
      print('Roles: $roles');

      if (token != null && userId != null && roles != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', token);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setInt('userId', userId);
        await prefs.setStringList('roles', List<String>.from(roles));
      }
      return responseBody;
    } else {
      print('Login failed: ${response.body}');
      throw Exception('Failed to login');
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userId');
    await prefs.remove('roles');
  }

  Future<List<String>?> getRoles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('roles');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}