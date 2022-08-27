import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:smartification/Screens/Welcome/components/background.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Body extends StatelessWidget {
  static String videoID = 'MJEK6i5PwO0';
  final _controller = YoutubePlayerController(
    params: YoutubePlayerParams(
      mute: false,
      showControls: true,
      showFullscreenButton: false,
      autoPlay: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    _controller.loadVideoById(videoId: videoID);
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.1,
                child: Text(
                  "WELCOME TO THE SMARTIFICATION SERVICE!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: size.height * 0.02),
            SizedBox(
                width: size.width * 0.75,
                height: size.height * 0.75,
                child: YoutubePlayerScaffold(
                  autoFullScreen: false,
                  controller: _controller,
                  builder: (context, player) {
                    return Scaffold(
                        body: LayoutBuilder(builder: (context, constraints) {
                      if (constraints.maxWidth > 750) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: player),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: player),
                          ],
                        );
                      }
                    }));
                  },
                )),
            const SizedBox(height: 25),
            SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.75,
                child: Text(
                  "WHAT IS SMARTIFICATION?",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
                height: size.height * 0.2,
                width: size.width * 0.75,
                child: AutoSizeText(
                  "Smartification makes use of the panoply of available devices to provide awareness of objects and the overall environmental conditions around us. If associated with intelligent systems, as those resulting from AI(Artificial Intelligence) algorithms, using big data collections to feed machine learning analysis, it becomes supportive and proactive for a person’s benefit. Smart furniture is the integration of actuators and/or sensors with furniture to provide an easier and better life to the end-user.",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                  textAlign: TextAlign.justify,
                )),
            const SizedBox(height: 30),
            Text(
              "Did you understand the concepts of smartification and smart furniture?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.09,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    _controller.close();
                    Navigator.pushNamed(context, '/confirmationPage');
                  },
                  child: AutoSizeText(
                    "I understood the concepts and I am ready to start the smartification process!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                )),
            const SizedBox(height: 10),
            SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.09,
                child: ElevatedButton(
                  onPressed: () {
                    _controller.close();
                    Navigator.pushNamed(context, '/contactsPage');
                  },
                  child: AutoSizeText(
                    'No, I need help',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                )),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
