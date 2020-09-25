import 'package:flutter/material.dart';
import 'package:jisho/screens/kanji_singular.dart';
import 'package:jisho/util/db_provider.dart';
import 'package:sqflite/sqflite.dart';

class KanjiSearch extends StatefulWidget {
  @override
  _KanjiSearchState createState() => _KanjiSearchState();
}

class _KanjiSearchState extends State<KanjiSearch> {
  List<Map> searchResult = [];
  TextEditingController searchController;
  Database db;
  bool _isLoading = false;

  onSearchTermChanged(val) {
    if (val.trim().length > 0)
      query(val);
    else
      setState(() {
        searchResult = [];
      });
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  query(searchTerm) async {
    setState(() {
      _isLoading = true;
    });
    String query = '''
      SELECT kanjidict.kanji, kanjidict.reg_kun, kanjidict.reg_on, kanjidict.meaning, kanjidict.jlpt
      FROM kanjidict
      INNER JOIN search ON search.kanji = kanjidict.kanji 
      WHERE search.reg_reading LIKE "%$searchTerm%"
            OR search.reading LIKE "%$searchTerm%"
            OR search.meaning LIKE "%$searchTerm%"

      ''';
    searchResult = await this.db.rawQuery(query);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    db = DbProvider.of(context).database;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: onSearchTermChanged,
          decoration: InputDecoration(
              hintText: 'search term', border: InputBorder.none),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.clear),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : searchResult.length == 0
              ? Center(
                  child: Text(
                    searchController.text.length == 0
                        ? 'type to start searching'
                        : 'No result found',
                  ),
                )
              : ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, pos) {
                    return Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KanjiSingular(searchResult[pos])),
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
                                      searchResult[pos]['kanji'],
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Chip(
                                      label: Text(
                                          searchResult[pos]['jlpt'] == ""? 'Ms':
                                          searchResult[pos]['jlpt'].toString().substring(0,2)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'on : ${searchResult[pos]['reg_on']}'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'kun: ${searchResult[pos]['reg_kun']}'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          '${searchResult[pos]['meaning'].toString().replaceAll(';', ', ')}'),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    );
                  }),
    );
  }
}
