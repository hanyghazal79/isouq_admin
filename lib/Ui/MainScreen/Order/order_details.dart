import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/user_order-model.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';



class OrderDetails extends StatefulWidget {
  final String orderDetailsId;

  OrderDetails(this.orderDetailsId);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireStoreMethods.getOrderById(itemId:widget.orderDetailsId),
      builder: (context, snapshot) {
        var item= OrderUserModel.fromDocumentSnapshot(snapshot.data);
        if(snapshot.hasData){
          double totalItemPrice = 0;
          item.orderListModel.forEach((element) {
            String price = element.price;
            print("price = $price");
//                .substring(0, element.price.length - 2);
            var totalPrice = double.parse(price) * int.parse(element.quantity);
            totalItemPrice += totalPrice;
          });
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(Statics.orders),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        height: 40.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            item.status,
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Sans",
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CustomText('personal Information'),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('userId'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              CustomText(item.userInformationModel.userId),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('name'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                  item.userInformationModel.userName),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('local'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                  item.userInformationModel.userLocal),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
//                        Row(
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text('city'),
//                            ),
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: CustomText(
//                                  item.userInformationModel.userCity),
//                            ),
//                          ],
//                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('phone 1'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                  item.userInformationModel.userPhone1),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
//                        Row(
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text('phone 2'),
//                            ),
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: CustomText(
//                                  item.userInformationModel.userPhone2),
//                            ),
//                          ],
//                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Time'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(DateFormat('dd MMMM kk:mm')
                                  .format(DateTime.parse(item.time))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Cash'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(item.paid ? "Paid" : "Unpaid"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: Colors.black,
                          height: 2,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: item.orderListModel.length,
                            itemBuilder: (context, index) {
                              String price = item.orderListModel.elementAt(index).price;
//                                  .substring(0, item.orderListModel.elementAt(index).price.length - 2);
                              var totalPrice = double.parse(price) *
                                  int.parse(item.orderListModel
                                      .elementAt(index)
                                      .quantity);

                              return Container(
                                child: Slidable(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 13.0, left: 13.0, right: 13.0),

                                    /// Background Constructor for card
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12.withOpacity(0.1),
                                            blurRadius: 3.5,
                                            spreadRadius: 0.4,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.all(10.0),

                                                  /// Image item
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.1),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.black12
                                                                    .withOpacity(0.1),
                                                                blurRadius: 0.5,
                                                                spreadRadius: 0.1)
                                                          ]),
                                                      child: Image.network(
                                                        item.orderListModel
                                                            .elementAt(index)
                                                            .image,
                                                        height: 130.0,
                                                        width: 120.0,
                                                        fit: BoxFit.cover,
                                                      ))),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 25.0,
                                                      left: 10.0,
                                                      right: 5.0),
                                                  child: Column(
                                                    /// Text Information Item
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        item.orderListModel
                                                            .elementAt(index)
                                                            .title,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: "Sans",
                                                          color: Colors.black87,
                                                        ),
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              top: 10.0)),
                                                      Text(
                                                        item.orderListModel
                                                            .elementAt(index)
                                                            .size,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              top: 10.0)),
                                                      Text(item.orderListModel
                                                          .elementAt(index)
                                                          .price),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 18.0, left: 0.0),
                                                        child: Container(
                                                          width: 112.0,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white70,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black12
                                                                      .withOpacity(
                                                                      0.1))),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    18.0),
                                                                child: Text(item
                                                                    .orderListModel
                                                                    .elementAt(index)
                                                                    .quantity),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 8.0)),
                                          Divider(
                                            height: 2.0,
                                            color: Colors.black12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 9.0, left: 10.0, right: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                (item.orderListModel
                                                    .elementAt(index)
                                                    .size !=
                                                    'size')
                                                    ? Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: Text('Size'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: Text(
                                                          item
                                                              .orderListModel
                                                              .elementAt(index)
                                                              .size,
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              fontSize: 15.5,
                                                              fontFamily:
                                                              "Sans")),
                                                    )
                                                  ],
                                                )
                                                    : SizedBox(),
                                                (item.orderListModel
                                                    .elementAt(index)
                                                    .color !=
                                                    'color')
                                                    ? Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: Text('Color'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child:
                                                      Text(
                                                          item
                                                              .orderListModel
                                                              .elementAt(index)
                                                              .color,
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              fontSize: 15.5,
                                                              fontFamily:
                                                              "Sans")),
//                                                      ),
                                                    )
                                                  ],
                                                )
                                                    : SizedBox(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10.0),

                                                  /// Total price of item buy
                                                  child: Text(
                                                    'Total Price :  ' +
                                                        totalPrice.toString() +
                                                        " \$",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15.5,
                                                        fontFamily: "Sans"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 13.0, left: 5.0, right: 5.0),
                                      child: new IconSlideAction(
                                        caption: 'Description',
                                        color: Colors.blue,
                                        icon: Icons.archive,
                                        onTap: () {
                                          ///
                                          /// SnackBar show if cart Archive
                                          ///
                                          Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(item.orderListModel
                                                .elementAt(index)
                                                .desc),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Colors.blue,
                                          ));
                                        },
                                      ),
                                    ),
                                  ],
                                  secondaryActions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 13.0, left: 5.0, right: 5.0),
                                      child: new IconSlideAction(
                                        key: Key(item.id),
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () {
                                          displayProgressDialog(context);
                                          item.orderListModel.removeAt(index);
                                          var map = Map();
                                          item.orderListModel
                                              .forEach((element) {
                                            map.putIfAbsent(
                                                element.title, () => element.toJson());
                                          });
                                          fireStoreMethods.updateOrder(
                                              object: {'products_info': map},
                                              key: _scaffoldKey,
                                              itemId: item.id,
                                              context: _scaffoldKey.currentContext);

                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        Divider(
                          height: 2.0,
                          color: Colors.black12,
                        ),
                        Container(
                          height: 80,
                          padding: const EdgeInsets.only(
                              top: 9.0, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),

                                /// Total price of item buy
                                child: Text(
                                  'Total Items Price :   ' +
                                      totalItemPrice.toString() +
                                      " \$",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.5,
                                      fontFamily: "Sans"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          color: Colors.green,
                          height: 50,
                          margin: EdgeInsets.all(10),
                          child: FlatButton(
                            onPressed: () {
                              fireStoreMethods.updateOrder(
                                  object: {'status': 'delivered'},
                                  key: _scaffoldKey,
                                  itemId: item.id,
                                  context: context);
                            },
                            child: CustomText('delivered'),
                          )),
                      Container(
                          color: Colors.yellow,
                          height: 50,
                          margin: EdgeInsets.all(10),
                          child: FlatButton(
                            onPressed: () {
                              displayProgressDialog(context);
                              fireStoreMethods.updateOrder(
                                  object: {'status': 'in way'},
                                  key: _scaffoldKey,
                                  itemId: item.id,
                                  context: context);
                            },
                            child: CustomText('in way'),
                          )),
                      Container(
                          color: Colors.red,
                          height: 50,
                          margin: EdgeInsets.all(10),
                          child: FlatButton(
                            onPressed: () {
                              displayProgressDialog(context);

                              fireStoreMethods.deleteOrder(
                                  context: _scaffoldKey.currentContext,
                                  key: _scaffoldKey,
                                  itemId: item.id);
                            },
                            child: CustomText('cancel'),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
       
      }
    );
  }
}
