import 'dart:io';

import 'package:isouq_admin/Firebase/firestore_method.dart';
import 'package:isouq_admin/Helper/progress_dialog.dart';
import 'package:isouq_admin/Models/item_details_model.dart';
import 'package:isouq_admin/Ui/widgets.dart';
import 'package:isouq_admin/statics.dart';
import 'package:excel/excel.dart' as ex;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



class StoreScreen extends StatefulWidget {
  final String collection;
  final String title;
  final String itemId;
  final String categoryId;

  StoreScreen({this.collection, this.title, this.itemId, this.categoryId});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods.sharedInstance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _textSearch = '';
  File file;
  List excelListItem = List();
  int _rowPerPage = PaginatedDataTable.defaultRowsPerPage;
  var snapshot;

  _itemChoice(String choice) {
    setState(() async{
      if (choice == Statics.uploadFile) {
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx'])
            .then((value) {
          file = value.files.single.path as File;
          if (file != null) {
            var bytes = file.readAsBytesSync();
            var excel = ex.Excel.decodeBytes(bytes);

            for (var table in excel.tables.keys) {
              print(table); //sheet Name
              print(excel.tables[table].maxCols);
              print(excel.tables[table].maxRows);
              for (var row in excel.tables[table].rows) {

                var item = ItemDetailsModel(
                    type: Statics.item,
                    parentId: widget.itemId == null ? widget.collection :(widget.categoryId == null ? widget.itemId : widget.categoryId),
                    title: row.elementAt(0).toString(),
                    sale: row.elementAt(1).toString(),
                    price: row.elementAt(2).toString(),
                    rating: row.elementAt(3).toString(),
                    stock: row.elementAt(4).toString(),
                    size: row.elementAt(5).toString().split('-'),
                    color: row.elementAt(6).toString().split('-'),
                    desc: row.elementAt(7).toString(),
                    productDetails: row.elementAt(8).toString(),
                    image: [row.elementAt(9).toString()],
                    time: DateTime.now().toString());
                excelListItem.add(item.toMap());
              }
              displayProgressDialog(context);
              for (int i = 1; i < excelListItem.length; i++) {
                 fireStoreMethods.addItemToStock(object: excelListItem.elementAt(i));
//                if (widget.itemId == null) {
//                  excelListItem.elementAt(i).
//                  fireStoreMethods.addItemToStock(
//                      object: excelListItem.elementAt(i),
//                      collection: widget.collection);
//                } else {
//                    fireStoreMethods.addSubItemToStock(
//                        itemId: widget.itemId,
//                        collection: widget.collection,
//                        object: excelListItem.elementAt(i));
//
//                }
                closeProgressDialog(context);
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Item added'),
                ));
              }
            }
          }
        });
      }
    });
  }

  List<String> _popUpItemMenu = [
    Statics.uploadFile,
  ];

  @override
  void initState() {
    if (widget.itemId == null) {
      snapshot = fireStoreMethods.getSubItems(
          type: Statics.item, parentId: widget.collection);
    } else {
      if (widget.categoryId == null) {
        snapshot = fireStoreMethods.getSubItems(
            type: Statics.item, parentId: widget.itemId);
      } else {
        snapshot = fireStoreMethods.getSubItems(
            type: Statics.item, parentId: widget.categoryId);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Stock'),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: _itemChoice,
              itemBuilder: (BuildContext context) {
                return _popUpItemMenu.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice, child: Text(choice));
                }).toList();
              }),
        ],
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
                name: 'Search',
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
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<DataRow> listItem = List();
                  List<DataRow> listItemSearch = List();
                  int i = 0;
                  snapshot.data.documents.forEach((element) {
                    i++;
                    var e = ItemDetailsModel.fromDocumentSnapshot(element);
                    List colorList = e.color;
                    var item = DataRow(cells: [
                      DataCell(Text(i.toString())),
                      DataCell(Text(e.id)),
                      DataCell(
                        Text(e.title),
                      ),
                      DataCell(Text(e.price)),
                      e.size.isNotEmpty
                          ? DataCell(Text(e.size.toString()))
                          : DataCell(Text('no sizes')),
                      e.color.isNotEmpty
                          ? DataCell(Text(e.color.toString()))
                          : DataCell(Text('no colors')),
                      DataCell(Container(
                        child: RatingBar(
                          initialRating: double.parse(e.rating),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      )),
                      DataCell(Text(e.sale)),
                      DataCell(Text(e.desc)),
                      DataCell(Text(e.productDetails)),
                    ]);
                    if (_textSearch.isNotEmpty) {
                      bool isContains = e.title
                          .toLowerCase()
                          .toString()
                          .toLowerCase()
                          .contains(_textSearch);
                      if (isContains) {
                        listItemSearch.add(item);
                      }
                    } else {
                      listItem.add(item);
                    }
                  });

                  return Expanded(
                    child: SingleChildScrollView(
                      child: PaginatedDataTable(
                          availableRowsPerPage: <int>[
                            5,
                            10,
                            20,
                            30,
                            50,
                            100,
                            200
                          ],
                          rowsPerPage: _rowPerPage,
                          header: Text(widget.title),
                          onRowsPerPageChanged: (value) {
                            setState(() {
                              _rowPerPage = value;
                            });
                          },
                          columns: [
                            DataColumn(label: Text('number')),
                            DataColumn(label: Text('id')),
                            DataColumn(label: Text(Statics.title)),
                            DataColumn(label: Text(Statics.price)),
                            DataColumn(label: Text(Statics.sizes)),
                            DataColumn(label: Text(Statics.colors)),
                            DataColumn(label: Text(Statics.rating)),
                            DataColumn(label: Text(Statics.sale)),
                            DataColumn(label: Text(Statics.desc)),
                            DataColumn(label: Text(Statics.detailsProduct)),
                          ],
                          source: CustomDataTable(
                              _textSearch.isEmpty ? listItem : listItemSearch)),
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

class CustomDataTable extends DataTableSource {
  List<DataRow> _list;

  CustomDataTable(this._list);

  int _selectCount = 0;
  bool _isSelected = false;

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
        selected: _isSelected,
        onSelectChanged: (val) {
          if (val) {
            _isSelected = true;
            _list.elementAt(index).cells.forEach((element) {
              print(element.child);
              notifyListeners();
            });
          }
        },
        index: index,
        cells: _list.elementAt(index).cells);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _list.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectCount;
}
