
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/notification/notification_manager.dart';
import 'package:isouq_admin/Models/user_order-model.dart';
import 'package:isouq_admin/Ui/Items/Banners/banner_list.dart';
import 'package:isouq_admin/Ui/Items/item_list_type_screen.dart';
import 'package:isouq_admin/Ui/MainScreen/Order/order_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'Brand/brand_screen.dart';
import 'Notification/notification_screen.dart';
import 'Offer/offer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//=====


class DrawerNavigation extends StatefulWidget {

  @override
  _DrawerNavigationBarState createState() => _DrawerNavigationBarState();
}

class _DrawerNavigationBarState extends State<DrawerNavigation> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  NotificationManager _notificationManager ;
  var ordersSnapshots;

  _onOrderAdded(DocumentSnapshot documentSnapshot) {
    OrderUserModel _recieved =  OrderUserModel.fromDocumentSnapshot(documentSnapshot);
    _notificationManager.showNotification(_recieved);
  }

  void configureNotification(BuildContext context) {
    _notificationManager = NotificationManager();
    _notificationManager.configure(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    // listenToOrders();
    super.initState();
  }

  // listenToOrders()
  // {
  //   ordersSnapshots = fireStoreMethods.getAllOrders();
  //   ordersSnapshots.listen((result) {
  //     result.documentChanges.forEach((res) {
  //       if (res.type == DocumentChangeType.added) {
  //         _onOrderAdded(res.document);
  //       }
  //     });
  //   });
  // }

  final _drawerHeader = DrawerHeader(
    decoration: BoxDecoration(
      color: Colors.blue,
    ),
    child: CustomText('iSOUQ Admin'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            _drawerHeader,
            DrawerListTile(title: 'Orders',child: OrderListScreen(),icon: Icon(Icons.shopping_cart,)),
            DrawerListTile(title: 'Notifications',child: NotificationScreen(),icon: Icon(Icons.notifications,)),
            DrawerListTile(title: 'Offers',child: OfferScreen(),icon: Icon(Icons.local_offer),),
            DrawerListTile(title: "Brands",child: BrandScreen(),icon: Icon(Icons.branding_watermark),),
            DrawerListTile(title: 'Banners',child: BannersScreen(collection: Statics.banner,),icon: Icon(Icons.image,)),
            DrawerListTile(title: 'Menu',child: ItemTypeScreen(title: Statics.menus),icon: Icon(Icons.menu,)),
            DrawerListTile(title: 'Categories',child: ItemTypeScreen(title: Statics.categories),icon: Icon(Icons.category,)),
            DrawerListTile(title: 'Promotion',child: ItemTypeScreen(title: Statics.promotions),icon: Icon(Icons.local_convenience_store,)),
          ],
        ),
      ),
      body: OrderListScreen(),
    );
  }

  navigateToPage(String title) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ItemTypeScreen(
          title: title,
        )));
  }

}
