import 'package:isouq_admin/Ui/MainScreen/Brand/BrandCategory/banner_or_brand_category_screen.dart';
import 'package:random_string/random_string.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';


class BannersScreen extends StatefulWidget {
  final String collection;

  BannersScreen({this.collection});

  @override
  _BannersScreenState createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _getImageFromGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    displayProgressDialog(context);
    var randomImageName = randomAlphaNumeric(40).toString();
    String imageUrl = await fireStoreMethods.saveImageOnFireCloud(
        randomImageName:randomImageName , imageFile: imageFile);
    var list = List();
    var listId = List();
    list.add(imageUrl);
    listId.add(randomImageName);
    var object = ItemDetailsModel(
            time: DateTime.now().toString(),
        image: list,imageId: listId,
        type: Statics.banner)
        .toMap();
    fireStoreMethods.addItem(
        context: context, key: _scaffoldKey, object: object);
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
        title: Text(this.widget.collection),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: fireStoreMethods.getItems(type: Statics.banner),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length == 0) {
                  return NOItemFound();
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
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var item = ItemDetailsModel.fromDocumentSnapshot(
                            snapshot.data.documents[index]);
                        var itemId = item.id;

                        return Container(
                          child: Slidable(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              BannerOrBrandCategoryScreen(
                                                  title: item.title,
                                                  bannerOrBrandId: itemId,
                                                  collection:
                                                  Statics.banner)));
                                },
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(20)),
                                        border: Border.all(
                                            color: Colors.white, width: 2.5),
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                item.image.elementAt(0))))),
                              ),
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete_forever,
                                  onTap: () {
                                    displayProgressDialog(context);
                                    fireStoreMethods.deleteItem(
                                        context: _scaffoldKey.currentContext,item: item,
                                        key: _scaffoldKey,
                                       );
                                  },
                                ),
                              ]),
                        );
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
