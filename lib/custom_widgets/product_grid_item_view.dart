import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_users/models/product_models.dart';
import 'package:ecom_users/pages/product_details_page.dart';
import 'package:ecom_users/utils/constants.dart';
import 'package:ecom_users/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductGridItemView extends StatelessWidget {
  final ProductModel productModel;

  const ProductGridItemView({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: productModel);
      },
      child: Card(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    productModel.productName,
                    style: const TextStyle(fontSize: 16, color: Colors.cyan),
                  ),
                ),
                if (productModel.productDiscount > 0)
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RichText(
                        text: TextSpan(
                            text:
                                '$currencySymbol${getPriceAfterDiscount(productModel.salePrice, productModel.productDiscount)}\t',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            children: [
                              TextSpan(
                                text:
                                    '$currencySymbol${productModel.salePrice}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2,
                                  decorationColor: Colors.red,
                                ),
                              ),
                            ]),
                      )),
                if (productModel.productDiscount == 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$currencySymbol${productModel.salePrice}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: productModel.avgRating.toDouble(),
                        minRating: 0.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemSize: 25,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                        },
                      ),
                      Text('${productModel.avgRating}',style: const TextStyle(fontSize: 20,color: Colors.green),),
                    ],
                  ),
                )
              ],
            ),
            if (productModel.productDiscount > 0)
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  height: 40,
                  color: Colors.tealAccent.withOpacity(0.5),
                  child: Text(
                    '${productModel.productDiscount}% OFF',
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
