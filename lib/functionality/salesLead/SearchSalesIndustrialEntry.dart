import 'dart:convert';
import 'dart:io';

import 'package:Ebiz/functionality/salesLead/SalesIndutrialEntry.dart';
import 'package:Ebiz/model/SalesIndustrialEntryModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchSalesIndustrialEntry extends StatefulWidget {
  var placeofbunsiness;
  SearchSalesIndustrialEntry(this.placeofbunsiness);
  @override
  _SearchSalesIndustrialEntryState createState() =>
      _SearchSalesIndustrialEntryState(placeofbunsiness);
}

class _SearchSalesIndustrialEntryState
    extends State<SearchSalesIndustrialEntry> {
  Dio dio = Dio(Config.options);
  var placeofbunsiness;
  _SearchSalesIndustrialEntryState(this.placeofbunsiness);
  TextEditingController _controller1 = TextEditingController();
  List<SalesIndustrialEntryModel> tcm, filtertcm = [];
  @override
  void initState() {
    super.initState();
    // dynamicData = false;
    _controller1.addListener(_textCount);
  }

  _textCount() {
    if (_controller1.text.length >= 2) {
      getVisitedCompany(_controller1.text);
    } else {
      if (tcm != null) {
        setState(() {
          tcm.clear();
          filtertcm.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        var navigator = Navigator.of(context);
        // ignore: missing_return
        navigator.push(
          // ignore: missing_return
          MaterialPageRoute(
              builder: (BuildContext context) => SalesIndustrialEntry()),
          // ignore: missing_return
          // ModalRoute.withName('/'),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            placeofbunsiness,
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _textTransfertoSalesIndustrialEntry();
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: _controller1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: "Enter Minimum 3 Characters",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    itemCount: filtertcm == null ? 0 : filtertcm.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(
                                context, filtertcm[index].company_name);
                          },
                          title: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              filtertcm[index].company_name.toString(),
                              style: TextStyle(
                                fontSize: 12.0,
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
        ),
      ),
    );
  }

  _textTransfertoSalesIndustrialEntry() {
    Navigator.pop(context, _controller1.text.toString());
  }

  getVisitedCompany(String comapnyName) async {
    Response response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "getSalesEntryCompanyNames",
          "parameter2": comapnyName + "%"
        },);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        tcm = (json.decode(response.data) as List)
            .map((data) => new SalesIndustrialEntryModel.fromJson(data))
            .toList();
        filtertcm = tcm;
      });
      // print(tcm);
    }
  }
}
