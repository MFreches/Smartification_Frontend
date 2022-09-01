import 'dart:convert';
import 'dart:html' as html;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Body extends StatelessWidget {
  var teste = 0;
  String projectDetailsInfo = '';
  String solutionDescription = '';
  String furnitureName = '';
  String furnitureDim = '';
  String username = '';
  String projectName = '';
  int userId = ProjectConstants.userId;
  static String videoLink = 'XYXQAYG7-ZM';
  var controllerChangeSolution = TextEditingController();
  YoutubePlayerController _controller2 = YoutubePlayerController(
    initialVideoId: videoLink,
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

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
    await selectEcoPrototype();
    return true;
  }

  Future<bool> selectEcoPrototype() async {
    int id = ProjectConstants.projectId;
    var decoded;
    String apiUrl = 'https://smartification.glitch.me/select_eco_prototype';
    var response =
        await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
    if (response.statusCode == 200) {
      decoded = json.decode(response.body);

      solutionDescription = decoded[0]['?column?']['description'];
      videoLink = decoded[0]['?column?']['video_link'];
    }
    return true;
  }

  void updateState() async {
    int id = ProjectConstants.projectId;
    int projectState = 7;
    int customerState = 2;
    String apiUrl = 'https://smartification.glitch.me/update_project_state';
    var response = await post(Uri.parse(apiUrl), body: {
      "project_id": id.toString(),
      "project_state": projectState.toString()
    });
    apiUrl = 'https://smartification.glitch.me/update_customer_state_prototype';
    response = await post(Uri.parse(apiUrl), body: {
      "project_id": id.toString(),
      "customer_state_prototype": customerState.toString()
    });
  }

  void updateSolution(BuildContext context) async {
    int id = ProjectConstants.projectId;
    var decoded;
    String apiUrl = 'https://smartification.glitch.me/select_eco_prototype_2';
    var response =
        await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
    if (response.statusCode == 200) {
      decoded = json.decode(response.body);
      decoded[0]['eco_prototype']['prototype']['feedback']
          ['customer_feedback_prototype'] = controllerChangeSolution.text;
      decoded[0]['eco_prototype']['prototype']['feedback']
          ['customer_state_prototype'] = 2;
      apiUrl = 'https://smartification.glitch.me/update_eco_prototype';
      var encoded = json.encode(decoded[0]['eco_prototype']);
      response = await post(Uri.parse(apiUrl),
          body: {"project_id": id.toString(), "eco_prototype": encoded});
    }
  }

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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    Text("Video with the new updates",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
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
                        width: size.width * 0.25,
                        height: size.height * 0.09,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amberAccent,
                          ),
                          onPressed: () {
                            html.window.open(videoLink, "_blank");
                          },
                          child: Text(
                            "Open Video",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(height: 40),
                    Text(
                      'Solution Description',
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
                          width: size.width * 0.6,
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
                    const SizedBox(height: 55),
                    Text(
                      'Here you can write what you want to change in the proposed solution',
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
                          width: size.width * 0.6,
                          color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: size.width * 0.6,
                      height: size.height * 0.3,
                      child: TextField(
                        style: TextStyle(fontSize: 27),
                        readOnly: false,
                        maxLines: 10,
                        controller: controllerChangeSolution,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 27),
                          border: OutlineInputBorder(),
                          hintText:
                              'Write what you want to change in the proposed solution',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: size.width * 0.45,
                      height: size.height * 0.09,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/infoPage');
                          updateSolution(context);
                          updateState();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: size.width * 0.45,
                      height: size.height * 0.09,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back to the previous page",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
                    "Loading Solution Update.\nThis might take a few seconds.",
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
