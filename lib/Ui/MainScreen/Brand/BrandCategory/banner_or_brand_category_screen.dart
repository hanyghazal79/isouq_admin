import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/MainScreen/Brand/BrandCategory/add_category_brand.dart';
import 'package:isouq_admin/Ui/SubItems/sub_items_list_screen.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class BannerOrBrandCategoryScreen extends StatefulWidget {
  final String title;
  final String bannerOrBrandId;
  final String collection;

  BannerOrBrandCategoryScreen({this.title, this.bannerOrBrandId, this.collection});

  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BannerOrBrandCategoryScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var snapshot;
  String _textSearch = "";

  @override
  void initState() {
    snapshot = fireStoreMethods.getSubItems(
        type: Statics.categories, parentId: widget.bannerOrBrandId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text(widget.title)),
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddBrandCategory(
                    title: widget.title,
                    brandId: widget.bannerOrBrandId,
                    collection: widget.collection,
                  )));
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
                        var categoryId =
                            snapshot.data.documents[index].documentID;
                        var item = ItemDetailsModel.fromDocumentSnapshot(
                            snapshot.data.documents[index]);

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
                                                  SubItemList(
                                                      categoryId: categoryId,
                                                      title: item.title,
                                                      itemId: widget.bannerOrBrandId,
                                                      collection:
                                                          widget.collection)));
                                    },
                                    child: Card(
                                      child: Column(
                                        children: <Widget>[
                                          CustomText(item.title),
                                          ListTile(
                                            title:
                                                CustomText(Statics.description),
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
                                                builder: (BuildContext
                                                        context) =>
                                                    AddBrandCategory(
                                                        categoryId: categoryId,
                                                        brandId: widget.bannerOrBrandId,
                                                        collection:
                                                            widget.collection,
                                                        title: widget.title)));
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
                                        fireStoreMethods.deleteSubItem(
                                            context: _scaffoldKey.currentContext,
                                            key: _scaffoldKey,
                                            imageId: item.imageId.elementAt(0),
                                            itemId: categoryId);
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
                                                SubItemList(
                                                    categoryId: categoryId,
                                                    title: item.title,
                                                    itemId: widget.bannerOrBrandId,
                                                    collection:
                                                        widget.collection)));
                                  },
                                  child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        CustomText(item.title),
                                        ListTile(
                                          title:
                                              CustomText(Statics.description),
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
                                                  AddBrandCategory(
                                                      categoryId: categoryId,
                                                      brandId: widget.bannerOrBrandId,
                                                      collection:
                                                          widget.collection,
                                                      title: widget.title)));
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
                                      fireStoreMethods.deleteSubItem(
                                          context: _scaffoldKey.currentContext,
                                          key: _scaffoldKey,
                                          imageId: item.imageId.elementAt(0),
                                          itemId: categoryId);
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
