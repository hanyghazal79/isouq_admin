import 'package:firebase_core/firebase_core.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Models/user_order-model.dart';
import 'package:isouq_admin/Ui/MainScreen/Order/order_details.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  String itemChoice = Statics.underOrder;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var snap;
  String _textSearch = '';

  @override
  void initState() {
    snap = fireStoreMethods.getAllOrders();
    // TODO: implement initState
    super.initState();
  }

  _itemChoice(String choice) {
    setState(() {
      if (choice == Statics.inWay) {
        itemChoice = Statics.inWay;
      }
      if (choice == Statics.underOrder) {
        itemChoice = Statics.underOrder;
      }
      if (choice == Statics.delivered) {
        itemChoice = Statics.delivered;
      }
    });
  }

  List<String> _popUpItemMenu = [
    Statics.underOrder,
    Statics.inWay,
    Statics.delivered
  ];

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Orders'),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: _itemChoice,
              itemBuilder: (BuildContext context) {
                return _popUpItemMenu.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice, child: Text(choice));
                }).toList();
              }),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFromField(
                maxLine: 1,
                name: 'Search ',
                onChange: (val) {
                  setState(() {
                    _textSearch = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: snap,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length == 0) {
                  return NOItemFound();
                }
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (c, index) {
                          var item = OrderUserModel.fromDocumentSnapshot(
                              snapshot.data.documents[index]);
                          print(" $itemChoice && ${item.status}");

                          if (itemChoice == item.status) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        OrderDetails(item.id)));
                              },
                              child: Container(
                                child: Center(
                                  child: Card(
                                    child: ListTile(
                                      title: Column(
                                        children: [
                                          CustomText("${item.userInformationModel.userName}(${item.userInformationModel.userPhone1}) in ${item.userInformationModel.userLocal}"),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          CustomText('Time :'),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: CustomText(DateFormat(
                                                    'dd MMMM kk:mm')
                                                .format(
                                                    DateTime.parse(item.time))),
                                          ),
                                        ],
                                      ),
                                      trailing: Container(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(item.paid ? 'Paid' : "Unpaid"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              item.status,
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                      leading: Container(
                                        height: 20,
                                        width: 20,
                                        child:
                                            CustomText((index + 1).toString()),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
