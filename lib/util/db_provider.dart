
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class DbProvider extends InheritedWidget{

  final Database database;

  DbProvider({
    Key key,
    this.database,
    Widget child,
  }) : super(key: key, child: child);


  static DbProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DbProvider>();
  }


  @override
  bool updateShouldNotify(DbProvider oldWidget) {
    return oldWidget.database != database;
  }
}