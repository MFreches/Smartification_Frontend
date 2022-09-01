import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/http_service/http_service.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  String furnitureName = '';
  String furnitureDim = '';
  String username = '';
  String projectName = '';
  int teste = 0;
  int userId = ProjectConstants.userId;
  var controllerProjectName = TextEditingController();

  void updateProjectDetails(BuildContext context) async {
    int projectId = ProjectConstants.projectId;
    String ideaSpec = ProjectConstants.idea_spec;
    String apiUrl;
    apiUrl = 'https://smartification.glitch.me/select_idea_id';
    Response res = await post(Uri.parse(apiUrl),
        body: {"project_id": projectId.toString()});
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded.length == 0) {
        apiUrl = 'https://smartification.glitch.me/insert_idea_spec';
        await post(Uri.parse(apiUrl),
            body: {"project_id": projectId.toString(), "idea_spec": ideaSpec});
        apiUrl = 'https://smartification.glitch.me/select_idea_id';
        Response res = await post(Uri.parse(apiUrl),
            body: {"project_id": projectId.toString()});
        if (res.statusCode == 200) {
          final decoded = json.decode(res.body);
          ProjectConstants.ideaId = decoded[0]["idea_id"];
        }
      } else {
        ProjectConstants.ideaId = decoded[0]["idea_id"];
      }
    }
    if (controllerProjectName.text == "") {
      projectName = projectName;
    } else {
      projectName = controllerProjectName.text;
      apiUrl = 'https://smartification.glitch.me/update_project_name';
      await post(Uri.parse(apiUrl), body: {
        "project_id": projectId.toString(),
        "project_name": projectName
      });
    }
    ProjectConstants.projectName = projectName;
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
    return true;
  }

  final HttpService httpService = HttpService();
  late final Future? myFuture = getProjectProperties();
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
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      "Confirm Your Project Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 60),
                    SizedBox(
                        height: size.height * 0.2,
                        width: size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: size.height * 0.08,
                                width: size.width * 0.6,
                                child: Text(
                                  'Project Name:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: 15),
                            SizedBox(
                                height: size.height * 0.08,
                                width: size.width * 0.6,
                                child: TextField(
                                  style: TextStyle(fontSize: 27),
                                  decoration: InputDecoration(
                                    
                                    prefixIcon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                    hintText: "$projectName",
                                    hintStyle: TextStyle(
                                      fontSize: 27,
                                      color: Colors.black,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: controllerProjectName,
                                  enabled: true,
                                )),
                          ],
                        )),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: size.height * 0.2,
                        width: size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: size.height * 0.08,
                                width: size.width * 0.35,
                                child: Text(
                                  'Furniture:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(height: 10),
                            SizedBox(
                                height: size.height * 0.08,
                                width: size.width * 0.35,
                                child: AutoSizeText(
                                  "$furnitureName",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.blueGrey,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        )),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: size.height * 0.2,
                        width: size.width * 0.6,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: size.height * 0.08,
                                  width: size.width * 0.35,
                                  child: Text(
                                    'Furniture Dimensions:',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const SizedBox(height: 10),
                              SizedBox(
                                  height: size.height * 0.08,
                                  width: size.width * 0.35,
                                  child: AutoSizeText(
                                    "$furnitureDim",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blueGrey,
                                        fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.center,
                                  )),
                            ])),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.09,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: () {
                          updateProjectDetails(context);
                          Navigator.pushNamed(context, '/firstQuestion');
                        },
                        child: Text(
                          "Proceed",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20)
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
                    style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 30),
                  CircularProgressIndicator(color: Colors.blueGrey)
                ]));
          }
        });
  }
}
