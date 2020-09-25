import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jisho/screens/kanji_add_new_collection.dart';
import 'package:jisho/util/db_provider.dart';
import 'package:jisho/util/size_config.dart';
import 'package:sqflite/sqflite.dart';

class KanjiAddToCollectionDialog extends StatefulWidget {
  final String kanjiToAdd;

  KanjiAddToCollectionDialog(this.kanjiToAdd);

  @override
  _KanjiAddToCollectionDialogState createState() =>
      _KanjiAddToCollectionDialogState();
}

class _KanjiAddToCollectionDialogState
    extends State<KanjiAddToCollectionDialog> {
  final storage = new FlutterSecureStorage();
  Map<String, int> collectionTableNames = Map();
  bool _isLoading = true;
  Database db;

  @override
  void initState() {
    super.initState();
    fetchKanjiCollectionDetails();
  }

  fetchKanjiCollectionDetails() async {
    if(!_isLoading)
      setState(() {
        _isLoading = true;
      });
    Map tableNames = await storage.readAll();



    

    for(MapEntry e in tableNames.entries){
      String query = '''
        SELECT COUNT(kanji)
        FROM ${e.key}
        WHERE kanji = "${widget.kanjiToAdd}";
      ''';

      List<Map> results = await this.db.rawQuery(query);

      collectionTableNames[e.key] = results[0]['COUNT(kanji)'];
    }

//    tableNames.forEach((key, value) async {
//      String query = '''
//        SELECT COUNT(kanji)
//        FROM $key
//        WHERE kanji = "${widget.kanjiToAdd}";
//      ''';
//
//      List<Map> results = await this.db.rawQuery(query);
//
//      collectionTableNames[key] = results[0]['COUNT(kanji)'];
//    });

    setState(() {
      _isLoading = false;
    });
  }


  addKanjiToCollection(tableName, kanji) async{

    String insertIntoTable = '''
      INSERT INTO $tableName
      VALUES ("$kanji");
      ''';

    await this.db.rawQuery(insertIntoTable);
    await fetchKanjiCollectionDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    db = DbProvider.of(context).database;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockVertical * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'word list',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: KanjiAddCollection(widget.kanjiToAdd,
                                      fetchKanjiCollectionDetails),
                                );
                              });
                        },
                        icon: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical,
                ),
                collectionTableNames.entries.length == 0
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.safeBlockVertical * 2),
                          child: Text('No collections found'),
                        ),
                      )
                    : Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: collectionTableNames.entries.length,
                            itemBuilder: (context, pos) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: collectionTableNames.entries
                                              .elementAt(pos)
                                              .value >
                                          0
                                      ? null
                                      : () {

                                    addKanjiToCollection(collectionTableNames.entries
                                        .elementAt(pos)
                                        .key, widget.kanjiToAdd);

                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.safeBlockVertical *
                                                  1.5,
                                          horizontal:
                                              SizeConfig.safeBlockVertical * 3),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  '${collectionTableNames.entries.elementAt(pos).key}')),
                                          collectionTableNames.entries
                                                      .elementAt(pos)
                                                      .value >
                                                  0
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                )
                                              : Container()
                                        ],
                                      )),
                                ),
                              );
                            }),
                      )
              ],
            ),
    );
  }
}
