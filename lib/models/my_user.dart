class MyUser {
  static const String COLLECTION_NAME = "User";
  String id;
  String fName;
  String lName;
  String userName;
  String email;

  MyUser(
      {required this.id,
      required this.fName,
      required this.lName,
      required this.userName,
      required this.email});

  MyUser.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          fName: json["fName"],
          lName: json["lName"],
          email: json["email"],
          userName: json["userName"],
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fName": fName,
      "lName": lName,
      "email": email,
      "userName": userName,
    };
  }
}
