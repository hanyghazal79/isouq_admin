import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widgets.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();
final _sizeController = TextEditingController();


class AddSizeToSubItem extends StatefulWidget {
  final String title;
  final String itemId;
  final List size;

  AddSizeToSubItem({this.title, this.itemId, this.size});

  @override
  _AddSizeToSubItemState createState() => _AddSizeToSubItemState();
}

class _AddSizeToSubItemState extends State<AddSizeToSubItem> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  var list=List();

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Add"),
      onPressed: () {
        _addSizeToSubItem();
        _sizeController.clear();
        Navigator.of(context).pop();
      },
    );
    print(widget.itemId);
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add Size"),
      content: Container(
        height: 80,
        child: TextFromField(
          maxLine: 1,
          inputType: TextInputType.text,
          name: 'size',
          textEditingController: _sizeController,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(child: alert);
      },
    );
  }

  _addSizeToSubItem() async {
    displayProgressDialog(context);
    list.add(_sizeController.text);
    fireStoreMethods.updateItem(
        itemId: widget.itemId,
        context: context,
        key: _scaffoldKey,
        object: {'size': list});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAlertDialog(context);
        },
      ),
      appBar: AppBar(
        title: Text(this.widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: fireStoreMethods.getItemDetailsByIdSnapshot(
                  itemId: widget.itemId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var item =
                      ItemDetailsModel.fromDocumentSnapshot(snapshot.data);
                  if (item.size.length > 0) {
                    list=item.size;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: item.size.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Slidable(
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    height: 20,
                                    width: MediaQuery.of(context).size.width,
                                    child:
                                        CustomText(item.size.elementAt(index))),
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete_forever,
                                    onTap: () {
                                      displayProgressDialog(context);
                                      item.size.removeAt(index);
                                      fireStoreMethods.updateItem(
                                          context: _scaffoldKey.currentContext,
                                          key: _scaffoldKey,
                                          object: {'size': item.size},
                                          itemId: widget.itemId);
                                    },
                                  ),
                                ]),
                          );
                        },
                      ),
                    );
                  } else {
                    return NOItemFound();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
