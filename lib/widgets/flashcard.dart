import 'package:flutter/material.dart';
import 'package:jisho/util/size_config.dart';
import 'package:jisho/widgets/kanji_item.dart';

class Flashcard extends StatefulWidget {
  final Map kanji;
  final String kanjiType;
  final Function(Map) onDidKnow, onNotKnown;

  Flashcard(this.kanji, this.kanjiType, this.onDidKnow, this.onNotKnown);

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> with TickerProviderStateMixin {
  bool showAnswer = false;
  Map _currentKanji;

  @override
  void didUpdateWidget(Flashcard oldWidget) {
    if (oldWidget.kanji != widget.kanji) {
      setState(() {
        showAnswer = false;
        _currentKanji = widget.kanji;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  buildCardBadge(kanji) {
    switch (widget.kanjiType) {
      case "learning":
        return Chip(
          backgroundColor: Color(0xffef9a9a),
          label: Text(
            'learning',
            style: TextStyle(color: Color(0xffb71c1c)),
          ),
        );
      case "reviewing":
        return Chip(
          backgroundColor: Color(0xffffb74d),
          label: Text(
            'reviewing',
            style: TextStyle(color: Color(0xffef6c00)),
          ),
        );
      default:
        return Chip(
          label: Text('new'),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _currentKanji = widget.kanji;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      vsync: this,
      child: InkWell(
        onTap: showAnswer
            ? null
            : () {
                setState(() {
                  showAnswer = true;
                });
              },
        child: Card(
          elevation: 3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildCardBadge(widget.kanji),
                  SizedBox(
                    width: SizeConfig.safeBlockVertical,
                  )
                ],
              ),
              KanjiItem(
                _currentKanji,
                isVisible: showAnswer,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 3,
              ),
              showAnswer
                  ? Column(
                children: [
                  InkWell(
                    onTap: () {
                      widget.onDidKnow?.call(_currentKanji);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.safeBlockVertical * 1.3),
                      width: SizeConfig.safeBlockHorizontal * 100,
                      color: Color(0xff81c784),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: Color(0xff1b5e20),
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockVertical,
                          ),
                          Text(
                            'I know this Kanji',
                            style: TextStyle(
                                color: Color(0xff1b5e20),
                                fontSize:
                                SizeConfig.safeBlockVertical * 1.8,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.onNotKnown?.call(_currentKanji);
//              onNotKnown(flashcardList[0]);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.safeBlockVertical * 1.3),
                      width: SizeConfig.safeBlockHorizontal * 100,
                      color: Color(0xffef9a9a),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.clear,
                            color: Color(0xffb71c1c),
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockVertical,
                          ),
                          Text(
                            'I didn\'t know this Kanji',
                            style: TextStyle(
                                color: Color(0xffb71c1c),
                                fontSize:
                                SizeConfig.safeBlockVertical * 1.8,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
