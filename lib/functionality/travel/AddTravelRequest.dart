import 'package:eaglebiz/functionality/travel/TravelSelection.dart';
import 'package:flutter/material.dart';

class AddTravelRequest extends StatefulWidget {
  @override
  _AddTravelRequestState createState() => _AddTravelRequestState();
}

class _AddTravelRequestState extends State<AddTravelRequest> {
  TextEditingController _controller1 = TextEditingController();
  String TtravelName,Tmode,TmodeType,Tfrom,Tto,Tclass,TcomplaintNo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Travel Request',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: TtravelName),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Traveller Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>TravelSelection("1","")));
                if(data!=null){
                  setState(() {
                  TtravelName = data.toString();
                });
                }
                
              },
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: Tmode),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Mode",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>TravelSelection("2","")));
                if(data!=null){
                  setState(() {
                  Tmode = data.toString();
                });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: TmodeType),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Mode Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>TravelSelection("3","")));
                if(data!=null){
                  setState(() {
                  TmodeType = data.toString();
                });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: Tclass),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Class",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>TravelSelection("4",Tmode)));
                if(data!=null){
                  setState(() {
                  Tmode = data.toString();
                });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
