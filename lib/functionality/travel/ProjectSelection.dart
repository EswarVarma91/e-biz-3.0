import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/salesLead/ReferedBy.dart';
import 'package:eaglebiz/model/ProjectListModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';

class ProjectSelection extends StatefulWidget {
  var data;
  ProjectSelection(this.data);

  @override
  _ProjectSelectionState createState() => _ProjectSelectionState(data);
}

class _ProjectSelectionState extends State<ProjectSelection> {
  var data;
  _ProjectSelectionState(this.data);
  static Dio dio = Dio(Config.options);
  List<ProjectListModel> listReferals = new List();
  List<ProjectListModel> fliterReferals = new List();
  List<ProjectListModel> dataCheck = new List();

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    getProjectList();
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
                            fliterReferals[index].proj_oano +
                                " P_" +
                                fliterReferals[index].project_id.toString() +
                                " P_" +
                                fliterReferals[index].ref_type.toString());
                      },
                      title: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          fliterReferals[index].proj_oano,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  getProjectList() async {
    var response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "getProjectList"},
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        dataCheck = (json.decode(response.data) as List)
            .map((data) => new ProjectListModel.fromJson(data))
            .toList();
        listReferals = dataCheck;
        fliterReferals = dataCheck;
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}
