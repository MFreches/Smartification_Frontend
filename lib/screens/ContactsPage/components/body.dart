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
              "Contacts Page:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blueAccent),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue, // Background color
              ),
              onPressed: () {
                //_launchURL;
              },
              child: Text("INEDIT Contacts Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue, // Background color
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Return to previous page",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
/*
_launchURL() async {
  const url = 'https://www.inedit-project.eu/contact/';
  if (await canLaunch(Uri.encodeFull(url))) {
    await launch(Uri.encodeFull(url));
  } else {
    throw 'Could not launch $url';
  }
}*/
