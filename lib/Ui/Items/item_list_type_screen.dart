import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/Items/edit_item.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../SubItems/sub_items_list_screen.dart';


class ItemTypeScreen extends StatefulWidget {
  final String title;

  ItemTypeScreen({this.title});

  @override
  _ItemTypeScreenState createState() => _ItemTypeScreenState();
}

class _ItemTypeScreenState extends State<ItemTypeScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var snapshot;
  String _textSearch = "";

  @override
  void initState() {
    snapshot = fireStoreMethods.getItems(type: widget.title);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      floatingActionButton: FloatingButton(
        title: widget.title,
      ),
      appBar: AppBar(
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
                  return SingleChildScrollView(child: NOItemFound());
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
                        var item = ItemDetailsModel.fromDocumentSnapshot(
                            snapshot.data.documents[index]);
                        var itemId = item.id;

                        if (_textSearch.isNotEmpty || _textSearch != '') {
                          bool isContains = snapshot
                              .data.documents[index].data['title']
                              .toString()
                              .toLowerCase()
                              .contains(_textSearch);

                          if (isContains) {
                            return Container(
                              child: Slidable(
                                  child: InkWell(
                                    onTap: () {
                                      String title = snapshot
                                          .data.documents[index].data['title'];
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SubItemList(
                                                      title: title,
                                                      itemId: itemId,
                                                      collection:
                                                          widget.title)));
                                    },
                                    child: SmallCartItem(
                                      item: item,
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
                                                builder:
                                                    (BuildContext context) =>
                                                        EditItem(
                                                          itemId: itemId,
                                                          title: widget.title,
                                                        )));
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
                                        fireStoreMethods.deleteSubItem(
                                            context: _scaffoldKey.currentContext,
                                            imageId: item.imageId.elementAt(0),
                                            key: _scaffoldKey,
                                            itemId: itemId);
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
                                child: InkWell(
                                  onTap: () {
                                    String title = snapshot
                                        .data.documents[index].data['title'];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SubItemList(
                                                    title: title,
                                                    itemId: itemId,
                                                    collection: widget.title)));
                                  },
                                  child: SmallCartItem(
                                    item: item,
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
                                                  EditItem(
                                                    itemId: itemId,
                                                    title: widget.title,
                                                  )));
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
                                      fireStoreMethods.deleteSubItem(
                                          context: _scaffoldKey.currentContext,
                                          imageId: item.imageId.elementAt(0),
                                          key: _scaffoldKey,
                                          itemId: itemId);
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
