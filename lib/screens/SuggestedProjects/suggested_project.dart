import 'package:flutter/material.dart';
import 'package:smartification/screens/SuggestedProjects/body.dart';

class SuggestedProject extends StatefulWidget {
  @override
  _SuggestedProject createState() => _SuggestedProject();
}

class _SuggestedProject extends State<SuggestedProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Projects Catalog",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
