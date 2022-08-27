import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/http_service/http_service.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  final HttpService httpService = HttpService();
  bool todasChamadas = false;
  int first = 0;
  int getProblemDescription2state = 0;
  int teste = 0;
  int notSimilar = 0;
  String tag1 = '';
  String tag2 = '';
  dynamic tagsView = '';
  dynamic splitted;
  dynamic bestid;
  dynamic bestid2;
  List<dynamic> res3ProjectId = [];
  List<String> res3Name = [];
  List<String> res3ProblemDescription = [];
  List<String> name = [];
  List<String> tagsList = [];
  dynamic problemDescriptionText = '';
  bool isNull = false;

  Future<bool> suggestProjects() async {
    for (var tagToSearch in ProjectConstants.tagsToShow) {
      String apiUrl =
          'https://smartification.glitch.me/select_suggested_project';
      var response =
          await post(Uri.parse(apiUrl), body: {"tagToSearch": tagToSearch});
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        for (var iDecoded in decoded) {
          if (res3ProjectId.contains(iDecoded['project_id']) ||
              iDecoded['project_id'] == ProjectConstants.projectId) {
            continue;
          } else {
            int projectId = iDecoded['project_id'];
            String apiUrl =
                'https://smartification.glitch.me/select_furniture_category';
            var response = await post(Uri.parse(apiUrl),
                body: {"project_id": projectId.toString()});
            final categorys = json.decode(response.body);
            if (categorys[0]['category'] ==
                ProjectConstants.furnitureCategory) {
              if (!res3ProjectId.contains(projectId)) {
                if (projectId == ProjectConstants.projectId) {
                  continue;
                } else {
                  res3ProjectId.add(projectId);
                  String apiUrl =
                      'https://smartification.glitch.me/select_near_project';
                  var response = await post(Uri.parse(apiUrl),
                      body: {"projectId": projectId.toString()});
                  if (response.statusCode == 200) {
                    final decoded = json.decode(response.body);
                    res3Name.add(decoded[0]['name']);
                    if (decoded[0]['smartification_need'] == null)
                      res3ProblemDescription
                          .add("Sorry, no description to show.");
                    else
                      res3ProblemDescription
                          .add(decoded[0]['smartification_need']);
                  }
                }
              } else {
                continue;
              }
            } else {
              continue;
            }
          }
        }
      }
    }
    if (res3Name.isEmpty) {
      isNull = true;
      return false;
    } else {
      return true;
    }
  }

  late final Future? myFuture = suggestProjects();
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
                  width: size.width * 0.5,
                  height: size.height * 0.05,
                  child: Text(
                    "Projects Catalog",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.blueGrey),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                  height: size.height * 0.8,
                  width: size.width * 0.8,
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: res3ProjectId.length,
                      itemBuilder: (context, index) {
                        if (res3ProjectId.length <= 0) {
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Sorry, we don't have any projects to suggest.",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Return to the previous page.",
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back),
                                    color: Colors.blueAccent),
                              ]);
                        } else {
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
                                    child: ListTile(
                                        title: new Text(res3Name[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Colors.blueGrey)),
                                        subtitle: new Text(
                                            res3ProblemDescription[index],
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black)),
                                        onTap: () {
                                          ProjectConstants.projectIdSelected =
                                              res3ProjectId[index];
                                          ProjectConstants.projectNameSelected =
                                              res3Name[index];
                                          Navigator.pushNamed(
                                              context, '/viewProject');
                                        })),
                                const SizedBox(height: 10)
                              ]);
                        }
                      })),
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
                      "Back to home page",
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  )),
              const SizedBox(height: 15)
            ])));
          } else {
            return Background(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(
                    "Loading Projects Catalog.\nThis might take a few seconds.",
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
