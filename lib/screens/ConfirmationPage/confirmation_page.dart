import 'package:flutter/material.dart';
import 'package:smartification/screens/ConfirmationPage/components/body.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPage createState() => _ConfirmationPage();
}

class _ConfirmationPage extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Smartification Service - Confirmation Page",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      )),
      body: Body(),
    );
  }
}
