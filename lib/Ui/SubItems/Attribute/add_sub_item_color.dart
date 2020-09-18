import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../widgets.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();
final _colorController = TextEditingController();


class AddColorToSubItem extends StatefulWidget {
  final String title;
  final String itemId;
  final List color;

  AddColorToSubItem(
      {this.title,
      this.color,
      this.itemId,
      });

  @override
  _AddColorToSubItemState createState() => _AddColorToSubItemState();
}

class _AddColorToSubItemState extends State<AddColorToSubItem> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  var list = List();

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
        _addColorToSubItem();
        _colorController.clear();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add color"),
      content: Container(
        height: 80,
        child:
        TextFromField(
          maxLine: 1,
          inputType: TextInputType.text,
          name: 'color',
          textEditingController: _colorController,
        ),
//        Column(
//          children: <Widget>[
//            Container(
//              height: 200,
//              child: MaterialColorPicker(
//                  circleSize: 50,
//                  colors: [
//                    Colors.red,
//                    Colors.deepOrange,
//                    Colors.blue,
//                    Colors.purple,
//                    Colors.blueGrey,
//                    Colors.brown,
//                    Colors.lime,
//                    Colors.indigo,
//                    Colors.cyan,
//                    Colors.green,
//                    Colors.teal,
//                    Colors.pink,
//                    Colors.lightGreen
//                  ],
//                  onColorChange: (Color color) {
//                    String colorText = color.toString();
//                    colorText = colorText.substring(0, colorText.length - 1);
//                    colorText = colorText.substring(6);
//                    _colorController.text = colorText;
//                  },
//                  onMainColorChange: (ColorSwatch color) {
//                    String colorText = color.toString();
//                    colorText = colorText.substring(0, colorText.length - 1);
//                    colorText = colorText.substring(6);
//                    _colorController.text = colorText;
//                  },
//                  selectedColor: Colors.blue),
//            ),
//          ],
//        ),
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

  _addColorToSubItem() {
    Navigator.of(context).pop();
    displayProgressDialog(context);
    list.add(_colorController.text);
      fireStoreMethods.updateItem(
          itemId: widget.itemId,
          context: context,
          key: _scaffoldKey,
          object: {
            'color':list,
          });
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
              stream:fireStoreMethods.getItemDetailsByIdSnapshot(
                      itemId: widget.itemId),
              builder: (context, AsyncSnapshot snapshot) {

                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  var item =
                      ItemDetailsModel.fromDocumentSnapshot(snapshot.data);
                  if (item.color.length > 0) {
                    list=item.color;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: item.color.length,
                        itemBuilder: (context, index) {
                          String color = item.color.elementAt(index);
                          return Container(
                            child: Slidable(
                                child:
                                Container(
                                    margin: EdgeInsets.all(20),
                                    height: 20,
                                    width: MediaQuery.of(context).size.width,
                                    child:
                                    CustomText(color)),
//                                Container(
//                                    margin: EdgeInsets.all(20),
//                                    height: 60,
//                                    width: MediaQuery.of(context).size.width,
//                                    child: Row(
//                                      children: <Widget>[
//                                        CircleColor(
//                                          color: Color(int.parse(color)),
//                                          circleSize: 30,
//                                        ),
//                                        SizedBox(
//                                          width: 20,
//                                        ),
//                                      ],
//                                    )),
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete_forever,
                                    onTap: () {
                                      displayProgressDialog(context);
                                      item.color.removeAt(index);
                                        fireStoreMethods.updateItem(
                                            context: _scaffoldKey.currentContext,
                                            key: _scaffoldKey,
                                            object: {'color': item.color},
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

                } else {
                  return Center(
                    child: CircularProgressIndicator(),
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
