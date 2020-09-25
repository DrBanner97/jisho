import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jisho/util/db_provider.dart';
import 'package:jisho/util/size_config.dart';
import 'package:sqflite/sqflite.dart';

class KanjiAddCollection extends StatefulWidget {
  final String kanjiToInsert;
  final VoidCallback refresh;

  KanjiAddCollection(this.kanjiToInsert, this.refresh);

  @override
  _KanjiAddCollectionState createState() => _KanjiAddCollectionState();
}

class _KanjiAddCollectionState extends State<KanjiAddCollection> {

  var _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  Pattern pattern = r'''@^[\p{L}_][\p{L}\p{N}@$#_]{0,127}$''';
  RegExp regex;
  bool _isLoading = false;
  Database db;
  TextEditingController _collectionName;

  createTable(tableName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String createTableQuery = '''
      CREATE TABLE $tableName (
          kanji varchar(255)
      )
      ''';

      await this.db.rawQuery(createTableQuery);

      await storage.write(key: tableName, value: "");

      String insertIntoTable = '''
      INSERT INTO $tableName
      VALUES ("${widget.kanjiToInsert}");
      ''';

      await this.db.rawQuery(insertIntoTable);
    }
    catch(e){
      print('error $e');
    }

    widget.refresh?.call();
    Navigator.pop(context);


    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _collectionName = TextEditingController();
  }

  @override
  void dispose() {
    _collectionName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    db = DbProvider.of(context).database;

    SizeConfig().init(context);
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical,
            horizontal: SizeConfig.safeBlockVertical * 2),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: SizeConfig.safeBlockVertical * 1.5,
              ),
              Text(
                'add collection',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 1.5,
              ),
              TextFormField(
                style: TextStyle(fontSize: 18),
                controller: _collectionName,
                validator: (val) {
                  //TODO regex??
                  if (val.trim().length == 0
//                      || !(regex.hasMatch(val))
                      ) {
                    return 'invalid name';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Collection name',
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical),
              Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : FlatButton(
                        color: const Color(0xff7e39fb),
                        onPressed: () {
                          if (_formKey.currentState.validate())
                            createTable(_collectionName.text);
                        },
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.safeBlockVertical * 1.5,
                            horizontal: SizeConfig.safeBlockVertical * 5),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text('create'),
                      ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical,
              ),
            ],
          ),
        ));
  }
}
