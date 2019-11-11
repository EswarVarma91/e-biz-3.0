import 'package:eaglebiz/functionality/travel/AddTravelRequest.dart';
import 'package:eaglebiz/main.dart';
import 'package:flutter/material.dart';

class TravelRequestList extends StatefulWidget {
  @override
  _TravelRequestListState createState() => _TravelRequestListState();
}

class _TravelRequestListState extends State<TravelRequestList> {

  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Travel Request',style: TextStyle(color: Colors.white),),
      iconTheme: IconThemeData(color: Colors.white),),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),backgroundColor: lwtColor,onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AddTravelRequest()));
      },),
      body: Center(child: Text("No List Available"),),
    );
  }
}