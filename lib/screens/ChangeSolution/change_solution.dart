import 'package:flutter/material.dart';
import 'package:smartification/screens/ChangeSolution/components/body.dart';

class ChangeSolution extends StatefulWidget {
  @override
  _ChangeSolution createState() => _ChangeSolution();
}

class _ChangeSolution extends State<ChangeSolution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Change Proposed Solution",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
