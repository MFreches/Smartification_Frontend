import 'package:flutter/material.dart';
import 'package:smartification/screens/solutionInDevelopment/components/body.dart';

class SolutionInDevelopment extends StatefulWidget {
  @override
  _SolutionInDevelopment createState() => _SolutionInDevelopment();
}

class _SolutionInDevelopment extends State<SolutionInDevelopment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Prototype In Development",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
