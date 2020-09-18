import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class NotificationsDataPost {
  final String image, id, title, desc;

  NotificationsDataPost({this.image, this.id, this.title, this.desc});

  NotificationsDataPost.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key,
        image = snapshot.value["image"],
        title = snapshot.value["title"],
        desc = snapshot.value["desc"];

  NotificationsDataPost.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.get("id") != null) ? snapshot.get("id") : "",
        image = (snapshot != null && snapshot.get("image") != null)
            ? snapshot.get("image")
            : "",
        title = (snapshot != null && snapshot.get("title") != null)
            ? snapshot.get("title")
            : "",
        desc = (snapshot != null && snapshot.get("desc") != null)
            ? snapshot.get("desc")
            : "";

  NotificationsDataPost.fromAsyncSnapshot(AsyncSnapshot snapshot, int index)
      : id = (snapshot != null &&
                snapshot.data.documents[index].data["id"] != null)
            ? snapshot.data.documents[index].data["id"]
            : "",
        image = (snapshot != null &&
                snapshot.data.documents[index].data["image"] != null)
            ? snapshot.data.documents[index].data["image"]
            : "",
        title = (snapshot != null &&
                snapshot.data.documents[index].data["title"] != null)
            ? snapshot.data.documents[index].data["title"]
            : "",
        desc = (snapshot != null &&
                snapshot.data.documents[index].data["desc"] != null)
            ? snapshot.data.documents[index].data["desc"]
            : "";

  Map<String, dynamic> toMap() {
    return {"id": id, "image": image, "title": title, "desc": desc};
  }

  toJson() {
    return {"id": id, "image": image, "title": title, "desc": desc};
  }
}
