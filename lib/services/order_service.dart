import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/home/views/home_screen.dart';

class OrderService {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/orders';

  Future<void> placeOrder(Map<String, dynamic> orderData, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Token is missing');
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
       
     Navigator.pushNamed(context, createScreenRoute);

        // Navigator.pushReplacementNamed(context, homeScreenRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order failed!')),
        );
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Order failed')),
      // );
    }
  }
}