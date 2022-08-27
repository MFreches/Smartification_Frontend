import 'package:flutter/material.dart';
import 'package:smartification/screens/infoPage/components/body.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPage createState() => _InfoPage();
}

class _InfoPage extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - Information Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
