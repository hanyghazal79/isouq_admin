import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/MainScreen/Offer/add_offer.dart';
import 'package:isouq_admin/Ui/MainScreen/Store/store_list.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class OfferScreen extends StatefulWidget {
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _textSearch = '';



  _itemChoice(String choice) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => StoreScreen(
              collection: Statics.offers,
              title: Statics.offers,
            )));
  }

  List<String> _popUpItemMenu = [
    Statics.stock,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers'),
        actions: [
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
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AddOffer()));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextFromField(
              maxLine: 1,
              name: 'Search ',
              onChange: (val) {
                setState(() {
                  _textSearch = val;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream:fireStoreMethods.getSubItems(parentId: Statics.offers,type: Statics.item),
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
                      itemBuilder: (context, index) {

                        var item =
                            ItemDetailsModel.fromDocumentSnapshot(snapshot.data.documents[index]);
                        var keyWord = _textSearch;
                        var itemId = item.id;
                        if (keyWord.isNotEmpty || keyWord != '') {
                          bool isContains = item.title
                              .toLowerCase()
                              .contains(keyWord);

                          if (isContains) {
                            return Container(
                              child: Slidable(
                                  child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        CustomText(item.title),
                                        ListTile(
                                          title: CustomText(item.place),
                                          leading: Container(
                                            height: 100,
                                            margin: EdgeInsets.all(5),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(item.image.elementAt(0)),
                                            ),
                                          ),
                                          subtitle: CustomText(item.stock),
                                          trailing: Container(
                                            width: 90,
                                            child: Column(
                                              children: <Widget>[
                                                CustomText(item.newPrice),
                                                Text(
                                                  item.price,
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 15.0,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  actions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Edit',
                                      color: Colors.blue,
                                      icon: Icons.edit,
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    AddOffer(item: item)));
                                      },
                                    ),
                                  ],
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete_forever,
                                      onTap: () {
                                        displayProgressDialog(context);
                                        fireStoreMethods.deleteItem(
                                            context: _scaffoldKey.currentContext,item: item,
                                            key: _scaffoldKey,
                                            );
                                      },
                                    ),
                                  ]),
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return Container(
                            child: Slidable(
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      CustomText(item.title),
                                      ListTile(
                                        title: CustomText(item.place),
                                        leading: Container(
                                          height: 100,
                                          margin: EdgeInsets.all(5),
                                          child: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(item.image.elementAt(0)),
                                          ),
                                        ),
                                        subtitle: CustomText(item.stock),
                                        trailing: Container(
                                          width: 90,
                                          child: Column(
                                            children: <Widget>[
                                              CustomText(item.newPrice),
                                              Text(
                                                item.price,
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 15.0,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                actions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Edit',
                                    color: Colors.blue,
                                    icon: Icons.edit,
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddOffer(item: item)));
                                    },
                                  ),
                                ],
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete_forever,
                                    onTap: () {
                                      displayProgressDialog(context);
                                      fireStoreMethods.deleteItem(
                                          context: _scaffoldKey.currentContext,item: item,
                                          key: _scaffoldKey,
                                         );
                                    },
                                  ),
                                ]),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
