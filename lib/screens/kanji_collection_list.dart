import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jisho/screens/kanji_collection.dart';
import 'package:jisho/util/size_config.dart';

//TODO confirmation dialog before deleting a collection


class KanjiCollectionList extends StatefulWidget {
  @override
  _KanjiCollectionListState createState() => _KanjiCollectionListState();
}

class _KanjiCollectionListState extends State<KanjiCollectionList> {
  final storage = new FlutterSecureStorage();
  Map tableNames = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCollections();
  }

  fetchCollections() async {
    tableNames = await storage.readAll();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Collections'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : tableNames.length == 0
              ? Center(
                  child: Text('No collections found'),
                )
              : ListView.builder(
                  itemCount: tableNames.entries.length,
                  itemBuilder: (context, pos) {
                    return Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KanjiCollection(
                                    tableNames.entries.elementAt(pos).key)),
                          );
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tableNames.entries.elementAt(pos).key,
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
    );
  }
}
