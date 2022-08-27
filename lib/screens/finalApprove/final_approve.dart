import 'package:flutter/material.dart';
import 'package:smartification/screens/finalApprove/components/body.dart';

class FinalApprove extends StatefulWidget {
  @override
  _FinalApprove createState() => _FinalApprove();
}

class _FinalApprove extends State<FinalApprove> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Finalized Solution",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
