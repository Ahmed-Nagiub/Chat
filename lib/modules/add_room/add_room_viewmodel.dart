import 'package:chat_app/base.dart';
import 'package:chat_app/database_utils/database_utils.dart';
import 'package:chat_app/models/room.dart';
import 'package:chat_app/modules/add_room/add_room_navigator.dart';

class AddRoomViewModel extends BaseViewModel<AddRoomNavigator> {
  void createRoom(String roomName, String roomDescription, String catId) {
    Room room = Room(
        roomName: roomName, roomDescription: roomDescription, catId: catId);
    DataBaseUtils.addRoomToFirestore(room).then((value) {
      navigator!.roomCreated();
      return;
    }).catchError((error) {
      navigator!.showMessage(error.toString());
    });
  }
}
