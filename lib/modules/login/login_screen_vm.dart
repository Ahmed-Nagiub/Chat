import 'package:chat_app/base.dart';
import 'package:chat_app/database_utils/database_utils.dart';
import 'package:chat_app/models/my_user.dart';
import 'package:chat_app/modules/login/login_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../shared/component/firebase_errors.dart';

class LoginViewModel extends BaseViewModel<LoginNavigator> {
  var auth = FirebaseAuth.instance;
  String message = "";

  void login(String email, String password) async {
    try {
      navigator!.showLoading();
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      MyUser? myUser =
          await DataBaseUtils.readUserFromFirestore(credential.user?.uid ?? "");
      if (myUser != null) {
        navigator!.hideDialog();
        navigator!.goToHome(myUser);
        return;
      } else {
        message = "Not Found User In Database";
      }
    } on FirebaseAuthException catch (e) {
      message = "wrong email or password";
    } catch (e) {
      print("heeerrreeee $e");
      message = "Something went wrong";
    }
    if (message != "") {
      navigator!.hideDialog();
      navigator!.showMessage(message);
    }
  }
}
