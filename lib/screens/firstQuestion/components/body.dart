import 'package:flutter/material.dart';
import 'package:smartification/http_service/http_service.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/welcome/components/background.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  int pressed = 0;
  dynamic tagsView = '';
  final HttpService httpService = HttpService();
  final problemDescription = TextEditingController();
  void generateTags(BuildContext context) async {
    ProjectConstants.furnitureContext = problemDescription.text;
    ProjectConstants.control = true;
    (context as Element).reassemble();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            SizedBox(
                width: size.width * 0.5,
                height: size.height * 0.1,
                child: Text(
                  "Furniture Use Context",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.blueGrey),
                )),
            SizedBox(
                width: size.width * 0.85,
                height: size.height * 0.15,
                child: Text(
                    "Based on the furniture that you have chosen, what would be the context of use of that piece? In other words, who would it use, how many times and how is it being used?",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        color: Colors.black))),
            const SizedBox(height: 25),
            SizedBox(
              width: size.width * 0.75,
              height: size.height * 0.10,
              child: Text(
                  "Example 1:\nThis desk would be for my home office to be used by everyone in the family, mostly between 8:00 and 16:00.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.black)),
            ),
            SizedBox(
              width: size.width * 0.75,
              height: size.height * 0.10,
              child: Text(
                  "Example 2:\nI am requesting this kitchen cabinet to my restaurant. It would be used every day, all day by several people.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.black)),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: size.width * 0.75,
              height: size.height * 0.3,
              child: TextField(
                maxLines: 10,
                controller: problemDescription,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Answer Here',
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
                width: size.width * 0.45,
                height: size.height * 0.09,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () async {
                    generateTags(context);
                    Navigator.pushNamed(
                      context,
                      '/firstQuestion2',
                    );
                  },
                  child: Text(
                    "Proceed",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
