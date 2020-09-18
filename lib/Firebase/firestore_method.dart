
import 'dart:io';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/statics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';


class FireStoreMethods {

  static final FireStoreMethods sharedInstance = FireStoreMethods._internal();

  factory FireStoreMethods() {
    return sharedInstance;
  }

  FireStoreMethods._internal();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User currentFirebaseUser;

  getAllAdmin() {
    return firestore.collection(Statics.admins).snapshots();
  }

  getAllUsers() {
    return firestore.collection(Statics.users).snapshots();
  }

  getAllOrders() {
    return firestore.collection(Statics.orders).snapshots();
  }

  getAllOrdersForUser(String id) {
    return firestore
        .collection(Statics.orders)
        .doc(id)
        .collection(Statics.ordersUser);
  }

  deleteOrder(
      {String itemId, GlobalKey<ScaffoldState> key, BuildContext context}) {
    firestore
        .collection(Statics.orders)
        .doc(itemId)
        .delete()
        .whenComplete(() {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item deleted'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  getOrderById({String itemId}) {
    return firestore.collection(Statics.orders).doc(itemId).snapshots();
  }

  updateOrder(
      {String itemId,
      Object object,
      GlobalKey<ScaffoldState> key,
      BuildContext context}) {
    firestore
        .collection(Statics.orders)
        .doc(itemId)
        .update(object)
        .whenComplete(() {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item updated'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  addItem({Object object, GlobalKey<ScaffoldState> key, BuildContext context}) {
      firestore
        .collection(Statics.items)
        .doc()
        .set(object)
        .whenComplete(() {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item added'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  addItemToStock({Object object, String collection}) {
    firestore
        .collection(Statics.items)
        .doc()
        .set(object);
  }

  deleteCategory(
      {String itemId, GlobalKey<ScaffoldState> key, BuildContext context}) {
    firestore
        .collection(Statics.items)
        .doc(itemId)
        .delete()
        .whenComplete(() {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item deleted'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  addSubItemToStock({String itemId, Object object, String collection}) {
    firestore
        .collection(Statics.items)
        .doc(Statics.item)
        .collection(collection)
        .doc(itemId)
        .collection(Statics.subItems)
        .doc()
        .set(object);
  }

  updateItem(
      {String itemId,
      Object object,
      GlobalKey<ScaffoldState> key,
      BuildContext context}) {
    firestore
        .collection(Statics.items)
        .doc(itemId)
        .update(object)
        .whenComplete(() {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item Update'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  deleteItem(
      {
      GlobalKey<ScaffoldState> key,
      BuildContext context,
      ItemDetailsModel item}) {
    firestore.collection(Statics.items).doc(item.id).delete().then((d) {
      item.imageId.forEach((id) {
        deleteImageFromFireCloud(randomImageName: id);
      });
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item deleted'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  deleteUserRatingItem(
      {String itemId,
      GlobalKey<ScaffoldState> key,
      BuildContext context,
      String userRatingId,
     }) {

    firestore
        .collection(Statics.items)
        .doc(itemId)
        .collection(Statics.usersRating)
        .doc(userRatingId)
        .delete()
        .then((d) {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item deleted'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  getItems({String type}) {
    var itemsSnapShots = firestore
        .collection(Statics.items)
        .where('type', isEqualTo: type)
        .snapshots();
    return itemsSnapShots;
  }

  getNotificationItems({String collection}) {
    var itemsSnapShots = firestore.collection(Statics.notifications).snapshots();
    return itemsSnapShots;
  }

  getSubItems({String parentId, String type}) {
    return firestore
        .collection(Statics.items)
        .where('type', isEqualTo: type)
        .where('parentId', isEqualTo: parentId)
        .snapshots();
  }

  deleteSubItem(
      {String imageId, var context, var key, var itemId}) {
    deleteImageFromFireCloud(randomImageName: imageId);
    firestore.collection(Statics.items).doc(itemId).delete();

    firestore
        .collection(Statics.items)
        .where('type', isEqualTo: Statics.item)
        .where('parentId', isEqualTo: itemId)
        .get()
        .then((documents) {
      documents.docs.forEach((document) {
        firestore
            .collection(Statics.items)
            .doc(document.id)
            .delete();
        var item = ItemDetailsModel.fromDocumentSnapshot(document);
        item.imageId.forEach((image) {
          deleteImageFromFireCloud(randomImageName: image);
        });
      });
    }).then((v) {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item deleted'),
        ),
      );
    });
  }

  deleteBrand({String imageId, var context, var key, var itemId}) {
    deleteImageFromFireCloud(randomImageName: imageId);
    firestore.collection(Statics.items).doc(itemId).delete();
    firestore
        .collection(Statics.items)
        .where('type', isEqualTo: Statics.categories)
        .where('parentId', isEqualTo: itemId)
        .get()
        .then((documents) {
      documents.docs.forEach((document) {
        firestore
            .collection(Statics.items)
            .doc(document.id)
            .delete();
        //delete category
        var item = ItemDetailsModel.fromDocumentSnapshot(document);
        item.imageId.forEach((image) {
          deleteImageFromFireCloud(randomImageName: image);
        });

        //delete items in category
        firestore
            .collection(Statics.items)
            .where('type', isEqualTo: Statics.item)
            .where('parentId', isEqualTo: item.id)
            .get()
            .then((documents) {
          documents.docs.forEach((document) {
            firestore
                .collection(Statics.items)
                .doc(document.id)
                .delete();
            var item = ItemDetailsModel.fromDocumentSnapshot(document);
            item.imageId.forEach((image) {
              deleteImageFromFireCloud(randomImageName: image);
            });
          });
        });
      });
    }).then((v) {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item deleted'),
        ),
      );
    });
  }

  deleteOrderFromUser({String userId, String orderId}) {
    firestore
        .collection(Statics.users)
        .doc(userId)
        .collection(Statics.orders)
        .doc(orderId)
        .delete();
  }

  getItemDetailsById({String itemId}) {
    return firestore.collection(Statics.items).doc(itemId).get();
  }

  getItemDetailsByIdSnapshot({String itemId}) {
    return firestore.collection(Statics.items).doc(itemId).snapshots();
  }

  getUserRatingSnapshot({String itemId}) {
    return firestore
        .collection(Statics.items)
        .doc(itemId)
        .collection(Statics.usersRating)
        .snapshots();
  }

  getItemByName({String collection, String keyWord}) {
    var snap = firestore
        .collection(Statics.items)
        .doc(Statics.item)
        .collection(collection)
        .where(Statics.title, isEqualTo: keyWord)
        .snapshots();

    return snap;
  }

  deleteImageFromFireCloud({String randomImageName}) {
    FirebaseStorage.instance
        .ref()
        .child(Statics.items)
        .child(randomImageName)
        .child(randomImageName)
        .delete();
  }

  saveImageOnFireCloud({File imageFile, String randomImageName}) async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(Statics.items)
        .child(randomImageName)
        .child(randomImageName);

    StorageUploadTask uploadTask = ref.putFile(imageFile);

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  deleteNotificationItem(
      {String itemId,
        String collection,
        GlobalKey<ScaffoldState> key,
        BuildContext context}) async {
    await firestore
        .collection(collection)
        .doc(itemId)
        .delete()
        .whenComplete(() {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item deleted'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }
  getNotificationById({String collection, String itemId}) async {
    var snap;
    await firestore
        .collection(collection)
        .doc(itemId)
        .get()
        .then((snapshots) {
      snap = snapshots;
    });
    return snap;
  }
  saveNotificationImageOnFireCloud({String itemCategory, File imageFile}) async {

    print('start saveImageOnFireCloud  & file url : ${imageFile.uri}');

    var imageName = randomAlphaNumeric(40).toString();

    print('after image name');

    StorageReference ref =
    FirebaseStorage.instance
        .ref()
        .child(Statics.items)
        .child(itemCategory)
        .child(imageName)
        .child(imageName);

    print('after reference');

    StorageUploadTask uploadTask = ref.putFile(imageFile);

    print('after upload and put');


    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  addNotificationItem(
      {Object object,
        String collection,
        GlobalKey<ScaffoldState> key,
        BuildContext context}) async {
    await firestore
        .collection(collection)
        .doc()
        .set(object)
        .whenComplete(() {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item added'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }

  updateNotificationItem(
      {String itemId,
        Object object,
        String collection,
        GlobalKey<ScaffoldState> key,
        BuildContext context}) async {
    await firestore
        .collection(collection)
        .doc(itemId)
        .update(object)
        .whenComplete(() {
      closeProgressDialog(context);
      key.currentState.showSnackBar(
        SnackBar(
          content: Text('Item Update'),
        ),
      );
    }).catchError((error) {
      print(error.toString());
    });
  }



}
