import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';

class ProductService {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/products';

  Future<List<Product>> fetchProducts(int page, int limit) async {
    final response = await http.get(Uri.parse('$apiUrl/getAll?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['data']['content'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
  Future<Product> fetchProductById(int productId) async {
    final response = await http.get(Uri.parse('$apiUrl/id/$productId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data['data']);
    } else {
      throw Exception('Failed to load product');
    }
  }
  Future<List<Product>> fetchProductsByCategoryId(int categoryId) async {
    final response = await http.get(Uri.parse('$apiUrl/category/$categoryId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> content = body['data']['content'];
      List<Product> products = content.map((dynamic item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products by category id');
    }
  }
  Future<List<Product>> fetchPopularProducts() async {
    final response = await http.get(Uri.parse('$apiUrl/search-by-specification?page=1&size=7&sort=soldQuantity:desc'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['data']['content'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular products');
    }
  }



}