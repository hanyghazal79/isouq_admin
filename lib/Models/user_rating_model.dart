import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class UserRatingModel {
final  String id, userImage, ratingTime, rating, desc;

  UserRatingModel({
    this.id,
    this.userImage,
    this.ratingTime,
    this.rating,
    this.desc,
  });

  UserRatingModel.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key,
        rating = snapshot.value["rating"],
        ratingTime = snapshot.value["title"],
        desc = snapshot.value["desc"],
        userImage = snapshot.value["image"];

  UserRatingModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        rating = (snapshot != null && snapshot.get("rating") != null)
            ? snapshot.get("rating")
            : "",
        ratingTime = (snapshot != null && snapshot.get("rating_time") != null)
            ? snapshot.get("rating_time")
            : "",
        desc = (snapshot != null && snapshot.get("desc") != null)
            ? snapshot.get("desc")
            : "",
        userImage = (snapshot != null && snapshot.get("user_image") != null)
            ? snapshot.get("user_image")
            : "";



  toJson() {
    return {
      "id": id,
      "rating_time": ratingTime,
      "rating": rating,
      "user_image": userImage,
      "desc": desc
    };
  }
}
