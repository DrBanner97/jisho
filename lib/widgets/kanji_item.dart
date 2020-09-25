import 'package:flutter/material.dart';
import 'package:jisho/util/size_config.dart';

class KanjiItem extends StatelessWidget {
  final Map kanji;
  final bool isVisible;

  KanjiItem(this.kanji, {this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              curve: Curves.fastOutSlowIn,
              duration:isVisible? Duration(milliseconds: 300): Duration(milliseconds: 0),
              opacity: isVisible ? 1 : 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: kanji['reg_on']
                    .toString()
                    .split('、')
                    .map((e) => Text(e))
                    .toList(),
              ),
            ),
            SizedBox(
              width: SizeConfig.safeBlockVertical * 2,
            ),
            Text(
              kanji['kanji'],
              style: TextStyle(fontSize: 120),
            ),
            SizedBox(
              width: SizeConfig.safeBlockVertical * 2,
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: isVisible ? 1 : 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: kanji['reg_kun']
                    .toString()
                    .split('、')
                    .map((e) => Text(e))
                    .toList(),
              ),
            ),
          ],
        ),
        kanji['jlpt'] == null
            ? Container()
            : Chip(
                label: Text(kanji['jlpt'].toString().substring(0, 2)),
              ),
        SizedBox(
          height: SizeConfig.safeBlockVertical * 3,
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: isVisible ? 1 : 0,
          child: Text(
            kanji['meaning'].toString().replaceAll(';', ', '),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
