import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:flutter/material.dart';

class UserProfileImageSection extends StatelessWidget {
  final UserProvider userProvider;
  const UserProfileImageSection({Key? key, required this.userProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
