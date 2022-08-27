import 'package:flutter/material.dart';
import 'package:smartification/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartification/models/constants.dart';
import 'package:smartification/screens/noUpdates/components/body.dart';

class NoUpdates extends StatefulWidget {
  @override
  _NoUpdates createState() => _NoUpdates();
}

class _NoUpdates extends State<NoUpdates> {
  MaterialBanner _showMaterialBanner(BuildContext context) {
    String furnitureDim = ProjectConstants.furnitureDimensions;
    String furniture = ProjectConstants.furniture;
    String projectName = ProjectConstants.projectName;
    return MaterialBanner(
        content: Row(children: <Widget>[
          Expanded(
            child: Text(
              'Project Name: $projectName ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              'Furniture: $furniture',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              'Furniture Dimensions: $furnitureDim cm',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ]),
        leading: Icon(Icons.error),
        padding: EdgeInsets.all(15),
        backgroundColor: Colors.lightBlueAccent,
        contentTextStyle: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              Navigator.pushNamed(context, '/confirmationPage');
            },
            child: Text(
              'Change Details',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text(
              'Hide',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            tooltip: 'Back',
          ),
          title: Text(
            "Smartification Service",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
              tooltip: 'Show Project Information',
              onPressed: () {
                ScaffoldMessenger.of(context)
                  ..removeCurrentMaterialBanner()
                  ..showMaterialBanner(_showMaterialBanner(context));
              },
            ),
          ]),
      body: Body(),
    );
  }
}
