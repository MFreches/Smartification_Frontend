import 'package:flutter/material.dart';
import 'package:smartification/screens/thirdQuestion2/body.dart';

class ThirdQuestion2 extends StatefulWidget {
  @override
  _ThirdQuestion2 createState() => _ThirdQuestion2();
}

class _ThirdQuestion2 extends State<ThirdQuestion2> {
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
