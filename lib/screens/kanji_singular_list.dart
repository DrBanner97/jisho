import 'package:flutter/material.dart';
import 'package:jisho/screens/kanji_add_to_collection_dialog.dart';
import 'package:jisho/util/size_config.dart';
import 'package:jisho/widgets/kanji_item.dart';
import 'package:jisho/widgets/options.dart';
import 'package:sqflite/sqflite.dart';

import '../util/db_provider.dart';
import '../util/size_config.dart';

import 'dart:developer' as developer;

class KanjiSingularList extends StatefulWidget {
  final List<Map> kanjiList;
  final int currentPos;
  final bool isQuiz;

  KanjiSingularList(this.kanjiList, this.currentPos, {this.isQuiz = false});

  @override
  _KanjiSingularListState createState() => _KanjiSingularListState();
}

class _KanjiSingularListState extends State<KanjiSingularList> {
  int _currentPos;
  List options = [];
  GlobalKey<OptionsState> optionKey = GlobalKey<OptionsState>();
  bool isAnswerDisplay = false;

  @override
  void initState() {
    super.initState();
    _currentPos = widget.currentPos;
//    developer.log(jsonEncode(widget.kanjiList[_currentPos]));
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockVertical * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              KanjiItem(
                widget.kanjiList[_currentPos],
                isVisible: !widget.isQuiz,
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              if (widget.isQuiz)
                Options(widget.kanjiList[_currentPos], optionKey),
              if (widget.isQuiz)
                RaisedButton(
                  onPressed: () {
                    if(isAnswerDisplay){
                      setState(() {
                        _currentPos += 1;
                      });
                      isAnswerDisplay = false;
                      return;
                    }
                    optionKey.currentState.displayAnswers();
                    isAnswerDisplay = true;
                  },
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.5, horizontal: SizeConfig.blockSizeVertical * 5),
                  color: Colors.grey[800],
                  child: Text(isAnswerDisplay?'Continue':'Submit'),
                ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5,)
            ],
          ),
        ),
      ),
    );
  }
}
