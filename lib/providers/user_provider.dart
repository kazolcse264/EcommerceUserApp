
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/user_model.dart';
class UserProvider extends ChangeNotifier {

  Future<void> addUser(UserModel userModel) =>
      DbHelper.addUser(userModel);

  Future<bool> doesUserExist(String uid) =>
      DbHelper.doesUserExist(uid);
}