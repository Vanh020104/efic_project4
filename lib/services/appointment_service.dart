import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/v1/appointments';

  Future<void> createAppointment(DateTime datetimeStart) async {
    final prefs = await SharedPreferences.getInstance();
    final int? designerId = prefs.getInt('userId');
    final String? token = prefs.getString('accessToken');

    if (designerId == null) {
      throw Exception('User ID not found');
    }

    if (token == null) {
      throw Exception('Access token not found');
    }

    final String formattedDateTime = datetimeStart.toIso8601String();

    final Map<String, dynamic> body = {
      'datetimeStart': formattedDateTime,
      'designerId': designerId,
    };

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create appointment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating appointment: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableSlots(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final int? designerId = prefs.getInt('userId');
    final String? token = prefs.getString('accessToken');

    if (designerId == null) {
      throw Exception('User ID not found');
    }

    if (token == null) {
      throw Exception('Access token not found');
    }

    final String formattedDate = date.toIso8601String();
    final String url = '$_baseUrl/day?date=$formattedDate&designerId=$designerId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((slot) => slot as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch available slots: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching available slots: $e'); // In ra lỗi trong console
      throw Exception('Error fetching available slots: $e');
    }
  }

  Future<Map<String, dynamic>> getAppointmentDetail(int appointmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Access token not found');
    }

    final String url = '$_baseUrl/id/$appointmentId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch appointment detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointment detail: $e'); // In ra lỗi trong console
      throw Exception('Error fetching appointment detail: $e');
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Access token not found');
    }

    final String url = '$_baseUrl/$appointmentId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete appointment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting appointment: $e'); // In ra lỗi trong console
      throw Exception('Error deleting appointment: $e');
    }
  }
}