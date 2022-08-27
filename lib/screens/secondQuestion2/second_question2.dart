import 'package:flutter/material.dart';
import 'package:smartification/screens/secondQuestion2/body.dart';

class SecondQuestion2 extends StatefulWidget {
  @override
  _SecondQuestion createState() => _SecondQuestion();
}

class _SecondQuestion extends State<SecondQuestion2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smartification Service - Smartification Use Context",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: MyList(),
    );
  }
}
