//cart_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  // حذف هذا السطر
  // CartProvider() {
  //   _loadCart();
  // }

  void addItem(Product product) {
    _items.add(product);
    _saveCart();
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.remove(product);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _items.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('cart', cartJson);
  }

  // الدالة التي تم تعديلها لتكون عامة
  Future<void> loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList('cart') ?? [];
    _items.clear();
    _items.addAll(
      cartJson.map((item) => Product.fromJson(jsonDecode(item))).toList(),
    );
    notifyListeners();
  }
}
