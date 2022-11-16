import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../custom_widgets/photo_frame_view.dart';
import '../models/comment_model.dart';
import '../models/product_models.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import '../utils/widget_functions.dart';
import 'login_page.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details';

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late UserProvider userProvider;
  late ProductProvider productProvider;
  late Size size;
  final focusNode = FocusNode();
  double userRating = 0.0;
  TextEditingController reviewTextController = TextEditingController();
  String photoUrl = '';
  final txtController = TextEditingController();

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    photoUrl = productModel.thumbnailImageModel.imageDownloadUrl;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: photoUrl,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
              onTap: () {
                setState(() {
                  photoUrl = productModel.thumbnailImageModel.imageDownloadUrl;
                });
              },
              child: Card(
                child: CachedNetworkImage(
                  height: 100,
                  width: 70,
                  fit: BoxFit.fill,
                  imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            ...productModel.additionalImageModels.map((url) {
              return url.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          photoUrl = url;
                        });
                      },
                      child: Card(
                        child: CachedNetworkImage(
                          height: 100,
                          width: 70,
                          fit: BoxFit.fill,
                          imageUrl: url,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
            }).toList(),
          ]),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  label: const Text('ADD TO FAVORITE'),
                ),
              ),
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    final isInCart =
                    provider.isProductInCart(productModel.productId!);
                    return TextButton.icon(
                      onPressed: () async {
                        EasyLoading.show(status: 'Please wait');
                        if (isInCart) {
                          //remove
                          await provider
                              .removeFromCart(productModel.productId!);
                          if(mounted)showMsg(context, 'Removed from Cart');
                        } else {
                          await provider.addToCart(
                            productId: productModel.productId!,
                            productName: productModel.productName,
                            url: productModel
                                .thumbnailImageModel.imageDownloadUrl,
                            salePrice: num.parse(getPriceAfterDiscount(
                                productModel.salePrice,
                                productModel.productDiscount)),
                          );
                          if(mounted)showMsg(context, 'Added to Cart');
                        }
                        EasyLoading.dismiss();
                      },
                      icon: Icon(isInCart
                          ? Icons.remove_shopping_cart
                          : Icons.shopping_cart),
                      label:
                      Text(isInCart ? 'REMOVE FROM CART' : 'ADD TO CART'),
                    );
                  },
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title:
                Text('Sale Price : $currencySymbol${productModel.salePrice}'),
            subtitle: Text(
                'Discount : $currencySymbol${productModel.productDiscount}%'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Final Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '$currencySymbol${productProvider.priceAfterDisCount(productModel.salePrice, productModel.productDiscount)}',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Description'),
            subtitle: Text('${productModel.longDescription}'),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Rate this Product'),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 0.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: false,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        userRating = rating;
                      },
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (AuthService.currentUser!.isAnonymous) {
                        showCustomDialog(
                          context: context,
                          title: 'Unregistered User',
                          positiveButtonText: 'Login',
                          content:
                          'To rate this product, you need to login with your email and password or Google Account. To login with your account, go to Login Page',
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                        );
                      } else {
                        EasyLoading.show(status: 'Please wait');
                        await productProvider.addRating(
                          productModel.productId!,
                          userRating,
                          userProvider.userModel!,
                        );
                        EasyLoading.dismiss();
                        if(mounted)showMsg(context, 'Thanks for your rating');
                      }
                    },
                    child: const Text('SUBMIT'),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Comments',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add your comment'),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: TextField(
                      focusNode: focusNode,
                      controller: txtController,
                      maxLines: 3,
                      decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (txtController.text.isEmpty) return;
                      if (AuthService.currentUser!.isAnonymous) {
                        showCustomDialog(
                          context: context,
                          title: 'Unregistered User',
                          positiveButtonText: 'Login',
                          content:
                          'To comment this product, you need to login with your email and password or Google Account. To login with your account, go to Login Page',
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                        );
                      } else {
                        EasyLoading.show(status: 'Please wait');
                        await productProvider.addComment(
                          productModel.productId!,
                          txtController.text,
                          userProvider.userModel!,
                        );
                        EasyLoading.dismiss();
                        focusNode.unfocus();
                        if(mounted) {
                          showMsg(context,
                            'Thanks for your comment. Your comment is waiting for Admin approval');
                        }
                      }
                    },
                    child: const Text('SUBMIT'),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'All Comments',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          FutureBuilder<List<CommentModel>>(
            future:
            productProvider.getCommentsByProduct(productModel.productId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final commentList = snapshot.data!;
                if (commentList.isEmpty) {
                  return const Center(
                    child: Text('No comments found'),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: commentList
                        .map((comment) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(comment.userModel.displayName ??
                              comment.userModel.email),
                          subtitle: Text(comment.date),
                          leading: comment.userModel.imageUrl == null
                              ? const Icon(Icons.person)
                              : CachedNetworkImage(
                            width: 70,
                            height: 100,
                            fit: BoxFit.fill,
                            imageUrl: comment.userModel.imageUrl!,
                            placeholder: (context, url) => const Center(
                                child:
                                CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            comment.comment,
                          ),
                        ),
                      ],
                    ))
                        .toList(),
                  );
                }
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Failed to load comments'));
              }
              return const Center(
                child: Text('Loading comments'),
              );
            },
          )

          /*AllCommentsWidget(
            donorId: id,
          )*/
        ],
      ),
    );
  }

}


