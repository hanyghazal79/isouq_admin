import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:isouq_admin/Models/user_rating_model.dart';

import '../../widgets.dart';



class SubItemUserRate extends StatefulWidget {
  final String title;
  final String itemId;

  SubItemUserRate({
    this.title,
    this.itemId,
  });

  @override
  _SubItemUserRateState createState() => _SubItemUserRateState();
}

class _SubItemUserRateState extends State<SubItemUserRate> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(this.widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream:
                  fireStoreMethods.getUserRatingSnapshot(itemId: widget.itemId),
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
                        var item = UserRatingModel.fromDocumentSnapshot(
                            snapshot.data.document[index]);
                        return Container(
                          child: Slidable(
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    CustomText(item.rating),
                                    ListTile(
                                      title: CustomText(item.rating),
                                      leading: Container(
                                        height: 100,
                                        margin: EdgeInsets.all(5),
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(item.userImage),
                                        ),
                                      ),
                                      subtitle:
                                          CustomText("rate " + item.rating),
                                      trailing: Container(
                                        width: 90,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                                child:
                                                    CustomText(item.ratingTime))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                    fireStoreMethods.deleteUserRatingItem(
                                        context: _scaffoldKey.currentContext,
                                        userRatingId: item.id,
                                        key: _scaffoldKey,
                                        itemId: widget.itemId);
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
