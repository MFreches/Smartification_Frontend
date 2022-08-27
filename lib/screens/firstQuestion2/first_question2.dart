import 'package:flutter/material.dart';
import 'package:smartification/screens/firstQuestion2/components/body.dart';

class FirstQuestion2 extends StatefulWidget {
  @override
  _FirstQuestion2 createState() => _FirstQuestion2();
}

class _FirstQuestion2 extends State<FirstQuestion2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Smartification Service - Furniture Use Context",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: MyList());
  }
}
