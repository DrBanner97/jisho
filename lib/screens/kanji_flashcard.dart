import 'package:flutter/material.dart';
import 'package:jisho/util/size_config.dart';
import 'package:jisho/widgets/flashcard.dart';
import 'package:jisho/widgets/kanji_item.dart';
import 'dart:math' as math;

class KanjiFlashcard extends StatefulWidget {
  final List<Map> kanjiList;

  KanjiFlashcard(this.kanjiList);

  @override
  _KanjiFlashcardState createState() => _KanjiFlashcardState();
}

class _KanjiFlashcardState extends State<KanjiFlashcard> {
  List<Map> flashcardList;
  int masteredCount = 0;
  Map reviewing, learning;
  var random = math.Random();

  @override
  void initState() {
    super.initState();
    flashcardList = List();
    flashcardList.addAll(widget.kanjiList);
    reviewing = Map();
    learning = Map();
    shuffle(flashcardList);
  }



  void shuffle(List list, [int start = 0, int end]) {
    if (end == null) end = list.length;
    int length = end - start;
    while (length > 1) {
      int pos = random.nextInt(length);
      length--;
      var tmp1 = list[start + pos];
      list[start + pos] = list[start + length];
      list[start + length] = tmp1;
    }
  }

  onDidKnow(kanji) {



    if (learning.containsKey(kanji)) {
      learning.removeWhere((key, value) => key == kanji);
      reviewing[kanji] = 3;
    } else if (reviewing.containsKey(kanji)) if (reviewing[kanji] == 0) {
      reviewing.removeWhere((key, value) => key == kanji);
      masteredCount++;
    } else
      reviewing[kanji] -= reviewing[kanji];
    else
      masteredCount++;

    nextKanji();
  }

  onNotKnown(kanji) {
    int max = (flashcardList.length - 1);


    if (learning.containsKey(kanji))
      flashcardList.insert(max == 0 ? 0 : random.nextInt(max), kanji);
    else if (reviewing.containsKey(kanji)) {
      flashcardList.insert(max == 0 ? 0 : random.nextInt(max), kanji);
      learning[kanji] = 1;
    } else {
      int x, y, z, w;
      if (max == 0) {
        x = y = z = w = 0;
      } else {
        x = random.nextInt(max);
        y = x + random.nextInt(max - x);
        z = y + random.nextInt(max - y);
        w = z + random.nextInt(max - z);
      }
      print('$x $y $z $w');

      flashcardList.insert(x, kanji);
      flashcardList.insert(y, kanji);
      flashcardList.insert(z, kanji);
      flashcardList.insert(w, kanji);
      learning[kanji] = 1;
    }

    nextKanji();
  }

  nextKanji() {
    if (flashcardList.length > 1)
      setState(() {
        flashcardList.removeAt(0);
      });
    else
      Navigator.pop(context);
  }

  buildCardBadge(kanji) {
    if (learning.containsKey(kanji)) {
      return 'learning';
    } else if (reviewing.containsKey(kanji)) {
      return 'reviewing';
    } else
      return 'new';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockVertical * 3,
            vertical: SizeConfig.safeBlockVertical * 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You have mastered $masteredCount/${widget.kanjiList.length} kanjis',
              style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                  value: masteredCount / widget.kanjiList.length,
                  minHeight: SizeConfig.safeBlockVertical * 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff009688))),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 3),
            Text(
              'You have reviewing ${reviewing.length}/${widget.kanjiList.length} kanjis',
              style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                  value: reviewing.length / widget.kanjiList.length,
                  minHeight: SizeConfig.safeBlockVertical * 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xfffb8c00))),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 3),
            Text(
              'You have learning ${learning.length}/${widget.kanjiList.length} kanjis',
              style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                  value: learning.length / widget.kanjiList.length,
                  minHeight: SizeConfig.safeBlockVertical * 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffc62828))),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockVertical * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Flashcard(
              flashcardList[0],
              buildCardBadge(flashcardList[0]),
              onDidKnow,
              onNotKnown,
            )

//            SizedBox(height: SizeConfig.safeBlockVertical * 5,),
          ],
        ),
      ),
    );
  }
}
