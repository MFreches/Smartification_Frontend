import 'package:flutter/material.dart';
import 'package:smartification/screens/secondQuestion/body.dart';

class SecondQuestion extends StatefulWidget {
  @override
  _SecondQuestion createState() => _SecondQuestion();
}

class _SecondQuestion extends State<SecondQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Describe Idea",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: MyList(),
    );
  }
}
