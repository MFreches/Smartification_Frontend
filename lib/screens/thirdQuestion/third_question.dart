import 'package:flutter/material.dart';
import 'package:smartification/screens/thirdQuestion/body.dart';

class ThirdQuestion extends StatefulWidget {
  @override
  _ThirdQuestion createState() => _ThirdQuestion();
}

class _ThirdQuestion extends State<ThirdQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Smartification Use Context",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
