import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';

class InGameScreen extends StatefulWidget {
  InGameScreen({Key key}) : super(key: key);

  final String title = "In game";

  @override
  _InGameScreenState createState() => _InGameScreenState();
}

class _InGameScreenState extends State<InGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: MaterialColor(0xff366336, boardColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
