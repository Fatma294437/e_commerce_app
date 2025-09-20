//checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/cart_provider.dart';
import '../models/product.dart';
import 'orders_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final VoidCallback? onOrderCompleted;

  const CheckoutScreen({super.key, this.onOrderCompleted});

  Future<void> _placeOrder(
    BuildContext context,
    List<Product> items,
    double totalPrice,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to place an order")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection("orders").add({
        "userId": user.uid,
        "items": items
            .map(
              (p) => {
                "id": p.id,
                "title": p.title,
                "price": p.price,
                "thumbnail": p.thumbnail,
              },
            )
            .toList(),
        "totalPrice": totalPrice,
        "status": "Pending",
        "timestamp": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully 🎉")),
      );

      Provider.of<CartProvider>(context, listen: false).clearCart();

      if (onOrderCompleted != null) {
        onOrderCompleted!();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrdersScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error placing order: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;

    double totalPrice = 0;
    for (var item in items) {
      totalPrice += item.price;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: items.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final Product product = items[index];
                      return ListTile(
                        leading: Image.network(
                          product.thumbnail,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(product.title),
                        subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () =>
                            _placeOrder(context, items, totalPrice),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
