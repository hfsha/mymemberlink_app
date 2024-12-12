import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Product product, int quantity, String s) {
    // Check if the product already exists in the cart
    var existingCartItem = _cartItems.firstWhereOrNull(
      (item) => item.product.productId == product.productId,
    );

    if (existingCartItem != null) {
      // If product exists, increase the quantity
      existingCartItem.quantity += quantity;
    } else {
      // If product does not exist, add a new cart item
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  int getProductQuantity(String productId) {
    // Get the total quantity of a specific product in the cart
    return _cartItems
        .where((item) => item.product.productId == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  int get cartCount {
    // Calculate total number of items in the cart
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    // Calculate the total price of items in the cart
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.productPrice! * item.quantity),
    );
  }

  void updateCartItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void increaseCartItemQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseCartItemQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        // Remove item from cart if quantity becomes 0
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeCartItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    } else {
      print("Attempted to remove item at invalid index: $index");
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  List<CartItem> getCartItemsList() {
    return List<CartItem>.from(_cartItems);
  }

  void decreaseQuantity(product) {}

  void increaseQuantity(Product product) {}
}
