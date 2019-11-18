import 'package:flutter/material.dart';

import '../../main.dart';

class ReasonType extends StatefulWidget {
  @override
  _ReasonTypeState createState() => _ReasonTypeState();
}

class _ReasonTypeState extends State<ReasonType> {
  final List<String> listReasons = [
    'Business Meeting',
    'Sales',
    'Meeting',
    'Discussion',
    'Service Support'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reason',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: listReasons.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Card(
              elevation: 0.5,
              child: Material(
                shadowColor: lwtColor,
                child: ListTile(
                  title: Text(listReasons[index]),
                  onTap: () {
//                    Fluttertoast.showToast(msg: listLeaves[index]);
                    Navigator.pop(context, listReasons[index].toString());
                    //Go to the next screen with Navigator.push
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
