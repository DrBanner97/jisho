import 'package:equatable/equatable.dart';

class Kanji extends Equatable {
  final String kanji,
      radical,
      type,
      regOn,
      regKun,
      onyomi,
      kunYomi,
      nanori,
      grade,
      jlpt,
      meaning,
      compactMeaning;
  final int strokes;

  Kanji(
      this.kanji,
      this.radical,
      this.type,
      this.regOn,
      this.regKun,
      this.onyomi,
      this.kunYomi,
      this.nanori,
      this.strokes,
      this.grade,
      this.jlpt,
      this.meaning,
      this.compactMeaning);

  @override
  List<Object> get props => [
        kanji,
        radical,
        type,
        regOn,
        regKun,
        onyomi,
        kunYomi,
        nanori,
        strokes,
        grade,
        jlpt,
        meaning,
        compactMeaning
      ];
}
