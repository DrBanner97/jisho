import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jisho/screens/kanji_singular_list.dart';
import 'package:jisho/util/db_provider.dart';
import 'package:sqflite/sqflite.dart';

class KanjiList extends StatefulWidget {
  final String jlptLevel;

  KanjiList(this.jlptLevel);

  @override
  _KanjiListState createState() => _KanjiListState();
}

class _KanjiListState extends State<KanjiList> {
  Database _db;
  List<Map> results;

  bool _isLoading = true;

  query() async {
    String query = '''
      SELECT * FROM kanjidict WHERE jlpt = "${widget.jlptLevel}"''';
    results = await _db.rawQuery(query);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1), query);
  }

  @override
  Widget build(BuildContext context) {
    _db = DbProvider.of(context).database;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.jlptLevel} ${results?.length}'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, pos) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KanjiSingularList(results, pos)),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            results[pos]['kanji'],
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('on : ${results[pos]['reg_on']}'),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('kun: ${results[pos]['reg_kun']}'),
                              ],
                            ),
                          )
                        ],
                      )),
                );
              }),
    );
  }
}
