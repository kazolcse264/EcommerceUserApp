import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_users/custom_widgets/cart_bubble_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/cart_item_view.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cart';

  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                Provider.of<CartProvider>(context,listen: false).clearCart();

              },
              child: const Text('CLEAR',style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15,
              ),),
            ),
          )
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartModel = provider.cartList[index];
                  return CartItemView(
                    cartModel: cartModel,
                    cartProvider: provider,
                  );
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'SUBTOTAL :   $currencySymbol${provider.getCartSubTotal()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    )),
                    OutlinedButton(
                      onPressed: provider.totalItemsInCart == 0 ? null : () {
                        Navigator.pushNamed(context, CheckoutPage.routeName);
                      },
                      child: const Text('CHECKOUT'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
