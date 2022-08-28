import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyList extends StatefulWidget {
  @override
  Body createState() => Body();
}

class Body extends State<MyList> {
  dynamic descriptionView = '';
  dynamic customerDescription = '';
  bool todasChamadas = false;
  List<String> nameFunctionalities = [];
  List<String> functionalities = [];
  static String videoLink = 'XYXQAYG7-ZM';
  bool isNull = false;
  Future<bool> getDescription() async {
    //get smartification context and smartification need (customer description)
    final String id = ProjectConstants.projectIdSelected.toString();
    String postsUrl =
        'https://smartification.glitch.me/select_customer_description?project_id=' +
            '$id';
    Response res = await get(Uri.parse(postsUrl));
    if (res.statusCode == 200) {
      if (res.body == "[]") {
        descriptionView = "Nothing to show.";
      } else {
        final decoded = json.decode(res.body);
        var smartification_context = decoded[0]['smartification_context'];
        var smartification_need = decoded[0]['smartification_need'];
        if (smartification_context == null && smartification_need == null)
          customerDescription = 'Sorry, no information';
        else {
          if (smartification_need == null) smartification_need = ' ';
          if (smartification_context == null) smartification_context = ' ';
          customerDescription =
              smartification_context + '\n' + smartification_need;
        }
      }
    }
    //get prototype description
    var decoded;
    String apiUrl = 'https://smartification.glitch.me/select_eco_prototype';
    var response =
        await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
    if (response.statusCode == 200) {
      decoded = json.decode(response.body);

      descriptionView = decoded[0]['?column?']['description'];
      videoLink = decoded[0]['?column?']['video_link'];
    }
    //get functionalities
    String funcs = '';
    apiUrl = 'https://smartification.glitch.me/select_idea_spec';
    response = await post(Uri.parse(apiUrl),
        body: {"idea_id": ProjectConstants.ideaId.toString()});
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      funcs = decoded[0]['idea_specifications']['specifications']['other'];
    }
    apiUrl = 'https://smartification.glitch.me/select_detailed_solution_spec';
    response =
        await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (response.body == '[]') {
        isNull = true;
      } else {
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
        }
      }
    }
    if (functionalities.isEmpty) {
      functionalities.add('N');
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
      content: Text(
        'You added just added to you project:\n' + '$teste',
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
    }
    ProjectConstants.funcsToAdd.clear();
  }

  void toAdd(teste) {
    ProjectConstants.funcsToAdd.add(teste);
    setState(() {
      functionalities.remove(teste);
    });
  }

  late final Future? myFuture = getDescription();
  @override
  Widget build(BuildContext context) {
    String projectName = ProjectConstants.projectNameSelected;
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
                        width: size.width * 0.5,
                        height: size.height * 0.11,
                        child: Text(
                          "$projectName - Project Information",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.blueGrey),
                        )),
                    const SizedBox(height: 20),
                    Text("Video of the project",
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
                      'Prototype Description',
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
                          "$descriptionView",
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
                      'Customer Description',
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
                          "$customerDescription",
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
                      'Project Functionalities',
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
                          width: size.width * 0.6,
                          color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: size.height * 0.3,
                        width: size.width * 0.6,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: functionalities.length,
                            itemBuilder: (context, index) {
                              if (functionalities[0] != 'N') {
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      //overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          color:
                                                              Colors.blueAccent,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              Center(
                                                  child: IconButton(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                        "Sorry, we do not have any functionalities to suggest.",
                                        style: TextStyle(
                                            fontSize: 25,
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
                            addToProject();
                            Navigator.pushNamed(context, '/homePage');
                          },
                          child: Text(
                            "Back to home page",
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
                    "Loading Project Information.\nThis might take a few seconds.",
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
