import 'dart:io';

import 'package:random_string/random_string.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddBrandCategory extends StatefulWidget {
  
  final String title, brandId, categoryId, collection;

  AddBrandCategory({this.title, this.brandId, this.categoryId, this.collection});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddBrandCategory> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _imageUrl;

  double initialRating = 0;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File imageFile;

  _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image;
    });
  }

  _getItemDetails() async {
    var snapshot;

    snapshot = await fireStoreMethods.getItemDetailsById(

        itemId: widget.brandId);

    _titleController.text = snapshot.data[Statics.title];
    _descController.text = snapshot.data[Statics.desc];

    setState(() {
      _imageUrl = snapshot.data[Statics.image].toString();
    });
  }

  @override
  void initState() {
    if (widget.categoryId != null) {
      _getItemDetails();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
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
            height: 10,
          ),
          TextFromField(
            textEditingController: _descController,
            name: Statics.description,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(40),
            width: 30,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                displayProgressDialog(context);
                var randomImageName;

                if (imageFile != null) {
                  randomImageName = randomAlphaNumeric(40).toString();
                  _imageUrl = await fireStoreMethods.saveImageOnFireCloud(
                      randomImageName: randomImageName,
                      imageFile: imageFile);
                }

                var imageList = List();
                imageList.add(_imageUrl.toString());

                var imageIdList = List();
                imageIdList.add(randomImageName);

                var categoryItem = ItemDetailsModel(
                    image: imageList,
                    imageId: imageIdList,parentId: widget.brandId,
                    title: _titleController.value.text,
                    desc: _descController.value.text,
                    type: Statics.categories);

                if (widget.categoryId == null) {
                  fireStoreMethods.addItem(
                      context: context,
                      key: _scaffoldKey,
                      object: categoryItem.toMap());
                } else {
                  fireStoreMethods.updateItem(
                      itemId: widget.brandId,
                      context: context,
                      key: _scaffoldKey,
                      object: categoryItem.toMap());
                }
              },
              child: widget.categoryId == null
                  ? CustomText('Add')
                  : CustomText('Update'),
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
