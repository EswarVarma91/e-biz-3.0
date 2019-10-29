import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/salesLead/ReferedBy.dart';
import 'package:eaglebiz/model/ResourcesModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resources extends StatefulWidget {
  var data,rId;
  Resources(this.data,this.rId);

  @override
  _ResourcesState createState() => _ResourcesState(data,rId);
}

class _ResourcesState extends State<Resources> {
  var data,rId;
  _ResourcesState(this.data,this.rId);
  static Dio dio = Dio(Config.options);
  List<ResourcesModel> listReferals = new List();
  List<ResourcesModel> fliterReferals = new List();
  List<ResourcesModel> dataCheck = new List();
  bool _isloading= false;
  String uidd;
  final _debouncer = Debouncer(milliseconds: 500);

  Future<String> getUserID() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String id=preferences.getString("uId");
    return id;
  }

  @override
  void initState() {
    super.initState();
    getUserID().then((val)=>setState((){
      uidd="USR_"+val;
      print(uidd);
    }));
    getResources(rId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(data,style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Search by Project or Project Id',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    fliterReferals = listReferals
                        .where((u) => (
                        u.memberName.toLowerCase().contains(string.toLowerCase()) ||
                            u.u_id.toLowerCase().contains(string.toLowerCase())
                    )).toList();
                  });
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(left: 8,right: 8),
                itemCount:fliterReferals ==null ? 0: fliterReferals.length,
                itemBuilder: (BuildContext context,int index){
                  return Card(
                    child: ListTile (
                      onTap: (){
                        Navigator.pop(context, fliterReferals[index].memberName+" "+fliterReferals[index].u_id);
                      },
                      title: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(fliterReferals[index].memberName[0].toUpperCase()+fliterReferals[index].memberName.substring(1),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
//                  trailing:Padding(padding:EdgeInsets.all(10),child: Text(fliterReferals[index].uId)),
                    ),

                  );
                }),
          ),
        ],
      ),
    );
  }






  getResources(String rId) async {
    _isloading = false;

    var response = await dio.post(ServicesApi.emp_Data,
        data:
        {
          "actionMode": "GetProjectTeamByProjId",
          "parameter1": rId,
        },
        options: Options(contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {

        dataCheck = (json.decode(response.data) as List)
            .map((data) => new ResourcesModel.fromJson(data))
            .toList();
        dataCheck.removeWhere((item)=>item.u_id.toString()==uidd.toString());
        listReferals=dataCheck;
        fliterReferals=dataCheck;
        _isloading = false;

      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}
