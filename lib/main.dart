import 'package:chat_app/modules/add_room/add_room_screen.dart';
import 'package:chat_app/modules/chat/chat_screen.dart';
import 'package:chat_app/modules/create_account/create_account.dart';
import 'package:chat_app/modules/home_screen/home_screen.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modules/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      create: (context) => UserProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return MaterialApp(
      initialRoute: provider.userAuth == null
          ? loginScreen.routeName
          : homeScreen.routeName,
      routes: {
        createAccountScreen.routeName: (context) => createAccountScreen(),
        loginScreen.routeName: (context) => loginScreen(),
        homeScreen.routeName: (context) => homeScreen(),
        addRoomScreen.routeName: (context) => addRoomScreen(),
        chatScreen.routeName: (context) => chatScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
