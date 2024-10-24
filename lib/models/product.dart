import 'package:intl/intl.dart';
import 'package:shop/models/category.dart';

// Hàm để chuyển đổi chuỗi ngày tháng thành DateTime
DateTime parseDate(String dateString) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  return formatter.parse(dateString);
}

class Product {
  final int productId;
  final String name;
  final String description;
  final double price;
  final List<ProductImage> images;
  final int stockQuantity;
  final String manufacturer;
  final String size;
  final String weight;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Category? category;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.stockQuantity,
    required this.manufacturer,
    required this.size,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      images: (json['images'] as List)
          .map((imageJson) => ProductImage.fromJson(imageJson))
          .toList(),
      stockQuantity: json['stockQuantity'],
      manufacturer: json['manufacturer'],
      size: json['size'],
      weight: json['weight'],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      deletedAt: json['deletedAt'] != null ? parseDate(json['deletedAt']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }
}

class ProductImage {
  final int imageId;
  final String imageUrl;

  ProductImage({
    required this.imageId,
    required this.imageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      imageId: json['imageId'],
      imageUrl: json['imageUrl'],
    );
  }
}