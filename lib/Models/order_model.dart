import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class OrderModel {
  String id,
      image,
      title,
      price,
      rating,
      sale,
      size,
      color,
      desc,
      collection,
      quantity,
      cardId,
      status;

  OrderModel(
      {this.id,
      this.image,
      this.title,
      this.price,
      this.rating,
      this.sale,
      this.size,
      this.color,
      this.desc,
      this.collection,
      this.quantity,
      this.cardId,
      this.status});

  OrderModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        desc = (snapshot != null && snapshot.get("desc") != null)
            ? snapshot.get("desc")
            : "",
        title = (snapshot != null && snapshot.get("title") != null)
            ? snapshot.get("title")
            : "",
        price = (snapshot != null && snapshot.get("price") != null)
            ? snapshot.get("price")
            : "",
        rating = (snapshot != null && snapshot.get("rating") != null)
            ? snapshot.get("rating")
            : "",
        sale = (snapshot != null && snapshot.get("sale") != null)
            ? snapshot.get("sale")
            : "",
        color = (snapshot != null && snapshot.get("color") != null)
            ? snapshot.get("color")
            : "",
        quantity = (snapshot != null && snapshot.get("quantity") != null)
            ? snapshot.get("quantity")
            : "",
        collection = (snapshot != null && snapshot.get("collection") != null)
            ? snapshot.get("collection")
            : "",
        size = (snapshot != null && snapshot.get("size") != null)
            ? snapshot.get("size")
            : "",
        cardId = (snapshot != null && snapshot.get("cardId") != null)
            ? snapshot.get("cardId")
            : "",
        status = (snapshot != null && snapshot.get("status") != null)
            ? snapshot.get("status")
            : "",
        image = (snapshot != null && snapshot.get("image") != null)
            ? snapshot.get("image")
            : "";

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        cardId: map['cardId'],
        collection: map['collection'],
        color: map['color'],
        desc: map['desc'],
        id: map['id'],
        sale: map['sale'],
        size: map['size'],
        image: map['image'],
        rating: map['rating'],
        status: map['status'],
        title: map['title'],
        price: map['price'],
        quantity: map['quantity']);
  }

  toJson() {
    return {
      "id": id,
      "image": image,
      "title": title,
      "desc": desc,
      'collection': collection,
      'color': color,
      'cardId': cardId,
      'sale': sale,
      'size': size,
      'rating':rating,
      'status':status,
      'price':price,
      'quantity':quantity,
    };
  }
}
