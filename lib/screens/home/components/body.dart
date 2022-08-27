import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  void clearTags() {
    ProjectConstants.tagsToAdd = [];
    ProjectConstants.tagsToIncrement = [];
  }

  Future<bool> updateAll() async {
    //update description db
    int projectId = ProjectConstants.projectId;
    String apiUrl = 'https://smartification.glitch.me/update_furniture_context';
    String contexto = 'context';
    var response = await post(Uri.parse(apiUrl), body: {
      "project_id": projectId.toString(),
      "furniture_context": ProjectConstants.furnitureContext,
    });
    //tags to increment
    for (var increment in ProjectConstants.tagsToIncrement) {
      int? idToIncrement = ProjectConstants.mapTags[increment];
      apiUrl = 'https://smartification.glitch.me/update_tagging_ocurrence';
      response = await post(Uri.parse(apiUrl), body: {
        "tag_id": idToIncrement.toString(),
      });
      apiUrl = 'https://smartification.glitch.me/insert_tagging_project';
      response = await post(Uri.parse(apiUrl), body: {
        "tag_id": idToIncrement.toString(),
        "project_id": projectId.toString(),
      });
    }
    //new tags to add
    for (var increment2 in ProjectConstants.tagsToAdd) {
      apiUrl = 'https://smartification.glitch.me/insert_tag';
      response = await post(Uri.parse(apiUrl), body: {
        "tag": increment2,
        "type": contexto,
      });
      apiUrl = 'https://smartification.glitch.me/select_tag';
      response = await post(Uri.parse(apiUrl), body: {
        "tag": increment2,
      });
      final decoded = json.decode(response.body);
      var tagId = decoded[0]["tag_id"];
      apiUrl = 'https://smartification.glitch.me/insert_tagging_project';
      response = await post(Uri.parse(apiUrl), body: {
        "tag_id": tagId.toString(),
        "project_id": projectId.toString(),
      });
    }
    clearTags();
    return true;
  }

  late final Future? myFuture = updateAll();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Background(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    const SizedBox(height: 20),
                    SizedBox(
                        height: size.height * 0.2,
                        width: size.width * 0.8,
                        child: Text(
                            "You can check 'Suggested Smartification Functionalities' and 'Suggested Projects Catalog' but to continue you need to click on the 'Start Smartification Process'",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Colors.blueGrey))),
                    SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/suggestedFunctionalities');
                        },
                        style:
                            ElevatedButton.styleFrom(primary: Colors.lightBlue),
                        child: Text("Suggested Smartification Functionalities",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: size.height * 0.1,
                        width: size.width * 0.55,
                        child: Text(
                            "Click here to have an idea of possible functionalities that you can include in your project.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25))),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/suggestedProject');
                        },
                        style:
                            ElevatedButton.styleFrom(primary: Colors.lightBlue),
                        child: Text("Suggested Projects Catalog",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: size.height * 0.1,
                        width: size.width * 0.55,
                        child: Text(
                            "Click here to browse compatible smartification projects.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25))),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/secondQuestion');
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Text("Start Smartification Process",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.55,
                      child: Text(
                          "Click here to continue your smartification process. *",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25)),
                    )
                  ])),
            );
          } else {
            return Background(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(
                    "Loading Information.\nThis might take a few seconds.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 30),
                  CircularProgressIndicator(color: Colors.blueGrey)
                ]));
          }
        });
  }
}
