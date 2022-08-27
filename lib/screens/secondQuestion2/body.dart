import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/screens/welcome/components/background.dart';

import '../../models/constants.dart';

class MyList extends StatefulWidget {
  @override
  Body createState() => Body();
}

class Body extends State<MyList> {
  List<dynamic> res3ProjectId = [];
  List<dynamic> functionalities = [];
  List<int> ids = [];
  dynamic tagsView = ProjectConstants.tagsToShow;
  int teste = 0;
  dynamic tagsShow = ProjectConstants.tagsToShow;
  final problemDescription = TextEditingController();
  List<dynamic> newTags = [];
  dynamic newTagsView = '';
  dynamic problemDescriptionText;
  bool isNull1 = false;
  bool isNull2 = false;
  bool done = false;

  void removeFrom(BuildContext context, String toRemove) {
    setState(() {
      ProjectConstants.listTags2.remove(toRemove);
      if (ProjectConstants.tagsToAdd.contains(toRemove)) {
        ProjectConstants.tagsToAdd.remove(toRemove);
      }

      if (ProjectConstants.tagsToIncrement.contains(toRemove)) {
        ProjectConstants.tagsToIncrement.remove(toRemove);
      }
    });
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
        lista = decoded[0]['idea_specifications']['specifications']['other'][0];
        ProjectConstants.funcsToAdd.add(lista);
        decoded[0]['idea_specifications']['specifications']['other'][0] =
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

  Future<bool> getFunctionalities() async {
    //selecionar os projetos que tem as mesmas tags

    for (var tagToSearch in ProjectConstants.tagsToShow) {
      if (ProjectConstants.tagsToAdd.contains(tagToSearch)) {
        continue;
      } else {
        String apiUrl =
            'https://smartification.glitch.me/select_projects_same_tags';
        var response =
            await post(Uri.parse(apiUrl), body: {"tag": tagToSearch});
        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          for (var iDecoded in decoded) {
            int projectId = iDecoded['project_id'];
            if (ids.contains(projectId) ||
                projectId == ProjectConstants.projectId) {
              continue;
            } else {
              ids.add(projectId);
            }
          }
        }
      }
    }

    var decoded;
    String funcs = '';
    String apiUrl = 'https://smartification.glitch.me/select_idea_spec';
    var response = await post(Uri.parse(apiUrl),
        body: {"idea_id": ProjectConstants.ideaId.toString()});
    if (response.statusCode == 200) {
      decoded = json.decode(response.body);
      funcs = decoded[0]['idea_specifications']['specifications']['other'][0];
    }
    //ir buscar as detailed solutions de cada ids
    for (var id in ids) {
      String apiUrl =
          'https://smartification.glitch.me/select_detailed_solution_spec';
      var response =
          await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded.isNotEmpty) {
          if (decoded[0]['?column?']['technical_specifications']
                  ['functional_requirements'] !=
              null) {
            final listfunc = decoded[0]['?column?']['technical_specifications']
                ['functional_requirements'];
            for (var func in listfunc) {
              if (functionalities.contains(func['goal'])) {
                continue;
              } else {
                if (funcs.contains(func['goal'])) {
                  continue;
                } else {
                  functionalities.add(func['goal']);
                }
              }
            }
          } else {
            continue;
          }
        }
      }
    }
    if (functionalities.isEmpty) {
      functionalities.add('N');
    }
    return true;
  }

  void clearTags2() {
    for (var tag in ProjectConstants.listTags2) {
      ProjectConstants.tagsToShow.remove(tag);
    }
    ProjectConstants.listTags2.clear();
    ProjectConstants.tagsToAdd.clear();
    ProjectConstants.tagsToIncrement.clear();
  }

  Future<bool> generateTags() async {
    await addToProject();
    String apiUrl = "http://127.0.0.1:5000/tags";
    var response = await post(Uri.parse(apiUrl),
        body: json.encode(
            {"furniture_context": ProjectConstants.smartificationNeed}));
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
          ProjectConstants.listTags2.add(iDecoded);
        }
      }
    }
    problemDescriptionText = ProjectConstants.smartificationNeed;
    if (ProjectConstants.listTags2.isEmpty) {
      ProjectConstants.listTags2.add('N');
    } else {
      tagsView = ProjectConstants.tagsToShow.join(' / ');
      newTagsView = ProjectConstants.listTags2.join(' / ');
    }
    await getFunctionalities();
    return true;
  }

  void toAdd(teste) {
    ProjectConstants.funcsToAdd.add(teste);
    setState(() {
      functionalities.remove(teste);
    });
  }

  showAlertDialog(BuildContext context, String teste) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "Ok.",
        style: TextStyle(fontSize: 15, color: Colors.blue),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success!"),
      content: Text(
        'You added just added to you project:\n' + '$teste',
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                    const SizedBox(height: 10),
                    SizedBox(
                        width: size.width * 0.5,
                        height: size.height * 0.1,
                        child: Text(
                          "Describe your idea",
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
                            "Based on the description of you idea in the previous page some tags were associated to your project in order to suggest functionalities.\n\nIn this page you can check the generated tags and:\n-Remove the tags generated that you do not find useful to your project.\n- Add functionalities to your project. \n- Change the description of your Idea. \n- Continue the Smartification Process.",
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
                        readOnly: true,
                        maxLines: 10,
                        controller: problemDescription,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '$problemDescriptionText',
                            hintStyle: TextStyle(fontSize: 23)),
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
                            itemCount: ProjectConstants.listTags2.length,
                            itemBuilder: (context, index) {
                              if (!(ProjectConstants.listTags2[0] == 'N')) {
                                String teste =
                                    ProjectConstants.listTags2[index];
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
                        height: size.height * 0.1,
                        width: size.width * 0.85,
                        child: Text(
                          "List of Possible Functionalities:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.blue),
                        )),
                    SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.85,
                        child: Text(
                          "You can add functionalities to the project by pressing the '+' icon.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                        )),
                    SizedBox(
                        height: size.height * 0.8,
                        width: size.width * 0.75,
                        child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: functionalities.length,
                            itemBuilder: (context, index) {
                              if (!(functionalities[0] == 'N')) {
                                String teste = functionalities[index];
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
                                                        fontSize: 25,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Center(
                                                  child: IconButton(
                                                      iconSize: 25,
                                                      onPressed: () {
                                                        showAlertDialog(
                                                            context, teste);
                                                        toAdd(teste);
                                                      },
                                                      icon: Icon(Icons.add),
                                                      color: Colors.green)),
                                            ],
                                          )),
                                      const SizedBox(height: 10)
                                    ]);
                              } else {
                                return SizedBox(
                                  height: size.height * 0.3,
                                  width: size.width * 0.8,
                                  child: Text(
                                      "Sorry, we do not have any functionalities to suggest.",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold)),
                                );
                              }
                            })),
                    const SizedBox(height: 25),
                    SizedBox(
                        width: size.width * 0.45,
                        height: size.height * 0.09,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/secondQuestion');
                            clearTags2();
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
                          Navigator.pushNamed(context, '/thirdQuestion');
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
