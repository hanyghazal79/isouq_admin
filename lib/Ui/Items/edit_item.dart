import 'dart:io';
import 'package:random_string/random_string.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class EditItem extends StatefulWidget {
  final String title;
  final String itemId;

  EditItem({this.title, this.itemId});

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _imageUrl;
  double initialRating = 0;

  final _titleController = TextEditingController();
  File imageFile;

  _getItemDetails() async {
    var snapshot;
    if (widget.title == Statics.categories) {
      snapshot =
          await fireStoreMethods.getItemDetailsById(itemId: widget.itemId);
    }

    if (widget.title == Statics.promotions) {
      snapshot =
          await fireStoreMethods.getItemDetailsById(itemId: widget.itemId);
    }
    if (widget.title == Statics.menus) {
      snapshot =
          await fireStoreMethods.getItemDetailsById(itemId: widget.itemId);
    }

    _titleController.text = snapshot.data[Statics.title];

    setState(() {
      var list = snapshot.data[Statics.image] as List;

      _imageUrl = list.elementAt(0);
    });
  }

  _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image;
    });
  }

  @override
  void initState() {
    _getItemDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
                onTap: () {
                  _getImageFromGallery();
                },
                child: (_imageUrl != null && imageFile == null)
                    ? Container(
                        margin: EdgeInsets.all(20),
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Colors.white, width: 2.5),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: NetworkImage(_imageUrl))),
                      )
                    : PickImage(
                        imageFile: imageFile,
                      )),
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            textEditingController: _titleController,
            name: Statics.title,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(40),
            width: 30,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                displayProgressDialog(context);
                var randomImageName;
                var imageList = List();
                var imageIdList = List();

                if (imageFile != null) {
                  randomImageName = randomAlphaNumeric(40).toString();
                  _imageUrl = await fireStoreMethods.saveImageOnFireCloud(
                      randomImageName: randomImageName, imageFile: imageFile);
                  imageList.add(_imageUrl.toString());
                  imageIdList.add(randomImageName);
                }
                switch (widget.title) {
                  case 'categories':
                    {
                      var categoryItem = ItemDetailsModel(
                          type: Statics.categories,
                          image: imageList,
                          imageId: imageIdList,
                          time: DateTime.now().toString(),
                          title: _titleController.value.text);

                      fireStoreMethods.updateItem(
                          context: context,
                          key: _scaffoldKey,
                          itemId: widget.itemId,
                          object: categoryItem.toMap());
                    }
                    break;
                  case 'menus':
                    {
                      var menuItem = ItemDetailsModel(
                          type: Statics.menus,
                          image: imageList,
                          imageId: imageIdList,
                          time: DateTime.now().toString(),
                          title: _titleController.value.text);

                      fireStoreMethods.updateItem(
                          context: context,
                          itemId: widget.itemId,
                          key: _scaffoldKey,
                          object: menuItem.toMap());
                    }
                    break;

                  case 'promotions':
                    {
                      var promotionData = ItemDetailsModel(
                          type: Statics.promotions,
                          image: imageList,
                          imageId: imageIdList,
                          time: DateTime.now().toString(),
                          title: _titleController.value.text);

                      fireStoreMethods.updateItem(
                          itemId: widget.itemId,
                          context: context,
                          key: _scaffoldKey,
                          object: promotionData.toMap());
                    }
                    break;
                }
              },
              child: CustomText('Update'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrl = null;
    // TODO: implement dispose
    super.dispose();
  }
}
