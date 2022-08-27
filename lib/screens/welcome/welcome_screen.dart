import 'package:flutter/material.dart';
import 'package:smartification/screens/welcome/components/body.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Smartification Service",
            style: TextStyle(color: Colors.white, fontSize: 25),
            textAlign: TextAlign.center),
      ),
      body: Body(),
    );
  }
}
