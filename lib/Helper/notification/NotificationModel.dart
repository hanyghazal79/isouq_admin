//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/cupertino.dart';
//
//class NotificationModel with ChangeNotifier{
//  String id;
//  String desc,title,image;
//
//
//  NotificationModel({this.id,this.desc, this.title,this.image});
//
//  init()
//  {
//    notifyListeners();
//  }
//
//  NotificationModel.fromSnapshot(DataSnapshot snapshot) :
//        id = snapshot.key,
//      desc = snapshot.value["desc"],
//        title = snapshot.value["title"],
//        image = snapshot.value["image"];
//
//  NotificationModel.fromDocumentSnapshot(DocumentSnapshot snapshot) :
//        id = snapshot.documentID,
////        (snapshot!=null && snapshot["id"]!=null) ? snapshot["id"] : "",
//      desc = (snapshot!=null && snapshot["desc"]!=null) ? snapshot["desc"] : "",
//        title = (snapshot!=null && snapshot["title"]!=null) ? snapshot["title"] : "",
//        image = (snapshot!=null && snapshot["image"]!=null) ? snapshot["image"] : "";
//
//  static List<NotificationModel> getListOfNotification(List<DocumentSnapshot> snapshots)
//  {
//    List<NotificationModel> notifications = new List();
//    for(DocumentSnapshot doc in snapshots)
//      notifications.add(NotificationModel.fromDocumentSnapshot(doc));
//    return notifications;
//  }
//
//  toJson() {
//    return {
//      "id" : id,
//      "desc": desc,
//      "title": title,
//      "image": image
//    };
//  }
//
//  void setEmail(String email)
//  {
//    this.desc = email;
//    notifyListeners();
//  }
//  void setName(String name)
//  {
//    this.title = name;
//    notifyListeners();
//  }
//  void setImage(String image)
//  {
//    this.image = image;
//    notifyListeners();
//  }
//
//}