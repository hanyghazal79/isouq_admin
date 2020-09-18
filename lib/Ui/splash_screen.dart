

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isouq_admin/Helper/app_tools.dart';
import 'package:isouq_admin/Ui/MainScreen/drawer_navigation.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/img/image1.jpg',height: 300,width: 300,)),
          ],
        ),
      ),
    );
  }

  _isLogin()  {
    getBoolDataLocally(key: "isLogin").then((value) {
      if(value){
        _startSplashScreenTimer(_navigateToHomeScreen);

      }else{
        _startSplashScreenTimer(_navigateToLoginScreen);
      }
    });
  }

  _navigateToLoginScreen() {

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                DrawerNavigation()));
  }

  _navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                DrawerNavigation()));
  }

  _startSplashScreenTimer(Function function) {
    final duration = Duration(seconds: 2);
    Timer(duration, function);
  }

  @override
  void initState() {
    _isLogin();
    super.initState();

  }
}
