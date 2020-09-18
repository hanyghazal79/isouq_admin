import 'dart:io';

import 'package:random_string/random_string.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';


class AddSubItem extends StatefulWidget {
  final String itemId;
  final String collection;
  final String categoryId;

  AddSubItem({this.collection, this.itemId, this.categoryId});

  @override
  _AddSubItemState createState() => _AddSubItemState();
}

class _AddSubItemState extends State<AddSubItem> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool priceIsEmpty = true;

  var _imageUrl;
  final _titleController = TextEditingController();
  final _normalPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _detailsProductController = TextEditingController();
  final _ratingValueController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _placeController = TextEditingController();
  final _stockController = TextEditingController();
  final _rateStartController = TextEditingController();
  final _sellerController = TextEditingController();
  final _saleController = TextEditingController();
  File imageFile;

  _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Item"),
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
            name: Statics.title,
            textEditingController: _titleController,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            name: Statics.price,
            textEditingController: _normalPriceController,
            inputType: TextInputType.number,
            onChange: (value)
                {
                  if (value.isNotEmpty)
                    priceIsEmpty = false;
                  else
                    priceIsEmpty = true;
                  setState(() {
                    });
                },
          ),
          SizedBox(
            height: 10,
          ),
          priceIsEmpty
              ? SizedBox()
          :TextFromField(
            name: Statics.newPrice,
            textEditingController: _discountPriceController,
            inputType: TextInputType.number,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            name: Statics.place,
            textEditingController: _placeController,
            inputType: TextInputType.text,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            name: Statics.stock,
            textEditingController: _stockController,
            inputType: TextInputType.number,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            name: Statics.ratingStart,
            textEditingController: _rateStartController,
            inputType: TextInputType.number,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            name: Statics.sellerName,
            textEditingController: _sellerController,
            inputType: TextInputType.text,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            textEditingController: _saleController,
            name: Statics.sale,
            inputType: TextInputType.number,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            textEditingController: _descriptionController,
            name: Statics.description,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            textEditingController: _detailsProductController,
            name: Statics.detailsProduct,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: <Widget>[
                  CustomText('ratting'),
                  RatingBar(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _ratingValueController.text = rating.toString();
                    },
                  ),
                ],
              ),
            ),
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

                  if (widget.categoryId == null) {
                    var subItem = ItemDetailsModel(
                      price: _normalPriceController.value.text,
                      time: DateTime.now().toString(),
                      image: imageList,
                      newPrice: _discountPriceController.value.text,
                      place: _placeController.value.text,
                      sellerName: _sellerController.value.text,
                      ratingStart: _ratingValueController.value.text,
                      stock: _stockController.value.text,
                      imageId: imageIdList,
                      type: Statics.item,
                      parentId: widget.itemId,
                      sale: _saleController.value.text,
                      desc: _descriptionController.value.text,
                      productDetails: _detailsProductController.value.text,
                      title: _titleController.value.text,
                      rating: _ratingValueController.value.text,
                    );
                    fireStoreMethods.addItem(
                        context: context,
                        key: _scaffoldKey,
                        object: subItem.toMap());
                  } else {
                    var subItem = ItemDetailsModel(
                      price: _normalPriceController.value.text,
                      time: DateTime.now().toString(),
                      type: Statics.item,
                      parentId: widget.categoryId,
                      image: imageList,
                      newPrice: _discountPriceController.value.text,
                      place: _placeController.value.text,
                      sellerName: _sellerController.value.text,
                      ratingStart: _ratingValueController.value.text,
                      stock: _stockController.value.text,
                      imageId: imageIdList,
                      sale: _saleController.value.text,
                      desc: _descriptionController.value.text,
                      productDetails: _detailsProductController.value.text,
                      title: _titleController.value.text,
                      rating: _ratingValueController.value.text,
                    );

                    fireStoreMethods.addItem(
                        context: context,
                        key: _scaffoldKey,
                        object: subItem.toMap());
                  }
                },
                child: CustomText('Add')),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _saleController.dispose();
    _normalPriceController.dispose();
    _ratingValueController.dispose();
    _titleController.dispose();
    _detailsProductController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
