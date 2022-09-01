import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  final smartificationPieceContext = TextEditingController();
  bool finished = false;
  List<int> ids = [];
  List<dynamic> functionalities = [];
  bool isNull = false;
  int teste = 0;
  dynamic tagsView = ProjectConstants.tagsToShow;

  void generateTags(BuildContext context) async {
    String apiUrl = "http://127.0.0.1:5000/tags";
    var response = await post(Uri.parse(apiUrl),
        body: json
            .encode({"furniture_context": smartificationPieceContext.text}));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      for (var iDecoded in decoded['tags']) {
        if (!ProjectConstants.listTags.contains(iDecoded) &&
            !ProjectConstants.tagsToShow.contains(iDecoded)) {
          ProjectConstants.tagsToAdd.add(iDecoded);
        } else {
          ProjectConstants.tagsToIncrement.add(iDecoded);
        }
        if (!ProjectConstants.tagsToShow.contains(iDecoded)) {
          ProjectConstants.tagsToShow.add(iDecoded);
          ProjectConstants.listTags3.add(iDecoded);
        }
      }
    }
    ProjectConstants.smartificationPieceContext =
        smartificationPieceContext.text;
    (context as Element).reassemble();
  }

  Future<bool> addToProject() async {
    if (ProjectConstants.funcsToAdd.isNotEmpty) {
      int id = ProjectConstants.projectId;
      dynamic decoded;
      String lista = '';
      String apiUrl = 'https://smartification.glitch.me/select_idea_spec';
      var response = await post(Uri.parse(apiUrl),
          body: {"idea_id": ProjectConstants.ideaId.toString()});
      if (response.statusCode == 200) {
        decoded = json.decode(response.body);
      }
      if (ProjectConstants.funcsToAdd != []) {
        lista = decoded[0]['idea_specifications']['specifications']['other'];
        ProjectConstants.funcsToAdd.add(lista);
        decoded[0]['idea_specifications']['specifications']['other'] =
            ProjectConstants.funcsToAdd.join(' / ');
        dynamic encoded = json.encode(decoded[0]['idea_specifications']);
        apiUrl = 'https://smartification.glitch.me/update_idea_spec';
        response = await post(Uri.parse(apiUrl), body: {
          "idea_id": ProjectConstants.ideaId.toString(),
          "idea_spec": encoded
        });
      }
    }
    ProjectConstants.funcsToAdd.clear();
    return true;
  }

  void toAdd(teste) {
    ProjectConstants.funcsToAdd.add(teste);
  }

  Future<bool> updateAll() async {
    //update description db
    for (var tagToAdd in ProjectConstants.listTags2) {
      if (!ProjectConstants.tagsToShow.contains(tagToAdd)) {
        ProjectConstants.tagsToShow.add(tagToAdd);
      }
    }
    tagsView = ProjectConstants.tagsToShow.join(' / ');
    int projectId = ProjectConstants.projectId;
    String apiUrl =
        'https://smartification.glitch.me/insert_smartification_need';
    String contexto = 'context';
    String functionalities = 'functionalities';
    var response = await post(Uri.parse(apiUrl), body: {
      "project_id": projectId.toString(),
      "smartification_need": ProjectConstants.smartificationNeed,
    });
    //tags to increment
    for (var increment in ProjectConstants.tagsToIncrement) {
      apiUrl = 'https://smartification.glitch.me/update_tagging_ocurrence_2';
      response = await post(Uri.parse(apiUrl), body: {
        "tag": increment.toString(),
      });
      apiUrl = 'https://smartification.glitch.me/select_tag';
      response = await post(Uri.parse(apiUrl), body: {
        "tag": increment,
      });
      final decoded = json.decode(response.body);
      var tagId = decoded[0]["tag_id"];
      apiUrl = 'https://smartification.glitch.me/insert_tagging_project';
      response = await post(Uri.parse(apiUrl), body: {
        "tag_id": tagId.toString(),
        "project_id": projectId.toString(),
      });
    }
    //new tags to add
    for (var increment2 in ProjectConstants.tagsToAdd) {
      apiUrl = 'https://smartification.glitch.me/insert_tag';
      response = await post(Uri.parse(apiUrl), body: {
        "tag": increment2,
        "type": functionalities,
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
    await addToProject();
    clearTags();
    return true;
  }

  void clearTags() {
    ProjectConstants.tagsToAdd.clear();
    ProjectConstants.tagsToIncrement.clear;
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
                    const SizedBox(height: 10),
                    SizedBox(
                        width: size.width * 0.5,
                        height: size.height * 0.1,
                        child: Text(
                          "Smartification Piece Use Context",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.blueGrey),
                        )),
                    const SizedBox(height: 60),
                    SizedBox(
                        width: size.width * 0.85,
                        height: size.height * 0.12,
                        child: Text(
                            "Now that you have established the functionalities of your furniture, what would be the context of the smartification furniture piece?",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                color: Colors.black))),
                    SizedBox(
                        width: size.width * 0.75,
                        height: size.height * 0.10,
                        child: Text(
                            "Example 1:\nThis desk would be used to work from home and have next to me a charging dock so I can charge my devices.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.black))),
                    SizedBox(
                        width: size.width * 0.75,
                        height: size.height * 0.10,
                        child: Text(
                            "Example 2:\nThis smart kitchen cabinet would help the staff have a better view of what is inside each cabinet.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.black))),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: size.width * 0.75,
                      height: size.height * 0.3,
                      child: TextField(
                        style: TextStyle(fontSize: 27),
                        maxLines: 10,
                        controller: smartificationPieceContext,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Answer Here',
                            hintStyle: TextStyle(fontSize: 27)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: size.width * 0.6,
                      height: size.height * 0.05,
                      child: Text("Tags Associated: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black)),
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      height: size.height * 0.2,
                      child: Text("$tagsView",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.blueAccent)),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: size.width * 0.45,
                      height: size.height * 0.09,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: () {
                          ProjectConstants.smartificationPieceContext =
                              smartificationPieceContext.text;
                          Navigator.pushNamed(context, '/thirdQuestion2');
                        },
                        child: Text(
                          "Proceed",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15)
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
                    "Loading.\nThis might take a few seconds.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 30),
                  CircularProgressIndicator(
                      color: Color.fromARGB(211, 30, 136, 189))
                ]));
          }
        });
  }
}
