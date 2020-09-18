import 'dart:io';

import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/SubItems/Attribute/add_sub_item_color.dart';
import 'package:isouq_admin/Ui/SubItems/Attribute/add_sub_item_size.dart';
import 'package:isouq_admin/Ui/SubItems/Attribute/sub_item_user_rating.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Attribute/add_sub_item_image.dart';

class EditSubItem extends StatefulWidget {
  final ItemDetailsModel item;

  EditSubItem({this.item});

  @override
  _EditSubItemState createState() => _EditSubItemState();
}

class _EditSubItemState extends State<EditSubItem> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool priceIsEmpty = true;


  double initialRating = 0;
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingValueController = TextEditingController();
  final _saleController = TextEditingController();
  File imageFile;
  final _detailsProductController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _placeController = TextEditingController();
  final _stockController = TextEditingController();
  final _rateStartController = TextEditingController();
  final _sellerController = TextEditingController();

  _getItemDetails() {
    _descriptionController.text = widget.item.desc;
    _titleController.text = widget.item.title;
    initialRating =
        widget.item.rating.isEmpty ? 0 : double.parse(widget.item.rating);
    _ratingValueController.text = widget.item.rating;
    _priceController.text = widget.item.price;
    _saleController.text = widget.item.sale;
    if(widget.item.price.isEmpty)
      priceIsEmpty = true;
    else
      priceIsEmpty = false;
  }

  @override
  void initState() {
    _getItemDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Item"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: GridView.count(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      childAspectRatio: 1.5,
                      crossAxisCount: 2,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return AddSizeToSubItem(
                                size: widget.item.size,
                                title: Statics.sizes,
                                itemId: widget.item.id,
                              );
                            }));
                          },
                          child: SquareCard(
                              widget: CustomText(Statics.sizes),
                              color: Colors.red),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return AddColorToSubItem(
                                color: widget.item.color,
                                title: Statics.colors,
                                itemId: widget.item.id,
                              );
                            }));
                          },
                          child: SquareCard(
                              widget: CustomText(Statics.colors),
                              color: Colors.yellow),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return AddImageToSubItem(
                                title: Statics.images,
                                image: widget.item.image,
                                itemId: widget.item.id,
                              );
                            }));
                          },
                          child: SquareCard(
                              widget: CustomText(Statics.images),
                              color: Colors.purpleAccent),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return SubItemUserRate(
                                title: Statics.usersRating,
                                itemId: widget.item.id,
                              );
                            }));
                          },
                          child: SquareCard(
                              widget: CustomText('users rating'),
                              color: Colors.cyan),
                        ),
                      ],
                    ),
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
                    textEditingController: _priceController,
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

                          var subItem = {
                            "sellerName": _sellerController.value.text,
                            "desc": _descriptionController.value.text,
                            "sale": _saleController.value.text,
                            "productDetails":
                                _detailsProductController.value.text,
                            "price": _priceController.value.text,
                            "newPrice": _discountPriceController.value.text,
                            "title": _titleController.value.text,
                            "place": _placeController.value.text,
                            "stock": _stockController.value.text,
                            "ratingStart": _rateStartController.value.text,
                            "rating": _ratingValueController.value.text,
                          };
                          fireStoreMethods.updateItem(
                              context: context,
                              key: _scaffoldKey,
                              itemId: widget.item.id,
                              object: subItem);
                        },
                        child: CustomText('Edit')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _saleController.dispose();
    _priceController.dispose();
    _ratingValueController.dispose();
    _titleController.dispose();
    _sellerController.dispose();
    _detailsProductController.dispose();
    _discountPriceController.dispose();
    _stockController.dispose();
    _placeController.dispose();
    _rateStartController.dispose();
    super.dispose();
  }
}
