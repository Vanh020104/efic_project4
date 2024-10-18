import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/category.dart';

class CategoryService {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/categories/';

  Future<List<Category>> fetchCategories({int page = 1, int limit = 50}) async {
    final response = await http.get(Uri.parse('${apiUrl}getAll?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> content = body['data']['content'];
      List<Category> categories = content.map((dynamic item) => Category.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Category>> fetchCategoryParent() async {
    final response = await http.get(Uri.parse('${apiUrl}parentCategoryIsNull'));

    if (response.statusCode == 200) {
      // In ra phản hồi từ API để kiểm tra cấu trúc
      print('Response body: ${response.body}');
      
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> data = body['data'];
      List<Category> categoryParent = data.map((dynamic item) => Category.fromJson(item)).toList();
      return categoryParent;
    } else {
      print('Failed to load categoryParent: ${response.statusCode}');
      throw Exception('Failed to load categoryParent');
    }
  }
  Future<List<Category>> fetchCategoriesByParentId(int parentId) async {
    final response = await http.get(Uri.parse('${apiUrl}parentCategory/$parentId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> data = body['data'];
      List<Category> categories = data.map((dynamic item) => Category.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories by parent id');
    }
  }
}