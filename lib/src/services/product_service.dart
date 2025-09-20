//product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  Future<Map<String, dynamic>> fetchProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final uri = Uri.parse(
      "https://dummyjson.com/products?limit=$limit&skip=$skip",
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List products = data['products'];
      final int total = data['total'] ?? 0;

      return {
        "products": products.map((p) => Product.fromJson(p)).toList(),
        "total": total,
      };
    } else {
      throw Exception("Failed to load products");
    }
  }

  // ✅ البحث عن المنتجات
  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse("https://dummyjson.com/products/search?q=$query");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List products = data['products'];
      return products.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception("Failed to search products");
    }
  }
}
