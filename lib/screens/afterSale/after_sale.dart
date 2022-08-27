import 'package:flutter/material.dart';
import 'package:smartification/screens/afterSale/components/body.dart';

class AfterSale extends StatefulWidget {
  @override
  _AfterSale createState() => _AfterSale();
}

class _AfterSale extends State<AfterSale> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Smartification Service - After Sale Feedback",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Body(),
    );
  }
}
