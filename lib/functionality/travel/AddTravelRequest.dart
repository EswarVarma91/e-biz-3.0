import 'package:flutter/material.dart';

class AddTravelRequest extends StatefulWidget {
  @override
  _AddTravelRequestState createState() => _AddTravelRequestState();
}

class _AddTravelRequestState extends State<AddTravelRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Travel Request',style: TextStyle(color: Colors.white),),
      iconTheme: IconThemeData(color: Colors.white),),
    );
  }
}