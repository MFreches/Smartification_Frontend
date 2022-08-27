import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class HttpService {
  void updateProblemTags(int projectId, String tags) async {
    final String apiUrl =
        "https://smartification.glitch.me/update_problem_tags";
    final response = await post(Uri.parse(apiUrl), body: {
      "project_id": projectId.toString(),
      "smartification_need_tags": tags
    });
  }

  void updateProblem1(
      int projectId, String problemDescription, BuildContext context) async {
    final String apiUrl =
        "https://smartification.glitch.me/update_problem_description_1";
    final response = await post(Uri.parse(apiUrl), body: {
      "project_id": projectId.toString(),
      "problem_description": problemDescription
    });
    (context as Element).reassemble();
  }

  void updateFlutter1(String problemDescription, String project_id) async {
    final String apiUrl = "http://127.0.0.1:5000/tags";
    final response = await post(Uri.parse(apiUrl),
        body: json.encode({
          "problem_description": problemDescription,
          "project_id": project_id
        }));
  }

  Future<List<dynamic>> connectFlutter() async {
    final String postsUrl = "http://127.0.0.1:5000/tags";
    Response res = await get(Uri.parse(postsUrl));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      List<dynamic> tags = decoded['tags'];
      return tags;
    } else {
      throw "erro";
    }
  }
}
