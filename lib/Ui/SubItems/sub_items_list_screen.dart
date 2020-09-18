import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/MainScreen/Store/store_list.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'add_sub_items_screen.dart';
import 'edit_sub_items.dart';

class SubItemList extends StatefulWidget {
  final String title;
  final String itemId;
  final String categoryId;
  final String collection;

  SubItemList({this.title, this.itemId, this.collection, this.categoryId});

  @override
  _SubItemListScreenState createState() => _SubItemListScreenState();
}

class _SubItemListScreenState extends State<SubItemList> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var snapshot;
  String _textSearch = "";

  @override
  void initState() {
    if (widget.categoryId == null) {
      snapshot = fireStoreMethods.getSubItems(
          type: Statics.item, parentId: widget.itemId);
    } else {
      snapshot = fireStoreMethods.getSubItems(
          type: Statics.item, parentId: widget.categoryId);
    }

    // TODO: implement initState
    super.initState();
  }

  _itemChoice(String choice) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => StoreScreen(
            title: widget.title,
            categoryId: widget.categoryId,
            collection: widget.collection,
            itemId: widget.itemId)));
  }

  List<String> _popUpItemMenu = [
    Statics.stock,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddSubItem(
                    categoryId: widget.categoryId,
                    collection: widget.collection,
                    itemId: widget.itemId,
                  )));
        },
      ),
      appBar: AppBar(
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
        title: Text(this.widget.title),
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
              stream: snapshot,
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
                        var subItem = ItemDetailsModel.fromDocumentSnapshot(
                            snapshot.data.documents[index]);
                        if (_textSearch.isNotEmpty || _textSearch != '') {
                          bool isContains =
                              subItem.title.toLowerCase().contains(_textSearch);

                          if (isContains) {
                            return Container(
                              child: Slidable(
                                  child: CardItem(
                                    item: subItem,
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
                                                builder:
                                                    (BuildContext context) =>
                                                        EditSubItem(
                                                            item: subItem)));
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
                                            context: _scaffoldKey.currentContext,
                                            key: _scaffoldKey,
                                            item: subItem
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
                                child: CardItem(
                                  item: subItem,
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
                                                  EditSubItem(item: subItem)));
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
                                          context: _scaffoldKey.currentContext,
                                          key: _scaffoldKey,
                                          item: subItem
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
            ),
          ],
        ),
      ),
    );
  }
}
