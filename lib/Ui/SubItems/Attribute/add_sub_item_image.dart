import 'package:random_string/random_string.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets.dart';


class AddImageToSubItem extends StatefulWidget {
  final String title;
  final String itemId;
  final List image;
  final List imageId;

  AddImageToSubItem({this.title, this.image, this.itemId, this.imageId});

  @override
  _AddImageToSubItemState createState() => _AddImageToSubItemState();
}

class _AddImageToSubItemState extends State<AddImageToSubItem> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  var imageList = List();
  var imageIdList = List();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _getImageFromGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    displayProgressDialog(context);
    var randomImageName = randomAlphaNumeric(40).toString();
    String imageUrl = await fireStoreMethods.saveImageOnFireCloud(
        randomImageName: randomImageName, imageFile: imageFile);
    imageList.add(imageUrl.toString());
    imageIdList.add(randomImageName);

    fireStoreMethods.updateItem(
        itemId: widget.itemId,
        context: context,
        key: _scaffoldKey,
        object: {Statics.image: imageList, 'imageId': imageIdList});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _getImageFromGallery();
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
                  if (item.image.length > 0) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: item.image.length,
                        itemBuilder: (context, index) {
                          imageIdList = item.imageId;
                          imageList = item.image;
                          return Container(
                            child: Slidable(
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color: Colors.white, width: 2.5),
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                item.image.elementAt(index))))),
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete_forever,
                                    onTap: () {
                                      displayProgressDialog(context);

                                      fireStoreMethods.deleteImageFromFireCloud(
                                          randomImageName:
                                              item.imageId.elementAt(index));
                                      item.image.removeAt(index);
                                      item.imageId.removeAt(index);
                                      fireStoreMethods.updateItem(
                                          context: _scaffoldKey.currentContext,
                                          object: {
                                            Statics.image: item.image,
                                            'imageId': item.imageId
                                          },
                                          key: _scaffoldKey,
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
