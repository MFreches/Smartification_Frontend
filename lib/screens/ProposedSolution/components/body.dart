import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  String furnitureName = '';
  String furnitureDim = '';
  String username = '';
  String projectName = '';
  int teste = 0;
  int userId = ProjectConstants.userId;
  String projectDetailsInfo = '';
  String solutionDescription = '';
  bool control = true;

  Future<bool> projectDetails() async {
    await getProjectProperties();
    int id = ProjectConstants.projectId;
    var decoded;
    //alterar isto para ir buscar a bd
    projectDetailsInfo = "Project Name: " +
        ProjectConstants.projectName +
        "\n" +
        "Furniture: " +
        ProjectConstants.furniture +
        "\n" +
        "Furniture Dimensions: " +
        ProjectConstants.furnitureDimensions;
    String apiUrl = 'https://smartification.glitch.me/select_idea_spec';
    var response = await post(Uri.parse(apiUrl),
        body: {"idea_id": ProjectConstants.ideaId.toString()});
    if (response.statusCode == 200) {
      decoded = json.decode(response.body);
      solutionDescription = decoded[0]['idea_specifications']['specifications']
          ['context']['solution_description'];
    }
    return true;
  }

  Future<bool> getProjectProperties() async {
    String postsUrl =
        'https://smartification.glitch.me/select_username?user_id=' + '$userId';
    Response res = await get(Uri.parse(postsUrl));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      username = decoded[0]["username"].toString();
      ProjectConstants.userName = username;
    }

    int projectId = ProjectConstants.projectId;
    postsUrl =
        'https://smartification.glitch.me/select_project_name?project_id=' +
            '$projectId';
    res = await get(Uri.parse(postsUrl));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      projectName = decoded[0]["name"].toString();
      ProjectConstants.projectName = projectName;
    }
    int furnitureId = ProjectConstants.furniture_id;
    postsUrl =
        'https://smartification.glitch.me/select_furniture_dim?furniture_id=' +
            '$furnitureId';
    res = await get(Uri.parse(postsUrl));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      furnitureName = decoded[0]["name"].toString();
      ProjectConstants.furniture = furnitureName;
      furnitureDim = decoded[0]["dimensions"].toString();
      ProjectConstants.furnitureDimensions = furnitureDim;
    }
    if (furnitureName == null || furnitureName == '') {
      furnitureName = "Ex: Bed";
    }
    if (furnitureDim == null || furnitureDim == '') {
      furnitureDim = "Ex: 99*205";
    }
    if (projectName == null || projectName == '') {
      projectName = "Ex: Bob's Project :=)";
    }
    String apiUrl =
        'https://smartification.glitch.me/select_furniture_category';

    var response = await post(Uri.parse(apiUrl),
        body: {"project_id": projectId.toString()});
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      ProjectConstants.furnitureCategory = decoded[0]['category'];
    }
    apiUrl = 'https://smartification.glitch.me/select_idea_id';
    res = await post(Uri.parse(apiUrl),
        body: {"project_id": projectId.toString()});
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      ProjectConstants.ideaId = decoded[0]["idea_id"];
    }
    return true;
  }

  void updateState() async {
    int id = ProjectConstants.projectId;
    int customerStateIdea = 5;
    int projectState = 4;
    String apiUrl =
        'https://smartification.glitch.me/update_customer_state_idea';
    var response = await post(Uri.parse(apiUrl), body: {
      "idea_id": ProjectConstants.ideaId.toString(),
      "customer_state_idea": customerStateIdea.toString()
    });
    apiUrl = 'https://smartification.glitch.me/update_project_state';
    response = await post(Uri.parse(apiUrl), body: {
      "project_id": id.toString(),
      "project_state": projectState.toString()
    });
  }

  late final Future? myFuture = projectDetails();
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
                    const SizedBox(height: 29),
                    SizedBox(
                        width: size.width * 0.5,
                        height: size.height * 0.1,
                        child: Text(
                          "Proposed Solution",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.blueGrey),
                        )),
                    const SizedBox(height: 20),
                    AutoSizeText(
                      'Project Name:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                          height: 3.0,
                          width: size.width * 0.3,
                          color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: size.height * 0.08,
                        width: size.width * 0.35,
                        child: AutoSizeText(
                          "$projectName",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 40),
                    Text(
                      'Furniture:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                          height: 3.0,
                          width: size.width * 0.3,
                          color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: size.height * 0.08,
                        width: size.width * 0.35,
                        child: AutoSizeText(
                          "$furnitureName",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 10),
                    Text(
                      'Furniture Dimensions:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                          height: 3.0,
                          width: size.width * 0.3,
                          color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: size.height * 0.08,
                        width: size.width * 0.35,
                        child: AutoSizeText(
                          "$furnitureDim",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.blueGrey,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 5),
                    Text(
                      'Proposed Solution Description',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                          height: 3.0,
                          width: size.width * 0.65,
                          color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: size.width * 0.60,
                        height: size.height * 0.2,
                        child: AutoSizeText(
                          "$solutionDescription",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(
                        width: size.width * 0.45,
                        height: size.height * 0.09,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/changeSolution');
                          },
                          child: Text(
                            "Change Solution",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(height: 25),
                    SizedBox(
                        width: size.width * 0.45,
                        height: size.height * 0.09,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            updateState();
                            Navigator.pushNamed(context, '/infoPage');
                          },
                          child: Text(
                            "Accept Solution",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
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
