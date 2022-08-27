import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:smartification/screens/welcome/components/background.dart';

class Body extends StatelessWidget {
  static String videoID = 'B_8gu2cnWgw';

  /*launchURL() async {
    const url = 'https://forms.gle/CjXR3uSvS3s2VeMk9';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 25),
            Text(
              "After Sale Feedack",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.blueAccent),
            ),
            const SizedBox(height: 25),
            SizedBox(
                width: size.width * 0.85,
                height: size.height * 0.1,
                child: Text(
                  "This button will open the survey about the smartification process!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 27,
                      color: Colors.black),
                )),
            const SizedBox(height: 25),
            SizedBox(
                width: size.width * 0.25,
                height: size.height * 0.09,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 69, 16, 78),
                  ),
                  onPressed: () {
                    html.window
                        .open("https://forms.gle/SayQJ8wWVo3WaFx26", "_blank");
                  },
                  child: Text(
                    "After Sale Feedback Survey",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
