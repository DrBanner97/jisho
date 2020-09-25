import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jisho/screens/kanji_collection_list.dart';
import 'package:jisho/screens/kanji_list.dart';
import 'package:jisho/screens/kanji_search.dart';
import 'package:jisho/util/db_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


void main() {
  runApp(MyApp());
}
//57da27

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  Database db;

  copyDB() async {
    // Construct a file path to copy database to
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "asset_database.sqlite");

    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'kanjidb.sqlite'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }
  }

  initDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'asset_database.sqlite');
    this.db = await openDatabase(databasePath);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    await copyDB();
    await initDB();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

    return DbProvider(
      database: this.db,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          accentColor: const Color(0xff7e39fb),
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Jisho Kanji Study'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Database db;
  List<Map> results;
  bool _isLoading = true;

  query() async {
    String query = '''
      SELECT DISTINCT jlpt FROM kanjidict ORDER BY jlpt ASC
      ''';
    results = await this.db.rawQuery(query);

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
    db = DbProvider.of(context).database;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KanjiCollectionList()),
              );

            },
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KanjiSearch()),
              );
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, pos) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                KanjiList(results[pos]['jlpt'])),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        results[pos]['jlpt'] == ""
                            ? "Misc"
                            : results[pos]['jlpt'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
