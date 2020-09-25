import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jisho/screens/kanji_collection_split.dart';
import 'package:jisho/screens/kanji_flashcard.dart';
import 'package:jisho/screens/kanji_singular.dart';
import 'package:jisho/screens/kanji_singular_list.dart';
import 'package:jisho/util/db_provider.dart';
import 'package:sqflite/sqflite.dart';

class KanjiCollection extends StatefulWidget {
  final String tableName;

  KanjiCollection(this.tableName);

  @override
  _KanjiCollectionState createState() => _KanjiCollectionState();
}

class _KanjiCollectionState extends State<KanjiCollection> {
  bool _isLoading = true;
  List<Map> result;

  Database db;

  fetchCollectionKanji() async {
    setState(() {
      _isLoading = true;
    });
    String query = '''
      SELECT kanjidict.kanji, kanjidict.reg_kun, kanjidict.reg_on, kanjidict.meaning, kanjidict.jlpt
      FROM kanjidict
      INNER JOIN ${widget.tableName} ON ${widget.tableName}.kanji = kanjidict.kanji
      ''';

    result = await this.db.rawQuery(query);

    setState(() {
      _isLoading = false;
    });
  }

  deleteKanji(kanji) async {
    String query = '''
      DELETE FROM ${widget.tableName} WHERE kanji = "$kanji"
      ''';
    await this.db.rawQuery(query);
    fetchCollectionKanji();
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1), fetchCollectionKanji);
  }

  @override
  Widget build(BuildContext context) {
    db = DbProvider.of(context).database;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.tableName}'),
        actions: [
          IconButton(
            onPressed: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => KanjiFlashcard(result)),
//              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KanjiCollectionSplit(result)),
              );


            },
            icon: Icon(Icons.calendar_view_day),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : result.length == 0
              ? Center(
                  child: Text(
                    'No kanji found',
                  ),
                )
              : ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, pos) {
                    return Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    KanjiSingularList(result, pos)),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      result[pos]['kanji'],
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Chip(
                                      label: Text(result[pos]['jlpt'] == ""
                                          ? 'Ms'
                                          : result[pos]['jlpt']
                                              .toString()
                                              .substring(0, 2)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('on : ${result[pos]['reg_on']}'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('kun: ${result[pos]['reg_kun']}'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          '${result[pos]['meaning'].toString().replaceAll(';', ', ')}'),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteKanji(result[pos]['kanji']);
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            )),
                      ),
                    );
                  }),
    );
  }
}
