import 'package:isouq_admin/Models/order_model.dart';
import 'package:isouq_admin/Models/user_information_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderUserModel {
  String id, status, time;
  List<OrderModel> orderListModel;
  UserInformationModel userInformationModel;
  bool paid;

  OrderUserModel({this.id});


  OrderUserModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.id != null) ? snapshot.id : "",
        paid = (snapshot != null && snapshot.get("paid") != null)
            ? snapshot.get("paid")
            : false,
        status = (snapshot != null && snapshot.get("status") != null)
            ? snapshot.get("status")
            : "",
        time = (snapshot != null && snapshot.get("time") != null)
            ? snapshot.get("time")
            : "",
        orderListModel =
            (snapshot != null && snapshot.get("products_info") != null)
                ? (snapshot.get("products_info") as Map)
                    .values
                    .map((e) => OrderModel.fromMap(e))
                    .toList()
                : List(),
        userInformationModel =
            (snapshot != null && snapshot.get("user_information") != null)
                ? UserInformationModel.fromMap(snapshot.get("user_information"))
                : UserInformationModel();
}
