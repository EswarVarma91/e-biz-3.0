import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/salesLead/ReferedBy.dart';
import 'package:eaglebiz/model/DownTeamMembersModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownTeamMembers extends StatefulWidget {
  var data;
  DownTeamMembers(this.data);

  @override
  State<StatefulWidget> createState() => _MembersStateS(data);
}

Future<String> getUserID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String id = preferences.getString("userId");
  return id;
}

class _MembersStateS extends State<DownTeamMembers> {
  var data;
  _MembersStateS(this.data);
  static Dio dio = Dio(Config.options);
  List<DownTeamMembersModel> listReferals = [];
  List<DownTeamMembersModel> fliterReferals = [];
  List<DownTeamMembersModel> dataCheck = [];
  bool _isloading = false;
  String uidd;
  List result;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    getUserID().then((val) => setState(() {
          uidd = val;
          getDownTeamMembers(uidd);
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
                hintText: "Search",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    fliterReferals = listReferals
                        .where((u) => (u.FullName.toLowerCase()
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
                            fliterReferals[index].FullName +
                                " USR_" +
                                fliterReferals[index].u_id.toString());
                      },
                      title: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          fliterReferals[index].FullName[0].toUpperCase() +
                              fliterReferals[index].FullName.substring(1),
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

  getDownTeamMembers(String uidds) async {
    _isloading = false;
    print(uidd);
    var response = await dio.post(ServicesApi.getData,
        data: {
          "parameter1": "getDownTeamRequest",
          "parameter2": uidd.toString(),
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseJson = response.data.toString();
      print(responseJson);

      setState(() {
        dataCheck = (json.decode(response.data) as List)
            .map((data) => new DownTeamMembersModel.fromJson(data))
            .toList();
        // dataCheck
        //     .removeWhere((item) => item.u_id.toString() == uidd.toString());

        listReferals = dataCheck;
        fliterReferals = dataCheck;
        _isloading = false;
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}
