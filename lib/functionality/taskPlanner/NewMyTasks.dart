import 'dart:convert';
import 'dart:io';
import 'package:eaglebiz/functionality/taskPlanner/ReasonType.dart';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/salesLead/ReferedBy.dart';
import 'package:eaglebiz/functionality/taskPlanner/ReasonType.dart' as prefix0;
import 'package:eaglebiz/functionality/taskPlanner/TaskPlanner.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class NewMyTasks extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewMyTasks> {
  final _controller1 =TextEditingController();
  final _controller2 =TextEditingController();
  final _controller3 =TextEditingController();
  final _controller4 =TextEditingController();
  String reasonType="Reason";
  bool office,onsite;
  var referalPerson;
  String profileName,fullname;
  ProgressDialog pr;
  String uidd;

  static Dio dio = Dio(Config.options);

  Future<String> getUserID() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String id=preferences.getString("uId");
    return id;
  }

  @override
  void initState() {
    super.initState();
    office=true;
    onsite=false;
    getUserID().then((val)=>setState((){
      uidd=val;
      print(uidd);
    }));
    getProfileName();
  }

  void getProfileName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profileName = preferences.getString("profileName");
      fullname = preferences.getString("fullname");

    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        // ignore: missing_return
        var navigator = Navigator.of(context);
        // ignore: missing_return
        navigator.pushAndRemoveUntil(
          // ignore: missing_return
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          // ignore: missing_return
           ModalRoute.withName('/'),
        );
      },
      child: Scaffold(
          appBar: AppBar(title: Text('Self Activity',style: TextStyle(color: Colors.white),),
            iconTheme: IconThemeData(color:Colors.white),
            leading: IconButton(icon: Icon(Icons.close,color: Colors.white,),onPressed: (){
              var navigator = Navigator.of(context);
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
                          ModalRoute.withName('/'),
              );
            },),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check,color: Colors.white,),
                onPressed: (){
                  //Service Call
                  if(office==true){
                      if(_controller1.text.isEmpty){
                          Fluttertoast.showToast(msg: "Enter Task Name");
                      } else if(_controller2.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Enter Task Details");
                      } else{
                      myTaskService("1");
                      }
//                    Fluttertoast.showToast(msg: "Office");
                  }else if(onsite==true){
                    if(_controller1.text.isEmpty){
                      Fluttertoast.showToast(msg: "Enter Task Name");
                    } else if(_controller2.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Task Details");
                    } else if(_controller3.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Location");
                    } else if(_controller4.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Contact Person");
                    } else if(reasonType=="Reason" || reasonType=="null") {
                      Fluttertoast.showToast(msg: "Enter Reason");
                    } else{
                      myTaskService("2");
                    }
//                    Fluttertoast.showToast(msg: "Instation");
                  }
                },
              )
            ],
          ),
        body: Stack(
          children: <Widget>[
            Container(color: Colors.white,),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,top: 6),
              child: StaggeredGridView.count(crossAxisCount: 4,crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  officeM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  onsiteM(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 60.0),
                  StaggeredTile.extent(2, 60.0),
                ],),
            ),

            Container(
              margin: EdgeInsets.only(top: 80,left: 5,right: 5),
              child:ListView(
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      controller: _controller1,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "Task Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: _controller2,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "Task Details",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  onsite ? ListTile(
                    title: TextFormField(
                      controller: _controller3,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "Location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ):Container(),
                  onsite ? ListTile(
                    title: TextFormField(
                      controller: _controller4,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "Contact Person",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ):Container(),
                  onsite ? ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: reasonType),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.view_list),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    trailing: IconButton(icon: Icon(Icons.add,color: lwtColor,),onPressed: () {
                      reasonTypeM(context);
                    },),
                  ):Container(),

//                  ListTile(
//                    trailing: IconButton(icon: Icon(Icons.add),color:lwtColor,onPressed: (){
//                      _navigatereferMethod(context);
//                    },),
//                    title: TextFormField(
//                      controller: TextEditingController(text: result[0].toUpperCase()+result.substring(1)),
//                      enabled: false,
//                      keyboardType: TextInputType.text,
//                      decoration: InputDecoration(
//                        prefixIcon: Icon(Icons.group_add),
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(10.0),
//                        ),
//                      ),
//                    ),
//                  ),
                ],
              ),
            ),
            //ListView.builder(itemBuilder: null)
          ],
        ),
      ),
    );
}

  officeM() {
    return Material(
      color: office ? lwtColor : Colors.white,
      elevation: 10.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: office ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            office = !office;
            if(office==true){
              onsite=!onsite;
            }else if(office==false){
              onsite=!onsite;
            }
          });
          /* var navigator = Navigator.of(context);
          navigator.push(
            MaterialPageRoute(builder: (BuildContext context) => SalesLeadDetails()),
//                          ModalRoute.withName('/'),
          );*/
        },
        child: Center(
          child:Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text("office".toUpperCase(),style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: office ? Colors.white : lwtColor,
                      ),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onsiteM() {
    return Material(
      color: onsite ? lwtColor : Colors.white,
      elevation: 10.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: onsite ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            onsite = !onsite;
            if(onsite==true){
              office=!office;
            }else if(onsite==false){
              office=!office;
            }
          });
        },
        child: Center(
          child:Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text("In-Station".toUpperCase(),style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: onsite ? Colors.white : lwtColor,
                      ),),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//  void _navigatereferMethod(BuildContext context) async {
//    var data= await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => ReferedBy(result)));
//    try {
//      var string = data.split(" USR_");
//      result = string[0];
//      referalPerson = "USR_"+string[1];
//    }catch(Exception){
//
//    }
//  }

  myTaskService(String s) async {
    pr.show();
    var now = DateTime.now();
    if (s == "1") {

      print(profileName+'/'+_controller1.text+'/'+_controller2.text+"/"+uidd);
      var response = await dio.post(ServicesApi.Task,
          data:
          {
            "actionMode": "insert",
            "createdBy": profileName.toString(),
            "dpCompanyName": "",
            "dpContactPerson": "",
            "dpEndDate": null,
            "dpGivenBy": fullname,
            "dpId": null,
            "dpLocation": "",
            "dpOwnedBy": "",
            "dpOwnedDate": "",
            "dpPhoneNo": "",
            "dpReason": "",
            "dpRefNo": "others",
            "dpStartDate": DateFormat("yyyy-MM-dd hh:mm:ss").format(now),
            "dpStatus": 0,
            "dpTask": _controller1.text.toString(),
            "dpTaskDesc": _controller2.text.toString(),
            "dpType": "Office",
            "dpTaskType":"Self",
            "modifiedBy": profileName,
            "uId": "USR_"+uidd
          },
          options: Options(
            contentType: ContentType.parse('application/json'),));

      if(response.statusCode==200 || response.statusCode==201){
//        var responseJson = json.decode(response.data);
      pr.hide();
        Fluttertoast.showToast(msg: "Task Created");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          ModalRoute.withName('/'),
        );
      }else{
        pr.hide();
        Fluttertoast.showToast(msg: "Please try after some time.");
      }

    }
    else if(s=="2")
    {
      print(profileName+'/'+_controller4.text+'/'+profileName+'/'+_controller3.text+'/'+reasonType.toString()+'/'+_controller1.text+'/'+_controller2.text);
      var response = await dio.post(ServicesApi.Task,
          data:
          {
            "actionMode": "insert",
            "createdBy": profileName.toString(),
            "dpCompanyName": null,
            "dpContactPerson": _controller4.text.toString(),
            "dpEndDate": null,
            "dpGivenBy": fullname,
            "dpId": null,
            "dpLocation": _controller3.text.toString(),
            "dpOwnedBy": null,
            "dpOwnedDate": null,
            "dpPhoneNo": null,
            "dpReason": reasonType.toString(),
            "dpRefNo": null,
            "dpStartDate": null,
            "dpStatus": 0,
            "dpTask": _controller1.text.toString(),
            "dpTaskDesc": _controller2.text.toString(),
            "dpType": "Instation",
            "dpTaskType" : "Self",
            "modifiedBy": profileName,
            "uId": "USR_"+uidd
          },
          options: Options(
            contentType: ContentType.parse('application/json'),));

      if(response.statusCode==200 || response.statusCode==201){
//        var responseJson = json.decode(response.data);
      pr.hide();
        Fluttertoast.showToast(msg: "Task Created");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          ModalRoute.withName('/'),
        );
      }else{
        pr.hide();
        Fluttertoast.showToast(msg: "Please try after some time.");
      }


  }

  }

   reasonTypeM(BuildContext context) async {
    var data= await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ReasonType()));
    print(data.toString());
    reasonType=data.toString();
  }
}
