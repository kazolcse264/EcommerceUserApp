import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/photo_frame_view.dart';
import '../models/product_models.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

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
          /*SizedBox(
            height: 75,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhotoFrameView(
                    onImagePressed: () {
                      _showImageInDialog(0);
                    },
                    url: productModel.additionalImageModels[0],
                    child: IconButton(
                        onPressed: () {
                          _addImage(0);
                        },
                        icon: const Icon(Icons.add)),
                  ),
                  PhotoFrameView(
                    onImagePressed: () {
                      _showImageInDialog(1);
                    },
                    url: productModel.additionalImageModels[1],
                    child: IconButton(
                        onPressed: () {
                          _addImage(1);
                        },
                        icon: const Icon(Icons.add)),
                  ),
                  PhotoFrameView(
                    onImagePressed: () {
                      _showImageInDialog(2);
                    },
                    url: productModel.additionalImageModels[2],
                    child: IconButton(
                        onPressed: () {
                          _addImage(2);
                        },
                        icon: const Icon(Icons.add)),
                  ),
                ],
              ),
            ),
          ),*/
          Row(
            children: [
              Expanded(
                  child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite),
                label: const Text('ADD TO FAVORITE'),
              )),
              Expanded(
                  child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite),
                label: const Text('ADD TO CART'),
              )),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Rate this Product',
                      style: TextStyle(fontSize: 24),
                    ),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 0.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        userRating = rating;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    /* const Text(
                      'Write Your Review',
                      style: TextStyle(fontSize: 24),
                    ),
                    TextField(
                      focusNode: focusNode,
                      maxLines: 3,
                      controller: reviewTextController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        onPressed: () async {
                          EasyLoading.show(status: 'Please wait...');
                          focusNode.unfocus();
                          // _submitReview();
                          productProvider.addRating(productModel.productId!,
                              userRating, userProvider.userModel!);
                          EasyLoading.dismiss();
                          showMsg(context, 'Thanks for your rating');
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  onPressed: () {
                    focusNode.unfocus();
                    // _submitReview();
                  },
                  child: const Text('Show Comments'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'All Comments',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),

          /*AllCommentsWidget(
            donorId: id,
          )*/
        ],
      ),
    );
  }

  void _addImage(int index) async {
    final selectedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedFile != null) {
      EasyLoading.show(status: "Please Wait");
      final imageModel = await productProvider.uploadImage(selectedFile.path);
      final previousImageList = productModel.additionalImageModels;
      previousImageList[index] = imageModel.imageDownloadUrl;
      productProvider
          .updateProductField(
              productModel.productId!, productFieldImages, previousImageList)
          .then((value) {
        setState(() {
          productModel.additionalImageModels[index] =
              imageModel.imageDownloadUrl;
        });
        showMsg(context, 'Uploaded');
        EasyLoading.dismiss();
      }).catchError((error) {
        showMsg(context, 'Failed to uploaded');
        EasyLoading.dismiss();
      });
    }
  }

  void _showImageInDialog(int i) {
    final url = productModel.additionalImageModels[i];
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: CachedNetworkImage(
                //width: double.infinity,
                height: size.height / 2,
                fit: BoxFit.cover,
                imageUrl: url,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('CHANGE'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    EasyLoading.show(status: 'Deleting image');
                    setState(() {
                      productModel.additionalImageModels[i] = '';
                    });
                    try {
                      await productProvider.deleteImage(url);
                      await productProvider.updateProductField(
                        productModel.productId!,
                        productFieldImages,
                        productModel.additionalImageModels,
                      );
                      EasyLoading.dismiss();
                      //if(mounted)  showMsg(context, 'Deleted');
                    } catch (error) {
                      EasyLoading.dismiss();
                      //showMsg(context, 'Failed to Delete');
                    }
                  },
                  child: const Text('DELETE'),
                ),
              ],
            ));
  }
}
