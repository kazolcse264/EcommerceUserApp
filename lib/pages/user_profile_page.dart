import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_users/custom_widgets/user_profile_image_section.dart';
import 'package:ecom_users/models/address_model.dart';
import 'package:ecom_users/models/user_model.dart';
import 'package:ecom_users/pages/otp_verification_page.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:ecom_users/utils/widget_functions.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import 'launcher_page.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/add_user';

  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: userProvider.userModel == null
          ? const Center(child: Text('Failed to load user Data!'))
          : ListView(
              children: [
                UserProfileImageSection(userProvider: userProvider),
                //_headerSection(context, userProvider),
                ListTile(
                  leading: const Icon(Icons.call),
                  title: Text(userProvider.userModel!.phone ?? 'Not Set Yet'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Mobile Number',
                        onSubmit: (value) {
                          Navigator.pushNamed(
                              context, OtpVerificationPage.routeName,
                              arguments: value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(userProvider.userModel!.age ?? 'Not Set Yet'),
                  subtitle: const Text('Date of Birth'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(userProvider.userModel!.gender ?? 'Not Set Yet'),
                  subtitle: const Text('Gender'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                      userProvider.userModel!.addressModel?.addressLine1 ??
                          'Not Set Yet'),
                  subtitle: const Text('Address Line 1'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Address Line 1',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldAddressLine1',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                      userProvider.userModel!.addressModel?.addressLine2 ??
                          'Not Set Yet'),
                  subtitle: const Text('Address Line 2'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Address Line 2',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldAddressLine2',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(userProvider.userModel!.addressModel?.city ??
                      'Not Set Yet'),
                  subtitle: const Text('City'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'City',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldCity',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(userProvider.userModel!.addressModel?.zipcode ??
                      'Not Set Yet'),
                  subtitle: const Text('Zip Code'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Zip Code',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldZipcode',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ],
            ),
    );
  }

  /*Container _headerSection(BuildContext context, UserProvider userProvider) {
    return Container(
      height: 150,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Card(
            elevation: 5,
            child: userProvider.userModel!.imageUrl == null
                ? const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey,
                  )
                : CachedNetworkImage(
                    width: 90,
                    height: 90,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: userProvider.userModel!.imageUrl!,
                  ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userProvider.userModel!.displayName ?? 'No Display Name',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white,
                    ),
              ),
              Text(
                userProvider.userModel!.email,
                style: const TextStyle(color: Colors.white60),
              )
            ],
          ),
        ],
      ),
    );
  }*/
}
