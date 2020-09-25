import 'package:flutter/material.dart';
import 'package:jisho/screens/kanji_flashcard.dart';

class KanjiCollectionSplit extends StatelessWidget {
  final List<Map> kanjiList;
  List<List<Map>> subCollection;

  KanjiCollectionSplit(this.kanjiList);

  split() {
    List<List<Map>> chunks = [];

    if (kanjiList.length - 30 > 10) {
      for (var i = 0; i < kanjiList.length; i += 30) {
        chunks.add(kanjiList.sublist(
            i, i + 30 > kanjiList.length ? kanjiList.length : i + 30));
      }

      chunks.forEach((element) {
        print(element.length);
      });
    } else
      chunks.add(kanjiList);

    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    subCollection = split();

    return Scaffold(
      appBar: AppBar(
        title: Text('sub collection'),
      ),
      body: ListView.builder(
          itemCount: subCollection.length,
          itemBuilder: (context, pos) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KanjiFlashcard(subCollection[pos])),
                );
              },
              title: Text('Sub Collection ${pos + 1}'),
              subtitle: Text('${subCollection[pos].length} kanjis'),
            );
          }),
    );
  }
}
