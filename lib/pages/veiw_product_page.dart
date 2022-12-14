
import 'package:ecom_users/custom_widgets/product_grid_item_view.dart';
import 'package:ecom_users/models/user_model.dart';
import 'package:ecom_users/providers/cart_provider.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/cart_bubble_view.dart';
import '../custom_widgets/main_drawer.dart';
import '../models/category_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/view_product';

  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;
  bool isGetAllProductsCalled = true;
  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
   if(isGetAllProductsCalled) {
     Provider.of<ProductProvider>(context, listen: false).getAllProducts();
     isGetAllProductsCalled = false;
   }
    Provider.of<ProductProvider>(context, listen: false).getAllPurchases();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<OrderProvider>(context, listen: false).getOrdersByUser();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    Provider.of<CartProvider>(context, listen: false).getAllCartItemsByUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      drawer: MainDrawer(userProvider: userProvider,),
      appBar: AppBar(
        title: const Text('All Products'),
        actions: const [
          CartBubbleView(),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<CategoryModel>(
                  isExpanded: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          const BorderSide(color: Colors.blue, width: 1))),
                  hint: const Text('Select Category'),
                  items: provider
                      .getCategoriesForFiltering()
                      .map((catModel) => DropdownMenuItem(
                    value: catModel,
                    child: Text(catModel.categoryName),
                  ))
                      .toList(),
                  value: categoryModel,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      categoryModel = value;
                    });
                    if (categoryModel!.categoryName == 'All') {
                      provider.getAllProducts();
                    } else {
                      provider.getAllProductsByCategory(
                          categoryModel!.categoryName);
                    }
                  }),
            ),

            Expanded(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: provider.productList.length,
                    itemBuilder: (context, index){
                      final product = provider.productList[index];
                      return ProductGridItemView(
                        productModel: product,
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
