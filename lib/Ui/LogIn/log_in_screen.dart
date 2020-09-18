import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/app_tools.dart';
import 'package:isouq_admin/Ui/MainScreen/drawer_navigation.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _passwordController = TextEditingController();
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;

  _showAlertDialog(BuildContext context, String name,String password,String subscription) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: CustomText(name.toLowerCase())),
      content: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Color(0xfff5f5f5),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'SFUIDisplay'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      labelStyle: TextStyle(fontSize: 15)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: MaterialButton(
                onPressed: () async {
                  String pass= _passwordController.value.text;
                  String sub = 'true';
                  if (sub == subscription.toLowerCase()) {
                    if(pass==password) {
                      writeBoolDataLocally(key: Statics.logIn, value: true);
                      writeDataLocally(key: Statics.name, value: name);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DrawerNavigation()));
                    }
                    else // password is wrong
                      {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                        Text(' Password is wrong '),
                      ));
                      }
                  } else { // subcription is ended
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content:
                      Text(' Subscription is ended '),
                    ));
                  }
                },
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'SFUIDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Color(0xffff2d55),
                elevation: 0,
                minWidth: 400,
                height: 50,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(child: alert);
      },
    );
  }

  _isLoginBefore() async {
    var islog = await getBoolDataLocally(key: 'login');
    if (islog) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DrawerNavigation()));
    }
  }

  @override
  void initState() {
    _isLoginBefore();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/img/image1.jpg'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                          fontFamily: "Berlin",
                          fontSize: 50.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    child: StreamBuilder(
                        stream: fireStoreMethods.getAllAdmin(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(itemCount: snapshot.data
                                .documents.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (c, i) {
                              String name =snapshot.data.documents[i]
                                  .data[Statics.name];
                              String password =snapshot.data.documents[i]
                                  .data[Statics.password];
                              String subscription =snapshot.data.documents[i]
                                  .data[Statics.subscription];
                                  return InkWell(
                                    onTap: (){
                                      _showAlertDialog(context, name,password,subscription);
                                    },
                                    child: Container(
                                      height: 70,
                                      child: Center(
                                        child: Card(
                                          child: ListTile(
                                            title: CustomText(name),
                                            leading: Container(
                                              margin: EdgeInsets.all(5),
                                              child: CircleAvatar(
                                                radius: 30,
                                                child: Text(
                                                    name[0].toUpperCase()),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
