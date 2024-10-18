import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api/v1/users/';

  Future<Map<String, dynamic>> getUserInfo(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // print('API Response: $responseBody'); // In ra dữ liệu trả về từ API để kiểm tra
      return responseBody['data'];
    } else {
      throw Exception('Failed to load user data');
    }
  }
}