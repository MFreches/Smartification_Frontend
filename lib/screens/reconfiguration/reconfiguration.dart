import 'package:flutter/material.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/reconfiguration/components/body.dart';

class Reconfiguration extends StatefulWidget {
  @override
  _Reconfiguration createState() => _Reconfiguration();
}

class _Reconfiguration extends State<Reconfiguration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Request Reconfiguration",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
