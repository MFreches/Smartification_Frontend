import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class MyList extends StatefulWidget {
  @override
  Body createState() => Body();
}

class Body extends State<MyList> {
  List<String> nameFunctionalities = [];
  List<String> objectives = [];
  List<int> ids = [];
  String nameFunctionalities1 = '';
  String objectives1 = '';
  String nameFunctionalities2 = '';
  String objectives2 = '';
  String nameFunctionalities3 = '';
  String objectives3 = '';
  String nameFunctionalities4 = '';
  String objectives4 = '';
  List<dynamic> res3ProjectId = [];
  List<dynamic> functionalities = [];
  bool isNull = false;
  int teste = 0;

  Future<bool> getFunctionalities() async {
    //selecionar os projetos que tem as mesmas tags
    for (var tagToSearch in ProjectConstants.tagsToShow) {
      String apiUrl =
          'https://smartification.glitch.me/select_projects_same_tags';
      var response = await post(Uri.parse(apiUrl), body: {"tag": tagToSearch});
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
                functionalities.add(func['goal']);
              }
            }
          } else {
            continue;
          }
        }
      }
    }
    if (functionalities.isEmpty) {
      isNull = true;
      return false;
    } else {
      return true;
    }
  }

  showAlertDialog(BuildContext context, String teste) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Ok."),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success!"),
      content: Text('You added just added to you project:\n' + '$teste'),
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

  void addToProject() async {
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
  }

  void toAdd(teste) {
    ProjectConstants.funcsToAdd.add(teste);
    setState(() {
      functionalities.remove(teste);
    });
  }

  late final Future? myFuture = getFunctionalities();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Background(
                child: SingleChildScrollView(
              child: Column(children: <Widget>[
                const SizedBox(height: 20),
                SizedBox(
                    height: size.height * 0.1,
                    width: size.width * 0.9,
                    child: Text(
                      "Suggested  Functionalities",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.blueGrey),
                    )),
                const SizedBox(height: 10),
                SizedBox(
                    height: size.height * 0.1,
                    width: size.width * 0.85,
                    child: Text(
                      "You can add functionalities to the project by pressing the '+' icon.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black),
                    )),
                const SizedBox(height: 10),
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
                    height: size.height * 0.8,
                    width: size.width * 0.8,
                    child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: functionalities.length,
                        itemBuilder: (context, index) {
                          if (!isNull) {
                            String teste = functionalities[index];
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                    color: Colors.black,
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                    "Sorry, we do not have any functionalities to suggest.",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold)),
                              ],
                            );
                          }
                        })),
                const SizedBox(height: 20),
                SizedBox(
                    width: size.width * 0.45,
                    height: size.height * 0.09,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        addToProject();
                      },
                      child: Text(
                        "Back to home page",
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    )),
                const SizedBox(height: 15)
              ]),
            ));
          } else {
            return Background(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(
                    "Loading Suggested Functionalities.\nThis might take a few seconds.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 30),
                  CircularProgressIndicator(
                      color: Color.fromARGB(211, 30, 136, 189))
                ]));
          }
        });
  }
}
