import 'package:chat_app/base.dart';
import 'package:chat_app/database_utils/database_utils.dart';
import 'package:chat_app/models/room.dart';
import 'home_screen_navigator.dart';

class HomeScreenViewModel extends BaseViewModel<HomeNavigator> {
  List<Room> rooms = [];

  void getRoom() async {
    try {
      rooms = await DataBaseUtils.getRoomFromFirebase();
      print(rooms.length);
    } catch (e) {
      navigator!.showMessage(e.toString());
    }
  }
}
