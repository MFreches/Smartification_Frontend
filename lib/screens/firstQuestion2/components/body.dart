import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/http_service/http_service.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class MyList extends StatefulWidget {
  @override
  Body createState() => Body();
}

class Body extends State<MyList> {
  //String tagsView = '';
  bool isNull = false;
  int teste = 0;
  dynamic tagsView = ProjectConstants.tagsToShow;
  dynamic problemDescriptionText = ProjectConstants.furnitureContext;
  final HttpService httpService = HttpService();
  final problemDescription = TextEditingController();

  void clear(BuildContext context) {
    ProjectConstants.tagsToAdd = [];
    ProjectConstants.tagsToIncrement = [];
    ProjectConstants.tagsToShow = [];
    ProjectConstants.listTags.clear();
  }

  void removeFrom(BuildContext context, String toRemove) {
    setState(() {
      ProjectConstants.tagsToShow.remove(toRemove);
      if (ProjectConstants.tagsToAdd.contains(toRemove)) {
        ProjectConstants.tagsToAdd.remove(toRemove);
      }

      if (ProjectConstants.tagsToIncrement.contains(toRemove)) {
        ProjectConstants.tagsToIncrement.remove(toRemove);
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    problemDescription.dispose();
  }

  Future<bool> generateTags() async {
    int projectId = ProjectConstants.projectId;
    String apiUrl = 'https://smartification.glitch.me/select_all_tags';
    var response = await get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      for (var iDecoded in decoded) {
        ProjectConstants.mapTags[iDecoded['tag']] = iDecoded['tag_id'];
        ProjectConstants.listTags.add(iDecoded['tag']);
      }
    }
    apiUrl = "http://127.0.0.1:5000/tags";
    response = await post(Uri.parse(apiUrl),
        body: json
            .encode({"furniture_context": ProjectConstants.furnitureContext}));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      for (var iDecoded in decoded['tags']) {
        if (!ProjectConstants.listTags.contains(iDecoded) &&
            !ProjectConstants.tagsToShow.contains(iDecoded)) {
          ProjectConstants.tagsToAdd.add(iDecoded);
          ProjectConstants.tagsToShow.add(iDecoded);
        } else {
          ProjectConstants.tagsToIncrement.add(iDecoded);
          ProjectConstants.tagsToShow.add(iDecoded);
        }
      }
    }
    problemDescriptionText = ProjectConstants.furnitureContext;
    tagsView = ProjectConstants.tagsToShow.join(' / ');
    if (ProjectConstants.tagsToShow.isEmpty) {
      ProjectConstants.tagsToShow.add('N');
    }
    return true;
  }

  late final Future? myFuture = generateTags();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _isEnable = true;

    return FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            //dealDescription(context);
            return Background(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  SizedBox(
                      width: size.width * 0.5,
                      height: size.height * 0.05,
                      child: Text(
                        "Furniture Use Context",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.blueGrey),
                      )),
                  const SizedBox(height: 60),
                  SizedBox(
                      width: size.width * 0.85,
                      height: size.height * 0.3,
                      child: Text(
                          "Based on the 'Furniture Use Context' that you described in the previous page some tags were associated to your project in order to suggest functionalities and suggest other projects.\n\nIn this page you can check the generated tags and:\n- Remove the generated tags that you do not find useful to your project by pressing the '-' icon.\n- Change the Furniture Use Context description. \n- Continue the Smartification Process.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black))),
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
                      child: Text("Generated Tags: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.blue))),
                  const SizedBox(height: 10),
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
                          itemCount: ProjectConstants.tagsToShow.length,
                          itemBuilder: (context, index) {
                            if (!(ProjectConstants.tagsToShow[0] == 'N')) {
                              String teste = ProjectConstants.tagsToShow[index];
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
                                                      fontSize: 22,
                                                      color: Colors.blueAccent,
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
                          Navigator.pop(context);
                          clear(context);
                          teste = 0;
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
                          Navigator.pushNamed(context, '/homePage');
                          teste = 0;
                          _isEnable = false;
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
            ));
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
