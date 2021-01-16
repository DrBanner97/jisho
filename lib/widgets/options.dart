import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jisho/util/db_provider.dart';

import 'dart:developer' as developer;

class Options extends StatefulWidget {
  final dynamic kanji;

  Options(this.kanji, Key key) : super(key: key);

  @override
  OptionsState createState() => OptionsState();
}

class OptionsState extends State<Options> {
  Database _db;
  List readings = [], selected = [];
  List correctReadings = [];

  bool showAnswer = false;

  getOptions() async {
    readings = [];
    selected = [];
    correctReadings = [];
    String query = '''
    SELECT * FROM kanjidict WHERE kanji != "${widget.kanji['kanji']}" LIMIT  5 OFFSET ABS(RANDOM()) % MAX((SELECT COUNT(*) FROM kanjidict), 1)
     ''';

    List options = await _db.rawQuery(query);

    options.forEach((kanji) {
      List onReadings = kanji['reg_on'].toString().split('、');
      onReadings.removeWhere(
          (element) => readings.contains(element) || element.trim() == '');

      List kunReadings = kanji['reg_kun'].toString().split('、');
      kunReadings.removeWhere(
          (element) => readings.contains(element) || element.trim() == '');

      readings.addAll(onReadings);
      readings.addAll(kunReadings);
    });

    if (readings.length < 6)
      getOptions();
    else
      setState(() {
        readings.addAll(widget.kanji['reg_on'].toString().split('、'));
        readings.addAll(widget.kanji['reg_kun'].toString().split('、'));

        correctReadings.addAll(widget.kanji['reg_on'].toString().split('、'));
        correctReadings.addAll(widget.kanji['reg_kun'].toString().split('、'));

        readings.shuffle();
        showAnswer = false;
      });
  }

  onSelected(index) {
    setState(() {
      if (selected.contains(index))
        selected.remove(index);
      else
        selected.add(index);
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration.zero, getOptions);
  }

  @override
  void didUpdateWidget(Options oldWidget) {
    if (widget.kanji != oldWidget.kanji) getOptions();
    super.didUpdateWidget(oldWidget);
  }

  displayAnswers() {
    setState(() {
      showAnswer = true;
    });
  }

  optionItem(pos) {
    Color borderColor = Colors.white,
        backgroundColor = Colors.transparent,
        textColor = Colors.white;

    if (showAnswer) {
      if (correctReadings.contains(readings[pos])) {
        borderColor = Colors.transparent;
        backgroundColor = Colors.green;
        textColor = Colors.white;
      } else if (selected.contains(pos) &&
          !correctReadings.contains(readings[pos])) {
        borderColor = Colors.transparent;
        backgroundColor = Colors.red;
        textColor = Colors.white;
      }
    } else {
      borderColor = Colors.white;
      backgroundColor =
          selected.contains(pos) ? Colors.white : Colors.transparent;
      textColor = selected.contains(pos) ? Colors.black : Colors.white;
    }

    return InkWell(
      onTap: showAnswer
          ? null
          : () {
              onSelected(pos);
            },
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor)),
          padding: EdgeInsets.all(10),
          child: AutoSizeText(
            readings[pos],
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(fontSize: 18, color: textColor),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    _db = DbProvider.of(context).database;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: readings.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3),
                itemBuilder: (context, pos) {
                  return optionItem(pos);
                }))
      ],
    );
  }
}
