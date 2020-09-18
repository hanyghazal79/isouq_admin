import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformationModel {
  String id,
      userLocal,
      userName,
      userPhone1,
      userId;

  UserInformationModel({this.id, this.userLocal, this.userName,
      this.userPhone1, this.userId});

  UserInformationModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        userId = (snapshot != null && snapshot.get("userId") != null)
            ? snapshot.get("userId")
            : "",
        userName = (snapshot != null && snapshot.get("userName") != null)
            ? snapshot.get("userName")
            : "",
        userPhone1 = (snapshot != null && snapshot.get("userNumber1") != null)
            ? snapshot.get("userNumber1")
            : "",
        userLocal = (snapshot != null && snapshot.get("userLocal") != null)
            ? snapshot.get("userLocal")
            : "";

  factory UserInformationModel.fromMap(Map<String, dynamic> map) {
    return UserInformationModel(
        userLocal: map['userLocal'],
        userPhone1: map['userNumber1'],
        userName: map['userName'],
        id: map['id'],
        userId: map['userId'],
        );
  }
}
