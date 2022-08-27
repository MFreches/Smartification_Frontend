import 'package:flutter/material.dart';
import 'package:smartification/screens/suggestedFunctionalities/body.dart';

class SuggestedFunctionalities extends StatefulWidget {
  @override
  _SuggestedFunctionalities createState() => _SuggestedFunctionalities();
}

class _SuggestedFunctionalities extends State<SuggestedFunctionalities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Suggested Functionalities",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: MyList(),
    );
  }
}
