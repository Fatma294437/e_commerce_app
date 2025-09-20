//wishlist_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  bool contains(Product product) => _items.contains(product);

  void addItem(Product product) {
    if (!_items.contains(product)) {
      _items.add(product);
      _saveWishlist();
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    _items.remove(product);
    _saveWishlist();
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    _saveWishlist();
    notifyListeners();
  }

  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = _items.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('wishlist', wishlistJson);
  }

  Future<void> loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = prefs.getStringList('wishlist') ?? [];
    _items.clear();
    _items.addAll(
      wishlistJson.map((item) => Product.fromJson(jsonDecode(item))).toList(),
    );
    notifyListeners();
  }
}
