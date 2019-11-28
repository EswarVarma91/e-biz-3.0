import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/salesLead/ReferedBy.dart';
import 'package:Ebiz/model/ProjectModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Projects extends StatefulWidget {
  var data;
  Projects(this.data);

  @override
  _ProjectsState createState() => _ProjectsState(data);
}

class _ProjectsState extends State<Projects> {
  var data;
  _ProjectsState(this.data);

  static Dio dio = Dio(Config.options);
  List<ProjectModel> listReferals = new List();
  List<ProjectModel> fliterReferals = new List();
  List<ProjectModel> dataCheck = new List();
  bool _isloading = false;
  String uidd;
  final _debouncer = Debouncer(milliseconds: 500);

  Future<String> getUserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString("userId");
    return id;
  }

  @override
  void initState() {
    super.initState();
    getUserID().then((val) => setState(() {
          uidd = val;
          getProject();
          print(uidd);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          data,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    fliterReferals = listReferals
                        .where((u) => (u.proj_name
                            .toLowerCase()
                            .contains(string.toLowerCase())))
                        .toList();
                  });
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(left: 8, right: 8),
                itemCount: fliterReferals == null ? 0 : fliterReferals.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(
                            context,
                            fliterReferals[index].proj_name +
                                " PROJ_" +
                                fliterReferals[index].project_id.toString());
                      },
                      title: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          fliterReferals[index].proj_name[0].toUpperCase() +
                              fliterReferals[index].proj_name.substring(1),
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

  getProject() async {
    _isloading = false;
    print(uidd);
    var response = await dio.post(ServicesApi.getData,
        data: {
          "parameter1": "GetDRProjectNoByUId",
          "parameter2": uidd,
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        dataCheck = (json.decode(response.data) as List)
            .map((data) => new ProjectModel.fromJson(data))
            .toList();

        listReferals = dataCheck;
        fliterReferals = dataCheck;
        _isloading = false;
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}
