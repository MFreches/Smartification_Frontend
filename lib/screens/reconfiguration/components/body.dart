import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  List<String> reconfigurations = [];
  int teste = 0;
  String isNull = "fds";
  void getReconfigurations(BuildContext context) async {
    int id = ProjectConstants.projectId;
    String apiUrl = 'https://smartification.glitch.me/select_reconfigurations';
    var response =
        await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded != null || decoded != '') {
        for (var iDecoded in decoded) {
          reconfigurations.add(iDecoded['reconfiguration']);
        }
      }
    }
    if (reconfigurations.isEmpty) {
      isNull = "Null";
    }
  }

  void updateSolution(BuildContext context, String reconfiguration) async {
    int id = ProjectConstants.projectId;
    var decoded;
    String apiUrl = 'https://smartification.glitch.me/select_eco_prototype_2';
    var response =
        await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
    if (response.statusCode == 200) {
      decoded = json.decode(response.body);
      decoded[0]['eco_prototype']['prototype']['feedback']
              ['customer_feedback_prototype'] =
          "Reconfiguration requested:" + reconfiguration;
      decoded[0]['eco_prototype']['prototype']['feedback']
          ['customer_state_prototype'] = 6;
      apiUrl = 'https://smartification.glitch.me/update_eco_prototype';
      var encoded = json.encode(decoded[0]['eco_prototype']);
      response = await post(Uri.parse(apiUrl),
          body: {"project_id": id.toString(), "eco_prototype": encoded});
    }
  }

  void updateState() async {
    int id = ProjectConstants.projectId;
    int projectState = 7;
    int customerState = 6;
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

  @override
  Widget build(BuildContext context) {
    if (teste == 0) {
      getReconfigurations(context);
      Future.delayed(const Duration(seconds: 10), () {
        (context as Element).reassemble();
        teste = 1;
      });
      return Background(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text(
              "Loading Reconfigurations.\nThis might take a few seconds.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            CircularProgressIndicator(color: Colors.blueGrey)
          ]));
    }
    return Background(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select one possible reconfiguration:",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 55),
              Center(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: reconfigurations.length,
                      itemBuilder: (context, index) {
                        if (isNull != "Null") {
                          String teste = reconfigurations[index];
                          return Wrap(
                            children: <Widget>[
                              AutoSizeText("$teste",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () {
                                    updateSolution(context, teste);
                                    updateState();
                                  },
                                  icon: Icon(Icons.add),
                                  color: Colors.blueAccent),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  "Sorry, we do not have any reconfigurations to suggest.",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold)),
                            ],
                          );
                        }
                      })),
            ]),
      ),
    );
  }
}
