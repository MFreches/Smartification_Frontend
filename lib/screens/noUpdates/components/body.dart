import 'package:flutter/material.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sorry, no updates yet !",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blueAccent),
            ),
            const SizedBox(height: 15),
            Container(
                width: 450,
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(
                  "You will receive an email or a message when we have updates. Thanks!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
