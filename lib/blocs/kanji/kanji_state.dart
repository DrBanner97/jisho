import 'package:equatable/equatable.dart';
import 'package:jisho/models/kanji.dart';

abstract class KanjiState extends Equatable {
  const KanjiState();

  @override
  List<Object> get props => [];
}

class KanjiLoadInProgress extends KanjiState {}

class KanjiLoadSuccess extends KanjiState {
  final List<Kanji> kanjis;

  const KanjiLoadSuccess([this.kanjis = const []]);

  @override
  List<Object> get props => [kanjis];
}

class KanjiLoadFailure extends KanjiState {}
