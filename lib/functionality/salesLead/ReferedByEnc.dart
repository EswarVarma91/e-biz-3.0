import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:Ebiz/model/ReferedbyModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferedByEnc extends StatefulWidget {
  var data;
  ReferedByEnc(this.data);
  @override
  _ReferedByState createState() => _ReferedByState(data);
}

Future<String> getUserID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String id = preferences.getString("userId");
  return id;
}

class _ReferedByState extends State<ReferedByEnc> {
  var data;
  String uidd;
  _ReferedByState(this.data);

  static Dio dio = Dio(Config.options);
  List<ReferedbyModel> listReferals = new List();
  List<ReferedbyModel> dataCheckList = new List();
  List<ReferedbyModel> fliterReferals = new List();
  bool _isloading = false;
  final _debouncer = Debouncer(milliseconds: 500);
  @override
  void initState() {
    super.initState();
    getUserID().then((val) => setState(() {
          uidd = val;
          getReferals();
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
                hintText: 'Search User or Emp Code',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    fliterReferals = listReferals
                        .where((u) => (u.fullName
                                .toLowerCase()
                                .contains(string.toLowerCase()) ||
                            u.u_emp_code.toString().contains(string)))
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
                            fliterReferals[index].fullName +
                                " USR_" +
                                fliterReferals[index].uId.toString());
                      },
                      title: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          fliterReferals[index].fullName[0].toUpperCase() +
                              fliterReferals[index].fullName.substring(1),
                          style: TextStyle(
                            fontSize: 16.0,
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

  getReferals() async {
    _isloading = false;
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["u_first_name"],
          "parameter1": "GetAllEmpEnc"
        },);

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        dataCheckList = (json.decode(response.data) as List)
            .map((data) => new ReferedbyModel.fromJson(data))
            .toList();

        dataCheckList.removeWhere((item) => item.fullName.toString() == null);
        dataCheckList.removeWhere((item) => item.fullName.toString().isEmpty);

        listReferals = dataCheckList;
        fliterReferals = dataCheckList;

        _isloading = false;
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
