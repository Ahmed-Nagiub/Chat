class Message {
  static const String COLLECTION_NAME = "Message";
  String id;
  String content;
  int dateTime;
  String roomId;
  String senderName;
  String senderId;

  Message(
      {this.id = "",
      required this.content,
      required this.dateTime,
      required this.roomId,
      required this.senderName,
      required this.senderId});

  Message.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          content: json['content'],
          dateTime: json['dateTime'],
          roomId: json['roomId'],
          senderName: json['senderName'],
          senderId: json['senderId'],
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "dateTime": dateTime,
      "roomId": roomId,
      "senderName": senderName,
      "senderId": roomId,
    };
  }
}
