import 'package:ecom_users/auth/auth_service.dart';
import 'package:ecom_users/custom_widgets/user_profile_image_section.dart';
import 'package:ecom_users/models/user_model.dart';
import 'package:ecom_users/pages/user_profile_page.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:flutter/material.dart';

import '../pages/cart_page.dart';
import '../pages/launcher_page.dart';

class MainDrawer extends StatelessWidget {
  final UserProvider userProvider;
  const MainDrawer({Key? key, required this.userProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 150,
            color: Theme.of(context).primaryColor,
            child: UserProfileImageSection(userProvider:userProvider),
          ),
           if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          if(!AuthService.currentUser!.isAnonymous) ListTile(
            onTap: (){
              Navigator.pushNamed(context, CartPage.routeName);
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Carts'),
          ),
          if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: (){},
            leading: const Icon(Icons.monetization_on),
            title: const Text('My Orders'),
          ),
          ListTile(
            onTap: (){
              AuthService.logout().then((value)=>
              Navigator.pushReplacementNamed(context, LauncherPage.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
