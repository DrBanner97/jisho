import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jisho/screens/kanji_add_to_collection_dialog.dart';
import 'package:jisho/widgets/kanji_item.dart';



class KanjiSingular extends StatefulWidget {
  final Map kanji;

  KanjiSingular(this.kanji);

  @override
  _KanjiSingularState createState() => _KanjiSingularState();
}

class _KanjiSingularState extends State<KanjiSingular> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kanji['kanji']),
        actions: [
          IconButton(
            onPressed: (){

              showDialog(context: context, builder: (context){
                return Dialog(
                  child: KanjiAddToCollectionDialog(widget.kanji['kanji']),
                );
              });

            },
            icon: Icon(Icons.playlist_add),
          )
        ],
      ),
      body: Center(
        child: KanjiItem(widget.kanji),
      ),
    );
  }
}
