import 'package:flutter/material.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/home/components/body.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String furnitureDim = ProjectConstants.furnitureDimensions;
  String furniture = ProjectConstants.furniture;
  String projectName = ProjectConstants.projectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Home Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
