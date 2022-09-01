import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class MyList extends StatefulWidget {
  @override
  Body createState() => Body();
}

class Body extends State<MyList> {
  final smartificationPieceContext = TextEditingController();
  dynamic problemDescriptionText;
  dynamic tagsView = ProjectConstants.tagsToShow;
  int teste = 0;

  void removeFrom(BuildContext context, String toRemove) {
    setState(() {
      ProjectConstants.listTags3.remove(toRemove);
      if (ProjectConstants.tagsToAdd.contains(toRemove)) {
        ProjectConstants.tagsToAdd.remove(toRemove);
      }

      if (ProjectConstants.tagsToIncrement.contains(toRemove)) {
        ProjectConstants.tagsToIncrement.remove(toRemove);
      }
    });
  }

  void updateAll(BuildContext context) async {
    //update description db
    int projectId = ProjectConstants.projectId;
    String apiUrl =
        'https://smartification.glitch.me/insert_smartification_context';
    String contexto = 'context';
    var response = await post(Uri.parse(apiUrl), body: {
      "project_id": projectId.toString(),
      "smartification_context": ProjectConstants.smartificationPieceContext,
    });
    //tags to increment
    for (var increment in ProjectConstants.tagsToIncrement) {
      int? idToIncrement = ProjectConstants.mapTags[increment];
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
    clearTags(context);
    int projectState = 1;
    apiUrl = 'https://smartification.glitch.me/update_project_state';
    response = await post(Uri.parse(apiUrl), body: {
      "project_id": ProjectConstants.projectId.toString(),
      "project_state": projectState.toString()
    });
    (context as Element).reassemble();
  }

  void clearTags(BuildContext context) {
    ProjectConstants.tagsToAdd.clear();
    ProjectConstants.tagsToIncrement.clear();
    (context as Element).reassemble();
  }

  void clearTags2() {
    for (var tag in ProjectConstants.listTags3) {
      ProjectConstants.tagsToShow.remove(tag);
    }
    ProjectConstants.listTags3.clear();
    ProjectConstants.tagsToAdd.clear();
    ProjectConstants.tagsToIncrement.clear();
  }

  Future<bool> generateTags() async {
    String apiUrl = "http://127.0.0.1:5000/tags";
    var response = await post(Uri.parse(apiUrl),
        body: json.encode({
          "furniture_context": ProjectConstants.smartificationPieceContext
        }));
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
          ProjectConstants.listTags3.add(iDecoded);
        }
      }
    }
    problemDescriptionText = ProjectConstants.smartificationPieceContext;
    if (ProjectConstants.listTags3.isEmpty) {
      ProjectConstants.listTags3.add('N');
    } else {
      tagsView = ProjectConstants.tagsToShow.join(' / ');
    }
    return true;
  }

  late final Future? myFuture = generateTags();
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
                    SizedBox(
                        width: size.width * 0.85,
                        height: size.height * 0.3,
                        child: Text(
                            "Based on the description of the smartification piece use context in the previous page some tags were associated to your project in order to suggest functionalities.\n\nIn this page you can check the generated tags and:\n- Change the description of your Smarification Piece Use Context.\n-Remove the tags generated that you do not find useful to your project.\n- Finish the first steps of the Smartification process.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                color: Colors.black))),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: size.width * 0.75,
                      height: size.height * 0.3,
                      child: TextField(
                        style: TextStyle(fontSize: 27),
                        maxLines: 10,
                        enabled: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '$problemDescriptionText',
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
                    SizedBox(
                        width: size.width * 0.6,
                        height: size.height * 0.05,
                        child: Text(" New Generated Tags: ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.blue))),
                    SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.85,
                        child: Text(
                          "You can remove tags that you do not find useful to your project by pressing the '-' icon.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                        )),
                    SizedBox(
                        height: size.height * 0.8,
                        width: size.width * 0.25,
                        child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: ProjectConstants.listTags3.length,
                            itemBuilder: (context, index) {
                              if (!(ProjectConstants.listTags3 == 'N')) {
                                String teste =
                                    ProjectConstants.listTags3[index];
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 4,
                                                color: Colors.blueAccent,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25))),
                                          child: Column(
                                            children: <Widget>[
                                              Center(
                                                child: Text("$teste",
                                                    textAlign: TextAlign.center,
                                                    //overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Center(
                                                  child: IconButton(
                                                      iconSize: 25,
                                                      onPressed: () {
                                                        removeFrom(
                                                            context, teste);
                                                      },
                                                      icon: Icon(Icons.remove),
                                                      color: Color.fromARGB(
                                                          255, 97, 40, 40))),
                                            ],
                                          )),
                                      const SizedBox(height: 10)
                                    ]);
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text("Sorry, no tags generated.",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                );
                              }
                            })),
                    const SizedBox(height: 25),
                    SizedBox(
                        width: size.width * 0.45,
                        height: size.height * 0.09,
                        child: ElevatedButton(
                          onPressed: () {
                            clearTags2();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Change Description",
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
                            updateAll(context);
                            Navigator.pushNamed(context, '/infoPage');
                          },
                          child: Text(
                            "Proceed",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        )),
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
                    "Creating tags.\nThis might take a few seconds.",
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
