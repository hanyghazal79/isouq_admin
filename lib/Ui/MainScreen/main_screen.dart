//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:isouq_admin/Firebase/firestore_method.dart';
//import 'package:isouq_admin/Helper/notification/notification_manager.dart';
//import 'package:isouq_admin/Models/user_order-model.dart';
//import 'package:isouq_admin/Ui/Items/Banners/banner_list.dart';
//import 'package:isouq_admin/Ui/Items/TopRelated/top_rated_screen.dart';
//import 'package:isouq_admin/Ui/Items/item_list_type_screen.dart';
//import 'package:isouq_admin/Ui/widgets.dart';
//import 'package:isouq_admin/Ui/Items/Recommended/recommend_screen.dart';
//import 'package:isouq_admin/statics.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class AllItemsScreen extends StatefulWidget {
//  @override
//  _AllItemsScreenState createState() => _AllItemsScreenState();
//}
//
//class _AllItemsScreenState extends State<AllItemsScreen> {
//  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
//  NotificationManager _notificationManager ;
//  var ordersSnapshots;
//
//  _onOrderAdded(DocumentSnapshot documentSnapshot) {
//    OrderUserModel _recieved =  OrderUserModel.fromDocumentSnapshot(documentSnapshot);
//    _notificationManager.showNotification(_recieved);
//  }
//
//  void configureNotification(BuildContext context) {
//    _notificationManager = NotificationManager();
//    _notificationManager.configure(context);
//  }
//
//  @override
//  void initState() {
//    listenToOrders();
//    super.initState();
//  }
//
//  listenToOrders()
//  {
//    ordersSnapshots = fireStoreMethods.getAllOrders();
//    ordersSnapshots.listen((result) {
//      result.documentChanges.forEach((res) {
//        if (res.type == DocumentChangeType.added) {
//          _onOrderAdded(res.document);
//        }
//      });
//    });
//
////    fireStoreMethods.getAllOrders();
//  }
//
//  navigateToPage(String title) {
//    Navigator.of(context).push(MaterialPageRoute(
//        builder: (BuildContext context) => ItemTypeScreen(
//              title: title,
//            )));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    configureNotification(context);
//
//    return GridView.count(
//      childAspectRatio: 1.5,
//      crossAxisCount: 2,
//      children: <Widget>[
//        InkWell(
//          onTap: () {
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (BuildContext context) => BannersScreen(
//                      collection: Statics.banner,
//                    )));
//          },
//          child: SquareCard(
//            widget: CustomText(Statics.banner),
//            color: Colors.amber,
//          ),
//        ),
//        InkWell(
//          onTap: () {
//            navigateToPage(Statics.menus);
//          },
//          child:
//              SquareCard(widget: CustomText(Statics.menus), color: Colors.red),
//        ),
//        InkWell(
//          onTap: () {
//            navigateToPage(Statics.categories);
//          },
//          child: SquareCard(
//              widget: CustomText(Statics.categories), color: Colors.blue),
//        ),
//        InkWell(
//          onTap: () {
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (BuildContext context) => RecommendedScreen()));
//          },
//          child: SquareCard(
//              widget: CustomText(Statics.recommended),
//              color: Colors.purpleAccent),
//        ),
//        InkWell(
//          onTap: () {
//            navigateToPage(Statics.promotions);
//          },
//          child: SquareCard(
//              widget: CustomText(Statics.promotions), color: Colors.cyan),
//        ),   InkWell(
//          onTap: () {
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (BuildContext context) => TopRelatedScreen()));          },
//          child: SquareCard(
//              widget: CustomText('top rated'), color: Colors.black87),
//        ),
//      ],
//    );
//  }
//}
