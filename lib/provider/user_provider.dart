import 'package:chat_app/database_utils/database_utils.dart';
import 'package:chat_app/models/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  MyUser? myUser;
  User? userAuth;

  UserProvider() {
    userAuth = FirebaseAuth.instance.currentUser;
    print("hererererer $userAuth");
    initMyUser();
    print("hererererer $userAuth");
  }

  void initMyUser() async {
    if (userAuth != null) {
      myUser = await DataBaseUtils.readUserFromFirestore(userAuth?.uid ?? "");
    }
  }
}
