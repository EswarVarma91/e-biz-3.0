import 'package:Ebiz/main.dart';
import 'package:flutter/material.dart';

class LeaveType extends StatefulWidget {
  @override
  _LeaveTypeState createState() => _LeaveTypeState();
}

class _LeaveTypeState extends State<LeaveType> {
  final List<String> listLeaves = ['CL', 'CAL', 'SL', 'CO', 'ML', 'LOP'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leave Type',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: listLeaves.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Card(
              elevation: 0.5,
              child: Material(
                shadowColor: lwtColor,
                child: ListTile(
                  title: Text(listLeaves[index]),
                  onTap: () {
//                    Fluttertoast.showToast(msg: listLeaves[index]);
                    Navigator.pop(context, listLeaves[index].toString());
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
