import 'package:chat_app/base.dart';
import 'package:chat_app/database_utils/database_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/my_user.dart';
import '../../shared/component/firebase_errors.dart';
import 'create_account_navigator.dart';

class CreateAccountViewModel extends BaseViewModel<CreateAccountNavigator> {
  String? message;

  void createAccount(String fName, String lName, String userName, String email,
      String password) async {
    try {
      navigator!.showLoading();
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // add user to database
      MyUser myUser = MyUser(
          id: credential.user?.uid ?? "",
          fName: fName,
          lName: lName,
          userName: userName,
          email: email);
      DataBaseUtils.addUserToFirestore(myUser);
      navigator!.hideDialog();
      navigator!.goToHome(myUser);
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrors.weakPassword) {
        message = "The password provided is too weak.";
      } else if (e.code == FirebaseErrors.email_already_use) {
        message = "The account already exists for that email.";
      }
    } catch (e) {
      message = "Something went wrong";
      print(e);
    }
    if (message != null) {
      navigator!.hideDialog();
      navigator!.showMessage(message!);
    }
  }
}
