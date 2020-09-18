import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'Items/add_Item.dart';

class FloatingButton extends StatelessWidget {
  final String title;

  FloatingButton({this.title});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AddItem(
                  title: title,
                )));
      },
      child: Icon(Icons.add),
    );
  }
}

class TextFromField extends StatelessWidget {
  final String name;
  final int maxLine;
  final FocusNode focusNode;
  final TextInputType inputType;
  final TextEditingController textEditingController;
  final Function onChange;

  TextFromField(
      {this.name,
      this.inputType,
      this.textEditingController,
      this.focusNode,
      this.maxLine,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.blue.shade100,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
            EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: TextFormField(
            onChanged: onChange,
            maxLines: maxLine,
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: name,
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}

class SquareCard extends StatelessWidget {
  final double height, width;
  final Widget widget;
  final Color color;

  SquareCard({this.widget, this.color, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: color,
        height: height,
        width: width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 1.0,
          child: Center(child: widget),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;

  CustomText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Berlin",
          fontSize: 20.0,
          color: Colors.black54,
          fontWeight: FontWeight.w700),
    );
  }
}

class PickImage extends StatefulWidget {
  final File imageFile;

  PickImage({this.imageFile});

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Icon(Icons.add),
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.white, width: 2.5),
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: (this.widget.imageFile == null)
                  ? AssetImage("assets/img/add.png")
                  : FileImage(this.widget.imageFile))),
    );
  }
}

class CardItem extends StatelessWidget {
  final ItemDetailsModel item;

  CardItem({this.item});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          CustomText(item.title),
          ListTile(
            title: CustomText('price   ' + item.price),
            leading: Container(
              height: 100,
              margin: EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundImage: item.image.length != 0 ? NetworkImage(item.image.elementAt(0)) : AssetImage('assets/img/image1.jpg'),
              ),
            ),
            subtitle: CustomText("rate " + item.rating),
            trailing: Container(
              width: 90,
              child: Column(
                children: <Widget>[Expanded(child: CustomText(item.sale))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallCartItem extends StatelessWidget {
  final ItemDetailsModel item;

  SmallCartItem({this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Center(
        child: Card(
          child: ListTile(
            title: CustomText(item.title),
            leading: Container(
              margin: EdgeInsets.all(5),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(item.image.elementAt(0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final Widget child;
  final Icon icon;

  DrawerListTile({this.title, this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: CustomText(title),
        leading: icon,
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => child));
        },
      ),
    );
  }
}

class NOItemFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.white, width: 2.5),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage('assets/img/noItem.png')))),
          CustomText("No Item Found")
        ],
      ),
    );
  }
}
