import 'package:flutter/material.dart';
import 'package:smartification/screens/ProposedSolution/components/body.dart';

class ProposedSolution extends StatefulWidget {
  @override
  _ProposedSolution createState() => _ProposedSolution();
}

class _ProposedSolution extends State<ProposedSolution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Proposed Solution",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
