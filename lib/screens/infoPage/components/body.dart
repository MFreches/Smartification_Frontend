import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  void checkProjectState(BuildContext context) async {
    var route = 'noUpdates';
    int id = ProjectConstants.projectId;
    String apiUrl = 'https://smartification.glitch.me/select_project_state';
    var response =
        await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      int state = decoded[0]['project_state'];
      switch (state) {
        case 0:
          route = '/';
          break;
        case 1:
          route = '/infoPage';
          break;
        case 2:
          route = '/infoPage';
          break;
        case 3:
          route = '/proposedSolution';
          break;
        case 4:
          route = '/infoPage';
          break;
        case 5:
          route = '/infoPage';
          break;
        case 6:
          route = '/infoPage';
          break;
        case 7:
          route = '/infoPage';
          break;
        case 8:
          route = '/infoPage';
          break;
        case 9:
          route = '/solutionInDevelopment';
          break;
        case 10:
          route = '/infoPage';
          break;
        case 11:
          route = '/finalApprove';
          break;
        case 12:
          route = '/infoPage';
          break;
        case 13:
          route = '/afterSales';
          break;
      }
    }
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Information Submited !",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blue),
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: size.width * 0.5,
                height: size.height * 0.1,
                child: Text(
                  "You will receive an email or message when we have updates.\nYou can also 'Check for updates' by pressing the button.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                )),
            const SizedBox(height: 40),
            SizedBox(
              width: size.width * 0.45,
              height: size.height * 0.09,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                ),
                onPressed: () {
                  checkProjectState(context);
                },
                child: Text(
                  "Check for updates",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
