import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddressService {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/address_order';

  Future<void> postAddressOrder(Map<String, dynamic> addressData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addressData),
    );

    if (response.statusCode == 200) {
      print('Address order posted successfully');
    } else {
      print('Failed to post address order: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to post address order');
    }
  }
}