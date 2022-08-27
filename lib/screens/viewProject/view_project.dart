import 'package:flutter/material.dart';
import 'package:smartification/screens/viewProject/components/body.dart';

class viewProject extends StatefulWidget {
  @override
  _viewProject createState() => _viewProject();
}

class _viewProject extends State<viewProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Project Information",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: MyList(), //test git2
    );
  }
}
