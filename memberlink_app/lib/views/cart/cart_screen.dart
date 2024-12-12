// import 'package:flutter/material.dart';
// import 'package:memberlink_app/models/cart_item.dart';
// import 'package:memberlink_app/provider/cart_provider.dart';
// import 'package:provider/provider.dart';

// class CartScreen extends StatelessWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Cart'),
//       ),
//       body: Consumer<CartProvider>(
//         builder: (context, cartProvider, child) {
//           final cartItems = cartProvider.cartItems;

//           if (cartItems.isEmpty) {
//             return const Center(
//               child: Text('Your cart is empty!'),
//             );
//           }

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: cartItems.length,
//                   itemBuilder: (context, index) {
//                     final cartItem = cartItems[index];
//                     return CartListItem(
//                       cartItem: cartItem,
//                       index: index,
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total:',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     Text(
//                       '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Handle checkout
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Proceeding to checkout...')),
//                   );
//                 },
//                 child: const Text('Checkout'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class CartListItem extends StatelessWidget {
//   final CartItem cartItem;
//   final int index;

//   const CartListItem({Key? key, required this.cartItem, required this.index})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.asset(
//               // Using the same logic from the product details dialog for local assets
//               "assets/products/${cartItem.product.productFilename}", // Assuming productFilename holds the image file name
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   cartItem.product.title,
//                   style: Theme.of(context).textTheme.titleMedium,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '\$${cartItem.product.productPrice}',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   cartProvider.increaseCartItemQuantity(index);
//                 },
//                 icon: const Icon(Icons.add),
//               ),
//               Text(
//                 cartItem.quantity.toString(),
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               IconButton(
//                 onPressed: () {
//                   cartProvider.decreaseCartItemQuantity(index);
//                 },
//                 icon: const Icon(Icons.remove),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
