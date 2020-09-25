import 'package:flutter/material.dart';
import 'package:jisho/screens/kanji_add_to_collection_dialog.dart';
import 'package:jisho/util/size_config.dart';
import 'package:jisho/widgets/kanji_item.dart';

class KanjiSingularList extends StatefulWidget {
  final List<Map> kanjiList;
  final int currentPos;

  KanjiSingularList(this.kanjiList, this.currentPos);

  @override
  _KanjiSingularListState createState() => _KanjiSingularListState();
}

class _KanjiSingularListState extends State<KanjiSingularList> {
  int _currentPos;

  @override
  void initState() {
    super.initState();
    _currentPos = widget.currentPos;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentPos + 1}/${widget.kanjiList.length}'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: KanjiAddToCollectionDialog(
                          widget.kanjiList[_currentPos]['kanji']),
                    );
                  });
            },
            icon: Icon(Icons.playlist_add),
          ),
          IconButton(
            onPressed: _currentPos == 0
                ? null
                : () {
                    setState(() {
                      _currentPos -= 1;
                    });
                  },
            icon: Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: _currentPos == widget.kanjiList.length - 1
                ? null
                : () {
                    setState(() {
                      _currentPos += 1;
                    });
                  },
            icon: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockVertical * 2),
        child: KanjiItem(widget.kanjiList[_currentPos]),
      ),
    );
  }
}
