
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isouq_admin/Helper/notification/NotificationModel.dart';
import 'package:isouq_admin/Models/user_order-model.dart';
import 'package:isouq_admin/Ui/MainScreen/Order/order_details.dart';
import 'package:rxdart/subjects.dart';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
  static final BehaviorSubject<OrderUserModel> didReceiveLocalNotificationSubject =
  BehaviorSubject<OrderUserModel>();

  static final BehaviorSubject<String> selectNotificationSubject =
  BehaviorSubject<String>();

  static NotificationAppLaunchDetails notificationAppLaunchDetails;
  static final NotificationManager _sharedInstance =
  NotificationManager._internal();


  factory NotificationManager() {
    return _sharedInstance;
  }

  NotificationManager._internal();

  /// IMPORTANT: running the following code on its own won't work as there is setup required for each platform head project.
  /// Please download the complete example app from the GitHub repository where all the setup has been done
  Future<void> initilaize () async {
    // needed if you intend to initialize in the `main` function
    WidgetsFlutterBinding.ensureInitialized();

    notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int _id, String _title, String _body, String payload) async {
          didReceiveLocalNotificationSubject.add(OrderUserModel(id: _id.toString()));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('notification payload: ' + payload);
          }
          selectNotificationSubject.add(payload);
        });
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void configureDidReceiveLocalNotificationSubject(BuildContext context) {
    didReceiveLocalNotificationSubject.stream
        .listen((OrderUserModel receivedNotification) async {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new OrderDetails(receivedNotification.id)));
    });
  }

  void configureSelectNotificationSubject(BuildContext context) {
    selectNotificationSubject.stream.listen((String payload) async {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new OrderDetails(payload)));
    });
  }

  Future<void> showNotification(OrderUserModel _recievedNotification) async {
    String paidStatus = _recievedNotification.paid ? "Paid" : "Unpaid";
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker',playSound: true,);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, "$paidStatus Order", "${_recievedNotification.userInformationModel.userName} in ${_recievedNotification.userInformationModel.userLocal}", platformChannelSpecifics,
        payload: 'item x');
  }

  void configure(BuildContext context) {
    requestIOSPermissions();
    configureDidReceiveLocalNotificationSubject(context);
    configureSelectNotificationSubject(context);
  }
}

