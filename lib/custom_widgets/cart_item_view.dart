import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_users/models/cart_model.dart';
import 'package:ecom_users/utils/constants.dart';
import 'package:flutter/material.dart';

import '../providers/cart_provider.dart';

class CartItemView extends StatelessWidget {
  CartModel cartModel;
  CartProvider cartProvider;

  CartItemView(
      {super.key, required this.cartModel, required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey,
        color: Colors.white,
        child: SizedBox(
          height: 140,
          child: Column(
            children: [
              ListTile(
                leading: CachedNetworkImage(
                  width: 90,
                  height: 90,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: cartModel.productImageUrl,
                ),
                title: Text(
                  cartModel.productName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ), //Textstyle
                ),
                subtitle: Text(
                  'Unit Price : ${cartModel.salePrice}',
                  style: const TextStyle(
                    color: Colors.teal,
                  ), //Textstyle
                ),
                trailing: IconButton(
                    onPressed: () {
                      cartProvider.removeFromCart(cartModel.productId);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          cartProvider.decreaseQuantity(cartModel);
                        },
                        child: const Card(
                          elevation: 10,
                          shadowColor: Colors.black,
                          color: Colors.white,
                          child: Icon(
                            Icons.remove,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          '${cartModel.quantity} ',
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          cartProvider.increaseQuantity(cartModel);
                        },
                        child: const Card(
                          elevation: 10,
                          shadowColor: Colors.black,
                          color: Colors.white,
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Text(
                  '$currencySymbol${cartProvider.priceWithQuantity(cartModel)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ), //Padding
        ), //SizedBox
      ),
    );
  }
}
