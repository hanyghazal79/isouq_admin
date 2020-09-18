import 'dart:io';

import 'package:random_string/random_string.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/SubItems/Attribute/add_sub_item_color.dart';
import 'package:isouq_admin/Ui/SubItems/Attribute/add_sub_item_image.dart';
import 'package:isouq_admin/Ui/SubItems/Attribute/add_sub_item_size.dart';
import 'package:isouq_admin/Ui/SubItems/Attribute/sub_item_user_rating.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';



class AddOffer extends StatefulWidget {
  final ItemDetailsModel item;

  AddOffer({this.item});

  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  var _imageUrl;
  double initialRating = 0;
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

  _getItemDetails() async {
    _titleController.text = widget.item.title;
    _normalPriceController.text = widget.item.price;
    _detailsProductController.text = widget.item.productDetails;
    _sellerController.text = widget.item.sellerName;
    initialRating = double.parse(widget.item.rating);
    _ratingValueController.text = widget.item.ratingStart;
    _descriptionController.text = widget.item.desc;
    _rateStartController.text = widget.item.ratingStart;
    _stockController.text = widget.item.stock;
    _placeController.text = widget.item.place;
    _discountPriceController.text = widget.item.newPrice;
  }

  @override
  void initState() {
    if (widget.item != null) {
      _getItemDetails();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: widget.item == null ? Text(Statics.offers) : Text('Edit'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          widget.item != null
              ? Container(
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    childAspectRatio: 1.5,
                    crossAxisCount: 2,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddSizeToSubItem(
                                    title: Statics.sizes,
                                    itemId: widget.item.id,
                                  )));
                        },
                        child: SquareCard(
                            widget: CustomText(Statics.sizes),
                            color: Colors.red),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddColorToSubItem(
                                    title: Statics.colors,
                                    itemId: widget.item.id,
                                  )));
                        },
                        child: SquareCard(
                            widget: CustomText(Statics.colors),
                            color: Colors.yellow),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddImageToSubItem(
                                    title: Statics.images,
                                    itemId: widget.item.id,
                                  )));
                        },
                        child: SquareCard(
                            widget: CustomText(Statics.images),
                            color: Colors.purpleAccent),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SubItemUserRate(
                                    title: Statics.usersRating,
                                    itemId: widget.item.id,
                                  )));
                        },
                        child: SquareCard(
                            widget: CustomText('users rating'),
                            color: Colors.cyan),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          widget.item != null
              ? SizedBox()
              : Center(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.white, width: 2.5),
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
            name: Statics.place,
            textEditingController: _placeController,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            inputType: TextInputType.number,
            name: Statics.stock,
            textEditingController: _stockController,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            name: Statics.normalPrice,
            textEditingController: _normalPriceController,
            inputType: TextInputType.number,
          ),
          SizedBox(
            height: 10,
          ),
          TextFromField(
            name: Statics.discountPrice,
            textEditingController: _discountPriceController,
            inputType: TextInputType.number,
          ),
          SizedBox(
            height: 10,
          ),  TextFromField(
            name: Statics.sale,
            textEditingController: _saleController,
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
            inputType: TextInputType.number,
            textEditingController: _rateStartController,
            name: 'rating count',
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
                    initialRating: initialRating,
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

                if (widget.item == null) {
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
                  var offerData = ItemDetailsModel(
                          desc: _descriptionController.value.text,
                          productDetails: _detailsProductController.value.text,
                          price: _normalPriceController.value.text,
                          newPrice: _discountPriceController.value.text,
                          time: DateTime.now().toString(),
                          title: _titleController.value.text,
                          place: _placeController.value.text,
                          type: Statics.item,
                          parentId: Statics.offers,
                          stock: _stockController.value.text,
                          ratingStart: _rateStartController.value.text,
                          rating: _ratingValueController.value.text,
                          image: imageList,sale: _saleController.value.text,
                          imageId: imageIdList,
                          sellerName: _sellerController.value.text)
                      .toMap();

                  fireStoreMethods.addItem(
                      context: context, key: _scaffoldKey, object: offerData);
                } else {
                  var offerData = {
                    "desc": _descriptionController.value.text,
                    "sale": _saleController.value.text,
                    "productDetails": _detailsProductController.value.text,
                    "price": _normalPriceController.value.text,
                    "newPrice": _discountPriceController.value.text,
                    "title": _titleController.value.text,
                    "place": _placeController.value.text,
                    "stock": _stockController.value.text,
                    "ratingStart": _rateStartController.value.text,
                    "rating": _ratingValueController.value.text,
                    "sellerName": _sellerController.value.text
                  };
                  fireStoreMethods.updateItem(
                      context: context,
                      itemId: widget.item.id,
                      key: _scaffoldKey,
                      object: offerData);
                }
              },
              child: widget.item == null
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
    _ratingValueController.dispose();
    _titleController.dispose();
    _normalPriceController.dispose();
    _detailsProductController.dispose();
    _discountPriceController.dispose();
    _placeController.dispose();
    _stockController.dispose();
    _sellerController.dispose();
    _rateStartController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
