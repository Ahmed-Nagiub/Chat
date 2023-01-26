import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/my_user.dart';
import 'package:chat_app/models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseUtils {
  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.COLLECTION_NAME)
        .withConverter<MyUser>(
            fromFirestore: (snap, _) => MyUser.fromJson(snap.data()!),
            toFirestore: (user, _) => user.toJson());
  }

  static CollectionReference<Room> getRoomsCollection() {
    return FirebaseFirestore.instance
        .collection(Room.COLLECTION_NAME)
        .withConverter<Room>(
            fromFirestore: (snap, _) => Room.fromJson(snap.data()!),
            toFirestore: (room, _) => room.toJson());
  }

  static CollectionReference<Message> getMessagesCollection(String roomID) {
    return getRoomsCollection()
        .doc(roomID)
        .collection(Message.COLLECTION_NAME)
        .withConverter(
            fromFirestore: (snap, _) => Message.fromJson(snap.data()!),
            toFirestore: (message, _) => message.toJson());
  }

  static Future<void> addMessageToFirestore(Message message) {
    var MessRef = getMessagesCollection(message.roomId).doc();
    message.id = MessRef.id;
    return MessRef.set(message);
  }

  static Stream<QuerySnapshot<Message>> readMessagesFromFirebase(
      String roomId) {
    return getMessagesCollection(roomId).orderBy("dateTime").snapshots();
  }

  static Future<void> addRoomToFirestore(Room room) {
    var DocRef = getRoomsCollection().doc();
    room.id = DocRef.id;
    return DocRef.set(room);
  }

  static Future<List<Room>> getRoomFromFirebase() async {
    var snapShotRoom = await getRoomsCollection().get();
    List<Room> rooms = snapShotRoom.docs.map((doc) => doc.data()).toList();
    return rooms;
  }

  static Future<void> addUserToFirestore(MyUser myUser) async {
    return getUserCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFirestore(String id) async {
    DocumentSnapshot<MyUser> UserRef = await getUserCollection().doc(id).get();
    return UserRef.data();
  }
}
