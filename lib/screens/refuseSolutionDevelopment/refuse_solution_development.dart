import 'package:flutter/material.dart';
import 'package:smartification/screens/refuseSolutionDevelopment/components/body.dart';

class RefuseSolutionDev extends StatefulWidget {
  @override
  _RefuseSolutionDev createState() => _RefuseSolutionDev();
}

class _RefuseSolutionDev extends State<RefuseSolutionDev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Change Solution In Development",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
