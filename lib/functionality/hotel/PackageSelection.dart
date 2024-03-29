import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/hotel/DownTeamMembers.dart';
import 'package:Ebiz/functionality/salesLead/ReferedBy.dart';
import 'package:Ebiz/model/DownTeamMembersModel.dart';
import 'package:Ebiz/model/HotelUserDetailsModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class PackageSelection extends StatefulWidget {
  String data;
  PackageSelection(this.data);
  @override
  _PackageSelectionState createState() => _PackageSelectionState(data);
}

Future<String> getUserID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String id = preferences.getString("userId");
  return id;
}

class _PackageSelectionState extends State<PackageSelection> {
  var data;
  _PackageSelectionState(this.data);
  static Dio dio = Dio(Config.options);
  List<DownTeamMembersModel> listReferals = [];
  List<DownTeamMembersModel> fliterReferals = [];
  List<DownTeamMembersModel> dataCheck = [];
  List<HotelUserDetailsModel> htdm = [];
  String uidd, multiUser;
  List result;
  bool _isChecked = false;
  List selectedList = [];
  List<DownTeamMembersModel> createJList = [];
  final _debouncer = Debouncer(milliseconds: 500);

  void onChanged(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserID().then((val) => setState(() {
          uidd = val;
          getDownTeamMembers(uidd);
        }));
  }

  void _onCSelected(bool selected, u_id, String fullName) {
    if (selected == true) {
      setState(() {
        selectedList.add(u_id);
      });
    } else {
      setState(() {
        selectedList.remove(u_id);
      });
    }
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                var data1 = selectedList.toString().replaceAll("[", "");
                var data2 = data1.replaceAll("]", "");
                var result = data2.replaceAll(" ", "");

                getUserDetailsNameId(result);
              },
            )
          ],
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
                itemCount: fliterReferals?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    value: selectedList.contains(fliterReferals[index].u_id),
                    onChanged: (bool selected) {
                      _onCSelected(selected, fliterReferals[index].u_id,
                          fliterReferals[index].FullName);
                    },
                    title: Text(
                      fliterReferals[index].FullName,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  getDownTeamMembers(String uidds) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["fullname"],
          "parameter1": "getDownTeamRequestPackage"
        },);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        dataCheck = (json.decode(response.data) as List)
            .map((data) => new DownTeamMembersModel.fromJson(data))
            .toList();
        listReferals = dataCheck;
        fliterReferals = dataCheck;
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  void getUserDetailsNameId(String result) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "getHotelUserId_Name",
          "parameter2": result,
        },);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List list = [];
      String Users;
      var two;
      setState(() {
        htdm = (json.decode(response.data) as List)
            .map((data) => new HotelUserDetailsModel.fromJson(data))
            .toList();
        for (int i = 0; i < htdm.length; i++) {
          list.add(htdm[i].itemName);
        }
        var one = list.toString().replaceAll("[", "");
        Users = one.replaceAll("]", "");
        Navigator.pop(context, htdm);
      });
      SharedPreferences pre = await SharedPreferences.getInstance();
      pre.setString("Users", Users);
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}
