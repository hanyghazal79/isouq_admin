import 'dart:io';

import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();
var _imageUrl;

class AddNotification extends StatefulWidget {
  final String title;
  final String itemId;

  AddNotification({this.title, this.itemId});

  @override
  _AddNotificationState createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File imageFile;

  _getItemDetails() async {
    var snapshot;

    snapshot = await fireStoreMethods.getNotificationById(
        collection: Statics.notifications, itemId: widget.itemId);


    _titleController.text = snapshot.data[Statics.title];
    _descriptionController.text = snapshot.data[Statics.desc];

    setState(() {
      _imageUrl = snapshot.data[Statics.image].toString();
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
        title: widget.itemId == null ? Text(this.widget.title) : Text('Edit'),
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
            name: Statics.description,
            textEditingController: _descriptionController,
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

                if (imageFile != null) {
                  _imageUrl = await fireStoreMethods.saveNotificationImageOnFireCloud(
                      itemCategory: Statics.notifications,
                      imageFile: imageFile);
                }

                var notificationItem = {
                  Statics.image: _imageUrl,
                  Statics.title: _titleController.value.text,
                  Statics.desc: _descriptionController.value.text
                };
                if (widget.itemId == null) {
                  fireStoreMethods.addNotificationItem(
                      context: context,
                      key: _scaffoldKey,
                      collection: Statics.notifications,
                      object: notificationItem);
                } else {
                  fireStoreMethods.updateNotificationItem(
                      context: context,
                      itemId: widget.itemId,
                      key: _scaffoldKey,
                      collection: Statics.notifications,
                      object: notificationItem);
                }
              },
              child: widget.itemId == null
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
    _descriptionController.dispose();
    _titleController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
