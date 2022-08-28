import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartification/constants.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/ChangeSolution/change_solution.dart';
import 'package:smartification/screens/ConfirmationPage/confirmation_page.dart';
import 'package:smartification/screens/ContactsPage/contacts_page.dart';
import 'package:smartification/screens/ProposedSolution/proposed_solution.dart';
import 'package:smartification/screens/SuggestedProjects/suggested_project.dart';
import 'package:smartification/screens/afterSale/after_sale.dart';
import 'package:smartification/screens/finalApprove/final_approve.dart';
import 'package:smartification/screens/firstQuestion/first_question.dart';
import 'package:smartification/screens/firstQuestion2/first_question2.dart';
import 'package:smartification/screens/home/home_screen.dart';
import 'package:smartification/screens/infoPage/info_page.dart';
import 'package:smartification/screens/noUpdates/noUpdates.dart';
import 'package:smartification/screens/reconfiguration/reconfiguration.dart';
import 'package:smartification/screens/refuseSolutionDevelopment/refuse_solution_development.dart';
import 'package:smartification/screens/secondQuestion/second_question.dart';
import 'package:smartification/screens/secondQuestion2/second_question2.dart';
import 'package:smartification/screens/solutionInDevelopment/solution_in_development.dart';
import 'package:smartification/screens/suggestedFunctionalities/suggested_functionalities.dart';
import 'package:smartification/screens/thirdQuestion/third_question.dart';
import 'package:smartification/screens/thirdQuestion2/third_question2.dart';
import 'package:smartification/screens/viewProject/view_project.dart';
import 'package:smartification/screens/welcome/components/background.dart';
import 'package:smartification/screens/welcome/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var route;
  Future<bool> checkProjectState() async {
    int id = ProjectConstants.projectId;
    String apiUrl = 'https://smartification.glitch.me/select_project_state';
    var response =
        await post(Uri.parse(apiUrl), body: {"project_id": id.toString()});
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      int state = decoded[0]['project_state'];
      switch (state) {
        case 0:
          route = '/';
          break;
        case 1:
          route = '/noUpdates';
          break;
        case 2:
          route = '/noUpdates';
          break;
        case 3:
          route = '/proposedSolution';
          break;
        case 4:
          route = '/noUpdates';
          break;
        case 5:
          route = '/noUpdates';
          break;
        case 6:
          route = '/noUpdates';
          break;
        case 7:
          route = '/noUpdates';
          break;
        case 8:
          route = '/noUpdates';
          break;
        case 9:
          route = '/solutionInDevelopment';
          break;
        case 10:
          route = '/noUpdates';
          break;
        case 11:
          route = '/finalApprove';
          break;
        case 12:
          route = '/noUpdates';
          break;
        case 13:
          route = '/afterSales';
          break;
        case 14:
          route = '/afterSales';
          break;
      }
    }
    return true;
  }

  // This widget is the root of your application.
  late final Future? myFuture = checkProjectState();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Smartification Service',
              theme: ThemeData(
                textTheme:
                    Theme.of(context).textTheme.apply(bodyColor: kTextColor),
                scaffoldBackgroundColor: Colors.white,
                primaryColor: kPrimaryColor,
                primarySwatch: Colors.blue,
              ),
              initialRoute: '$route',
              routes: {
                // When navigating to the "/" route, build the FirstScreen widget.
                '/': (context) => LandingPage(),
                // When navigating to the "/second" route, build the SecondScreen widget.
                '/confirmationPage': (context) => ConfirmationPage(),
                '/homePage': (context) => HomeScreen(),
                '/firstQuestion': (context) => FirstQuestion(),
                '/firstQuestion2': (context) => FirstQuestion2(),
                '/secondQuestion': (context) => SecondQuestion(),
                '/secondQuestion2': (context) => SecondQuestion2(),
                '/thirdQuestion': (context) => ThirdQuestion(),
                '/thirdQuestion2': (context) => ThirdQuestion2(),
                '/suggestedProject': (context) => SuggestedProject(),
                '/suggestedFunctionalities': (context) =>
                    SuggestedFunctionalities(),
                '/proposedSolution': (context) => ProposedSolution(),
                '/changeSolution': (context) => ChangeSolution(),
                '/infoPage': (context) => InfoPage(),
                '/noUpdates': (context) => NoUpdates(),
                '/solutionInDevelopment': (context) => SolutionInDevelopment(),
                '/refuseSolutionDevelopment': (context) => RefuseSolutionDev(),
                '/finalApprove': (context) => FinalApprove(),
                '/reconfiguration': (context) => Reconfiguration(),
                '/viewProject': (context) => viewProject(),
                '/afterSales': (context) => AfterSale(),
                '/contactsPage': (context) => ContactsPage()
              },
            );
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Loading Application.\nThis might take a few seconds.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 30),
                  CircularProgressIndicator(color: Colors.blueGrey)
                ]);
          }
        });
  }
}
