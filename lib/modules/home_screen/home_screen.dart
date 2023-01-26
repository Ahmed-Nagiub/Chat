import 'package:chat_app/base.dart';
import 'package:chat_app/modules/add_room/add_room_screen.dart';
import 'package:chat_app/modules/home_screen/home_screen_navigator.dart';
import 'package:chat_app/modules/home_screen/room_widget.dart';
import 'package:chat_app/modules/login/login_screen.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen_vm.dart';

class homeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends BaseView<homeScreen, HomeScreenViewModel>
    implements HomeNavigator {
  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
    viewModel.getRoom();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/main_bg.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, addRoomScreen.routeName);
                },
                child: Icon(Icons.add)),
            appBar: AppBar(
              title: const Text('Home'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(
                          context, loginScreen.routeName);
                    },
                    icon: Icon(Icons.logout)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<HomeScreenViewModel>(
                builder: (_, homeScreenViewModel, c) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1 / 1.2,
                    ),
                    itemCount: homeScreenViewModel.rooms.length,
                    itemBuilder: (context, index) {
                      return RoomWidget(homeScreenViewModel.rooms[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  HomeScreenViewModel initViewModel() {
    return HomeScreenViewModel();
  }
}
