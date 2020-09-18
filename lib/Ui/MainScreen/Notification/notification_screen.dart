import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Ui/MainScreen/Notification/add_notification.dart';
import 'package:isouq_admin/Ui/MainScreen/Notification/notifications_model.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';


final _scaffoldKey = GlobalKey<ScaffoldState>();
var snapshot;
String _textSearch='';
class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;

  @override
  void initState() {
    snapshot = fireStoreMethods.getNotificationItems(collection: Statics.notifications);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  AddNotification(title: Statics.notifications)));
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
                        var itemId = snapshot.data.documents[index].documentID;
                        var item = NotificationsDataPost.fromAsyncSnapshot(
                            snapshot, index);

                        var keyWord = _textSearch;
                        if (keyWord.isNotEmpty || keyWord != '') {
                          bool isContains = snapshot
                              .data.documents[index].data['title']
                              .toString().toLowerCase()
                              .contains(keyWord);

                          if (isContains) {
                            return Container(
                              child: Slidable(
                                  child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: CustomText(item.title),
                                        ),
                                        ListTile(
                                          title: CustomText('description'),
                                          leading: Container(
                                            height: 100,
                                            margin: EdgeInsets.all(10),
                                            child: CircleAvatar(
                                              backgroundImage:
                                              NetworkImage(item.image),
                                            ),
                                          ),
                                          subtitle: CustomText(item.desc),
                                        ),
                                      ],
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
                                                    AddNotification(
                                                        itemId: itemId,
                                                        title: Statics
                                                            .notifications)));
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
                                        fireStoreMethods.deleteNotificationItem(
                                            context: context,
                                            key: _scaffoldKey,
                                            collection: Statics.notifications,
                                            itemId: itemId);
                                      },
                                    ),
                                  ]),
                            );
                          }else{
                            return SizedBox();
                          }
                        }else{
                          return Container(
                            child: Slidable(
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: CustomText(item.title),
                                      ),
                                      ListTile(
                                        title: CustomText('description'),
                                        leading: Container(
                                          height: 100,
                                          margin: EdgeInsets.all(10),
                                          child: CircleAvatar(
                                            backgroundImage:
                                            NetworkImage(item.image),
                                          ),
                                        ),
                                        subtitle: CustomText(item.desc),
                                      ),
                                    ],
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
                                                  AddNotification(
                                                      itemId: itemId,
                                                      title: Statics
                                                          .notifications)));
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
                                      fireStoreMethods.deleteNotificationItem(
                                          context: context,
                                          key: _scaffoldKey,
                                          collection: Statics.notifications,
                                          itemId: itemId);
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
