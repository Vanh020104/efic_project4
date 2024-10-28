import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/cart_item.dart';

class CartService {
  final String baseUrl = 'http://10.0.2.2:8080';

  CartService();

  // Lấy token từ SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> addToCart(CartItem cartItem) async {
    final token = await getToken();
    if (token == null) {
      print('Token is null');
      throw Exception('Token is null');
    }

    print('Token: $token');
    print('CartItem: ${jsonEncode(cartItem.toJson())}');

    final url = Uri.parse('$baseUrl/api/v1/cart');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(cartItem.toJson()),
    );

    if (response.statusCode != 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Add to cart failed');
    }
  }

  // Lấy dữ liệu giỏ hàng
  Future<List<Map<String, dynamic>>> getCartData(int userId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    final url = Uri.parse('$baseUrl/api/v1/cart/user/$userId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((item) {
        return {
          'productId': item['id']['productId'],
          'userId': item['id']['userId'],
          'quantity': item['quantity'],
          'unitPrice': item['unitPrice'],
          'productName': item['productName'],
          'productPrice': item['productPrice'],
          'description': item['description'],
          'status': item['status'],
          'productImages': item['productImages'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load cart data');
    }
  }

  // Cập nhật số lượng sản phẩm
  Future<void> updateQuantity(int userId, int productId, int quantity) async {
    final token = await getToken();
    if (token == null) {
      print('Token is null');
      throw Exception('Token is null');
    }

    final url = Uri.parse('$baseUrl/api/v1/cart/updateQuantity?quantity=$quantity');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId.toString(),
        'productId': productId.toString(),
      }),
    );

    if (response.statusCode != 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Update quantity failed');
    }
  }
}