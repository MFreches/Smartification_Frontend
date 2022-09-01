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
  List<dynamic> res3ProjectId = [];
  List<dynamic> functionalities = [];
  dynamic tagsView = ProjectConstants.tagsToShow;
  int teste = 0;
  dynamic tagsShow = ProjectConstants.tagsToShow;
  final problemDescription = TextEditingController();
  bool isNull = false;
  List<int> ids = [];
  bool finished = false;
  bool done = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    problemDescription.dispose();
  }

  Future<bool> getFunctionalities() async {
    //selecionar os projetos que tem as mesmas tags
    tagsView = ProjectConstants.tagsToShow.join(' / ');
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

    String funcs = '';
    String apiUrl = 'https://smartification.glitch.me/select_idea_spec';
    var response = await post(Uri.parse(apiUrl),
        body: {"idea_id": ProjectConstants.ideaId.toString()});
    if (response.statusCode == 200) {
      if (response.body != "[]") {
        final decoded = json.decode(response.body);
        funcs = decoded[0]['idea_specifications']['specifications']['other'];
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
      functionalities.add("N");
      return false;
    } else {
      return true;
    }
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
      done = true;
    }
    ProjectConstants.funcsToAdd.clear();
  }

  void toAdd(teste) {
    ProjectConstants.funcsToAdd.add(teste);
    setState(() {
      functionalities.remove(teste);
    });
  }

  void generateTags(BuildContext context) async {
    String apiUrl = "http://127.0.0.1:5000/tags";
    var response = await post(Uri.parse(apiUrl),
        body: json.encode({"furniture_context": problemDescription.text}));
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
          ProjectConstants.listTags2.add(iDecoded);
        }
      }
    }
    ProjectConstants.smartificationNeed = problemDescription.text;
    (context as Element).reassemble();
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
                        height: size.height * 0.2,
                        child: Text(
                            "Please specify which functionalities you would like your smart furniture to have? Be as descriptive as possible.\nYou can describe what is the behavior and features that you want for your smart furniture.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                color: Colors.black))),
                    SizedBox(
                        width: size.width * 0.75,
                        height: size.height * 0.10,
                        child: Text(
                            "Example 1:\nI would like to have a charger in my office desk and should be able to charge up to 2 devices at the same time.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.black))),
                    SizedBox(
                        width: size.width * 0.75,
                        height: size.height * 0.10,
                        child: Text(
                            "Example 2:\nIt would be great that my kitchen cabinet lights on automatically when I open the cabinet door. I would also like that the lights stay on 5 seconds after I close the cabinet door.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                color: Colors.black))),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: size.width * 0.75,
                      height: size.height * 0.3,
                      child: TextField(
                        style: TextStyle(fontSize: 27),
                        maxLines: 10,
                        controller: problemDescription,
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
                                color: Colors.black))),
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
                              if (functionalities[0] != "N") {
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
                                    height: size.height * 0.1,
                                    width: size.width * 0.85,
                                    child: Text(
                                      "Sorry, we do not have any functionalities to suggest.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.blue),
                                    ));
                              }
                            })),
                    const SizedBox(height: 25),
                    SizedBox(
                        width: size.width * 0.45,
                        height: size.height * 0.09,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            ProjectConstants.smartificationNeed =
                                problemDescription.text;
                            Navigator.pushNamed(context, '/secondQuestion2');
                          },
                          child: Text(
                            "Proceed",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(height: 10),
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
