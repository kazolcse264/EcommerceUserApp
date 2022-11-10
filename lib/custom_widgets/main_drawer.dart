import 'package:ecom_users/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../pages/launcher_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 150,
            color: Theme.of(context).primaryColor,
          ),
           ListTile(
            onTap: (){},
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
           ListTile(
            onTap: (){},
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('My Carts'),
          ),
          ListTile(
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
