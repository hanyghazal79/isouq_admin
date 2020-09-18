import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/MainScreen/Brand/BrandCategory/banner_or_brand_category_screen.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'add_brand_item.dart';



class BrandScreen extends StatefulWidget {
  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var snapshot;
  String _textSearch = "";

  @override
  void initState() {
    snapshot = fireStoreMethods.getItems(type: Statics.brands);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Brands')),
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  AddBrand(title: Statics.brands)));
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFromField(
                maxLine: 1,
                name: 'Search ',
                onChange: (val) {
                  setState(() {
                    _textSearch = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: snapshot,
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
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var item = ItemDetailsModel.fromDocumentSnapshot(
                            snapshot.data.documents[index]);
                        var itemId = item.id;

                        var keyWord = _textSearch;
                        if (keyWord.isNotEmpty || keyWord != '') {
                          bool isContains = snapshot
                              .data.documents[index].data['title']
                              .toString()
                              .toLowerCase()
                              .contains(keyWord);

                          if (isContains) {
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
                                                          Statics.brands)));
                                    },
                                    child: Card(
                                      child: Column(
                                        children: <Widget>[
                                          CustomText(item.title),
                                          ListTile(
                                            title: CustomText('description'),
                                            leading: Container(
                                              height: 100,
                                              margin: EdgeInsets.all(5),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    item.image.elementAt(0)),
                                              ),
                                            ),
                                            subtitle: CustomText(item.desc),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  actions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Edit',
                                      color: Colors.blue,
                                      icon: Icons.edit,
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        AddBrand(
                                                            itemId: itemId,
                                                            title: Statics
                                                                .brands)));
                                      },
                                    ),
                                  ],
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete_forever,
                                      onTap: () {
                                        displayProgressDialog(context);
                                        fireStoreMethods.deleteBrand(
                                            context: _scaffoldKey.currentContext,itemId: itemId,
                                            key: _scaffoldKey,
                                            imageId: item.imageId.elementAt(0));
                                      },
                                    ),
                                  ]),
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
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
                                                        Statics.brands)));
                                  },
                                  child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        CustomText(item.title),
                                        ListTile(
                                          title: CustomText('description'),
                                          leading: Container(
                                            height: 100,
                                            margin: EdgeInsets.all(5),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  item.image.elementAt(0)),
                                            ),
                                          ),
                                          subtitle: CustomText(item.desc),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                actions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Edit',
                                    color: Colors.blue,
                                    icon: Icons.edit,
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddBrand(
                                                      itemId: itemId,
                                                      title: Statics.brands)));
                                    },
                                  ),
                                ],
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete_forever,
                                    onTap: () {
                                      displayProgressDialog(context);
                                      fireStoreMethods.deleteBrand(
                                          context: _scaffoldKey.currentContext,itemId: itemId,
                                          key: _scaffoldKey,
                                          imageId: item.imageId.elementAt(0));
                                    },
                                  ),
                                ]),
                          );
                        }
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
