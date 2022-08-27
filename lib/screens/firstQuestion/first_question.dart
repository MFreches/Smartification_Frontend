import 'package:flutter/material.dart';
import 'package:smartification/screens/firstQuestion/components/body.dart';

class FirstQuestion extends StatefulWidget {
  @override
  _FirstQuestion createState() => _FirstQuestion();
}

class _FirstQuestion extends State<FirstQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Smartification Service - Furniture Use Context",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Body());
  }
}
