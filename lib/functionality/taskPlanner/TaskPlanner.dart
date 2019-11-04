import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:eaglebiz/activity/HomePage.dart';
import 'package:eaglebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:eaglebiz/functionality/taskPlanner/NewMyTasks.dart';
import 'package:eaglebiz/functionality/taskPlanner/NewProjectTasks.dart';
import 'package:eaglebiz/functionality/taskPlanner/NewTeamTasks.dart';
import 'package:eaglebiz/functionality/taskPlanner/TaskPlannerEdit.dart';
import 'package:eaglebiz/model/TaskListModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class TaskPlanner extends StatefulWidget {
  @override
  _TaskPlannerState createState() => _TaskPlannerState();
}

class _TaskPlannerState extends State<TaskPlanner> {
  bool _color1, _color2, _color3, _color4;
  var todayT='-',openT='-',progressT='-',closedT='-';
  bool myTasks, teamTasks, projectTasks;
  String uidd;
  bool _isloading = false;
  List<TaskListModel> list1 = [];
  List<TaskListModel> list11 = [];
  List<TaskListModel> list2 = [];
  List<TaskListModel> list3 = [];
  List<TaskListModel> list4 = [];
  List<TaskListModel> list5 = [];
  List<TaskListModel> list6 = [];
  static Dio dio = Dio(Config.options);
  var now = DateTime.now();
  var timeCheck;
  bool _listDisplay = true;
  String profilename,fullname;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> streamSubscription;

  Future<String> getUserID() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String id=preferences.getString("userId");
    return id;
  }
  void getProfileName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profilename = preferences.getString("profileName");
      fullname = preferences.getString("fullname");
    });
  }

  @override
  void initState() {
    super.initState();
    _color1 = true;
    _color2 = false;
    _color3 = false;
    _color4 = false;
    myTasks = true;
    teamTasks = false;
    projectTasks = false;
    getProfileName();
    timeCheck = DateFormat("yyyy-MM-dd").format(now);
    getUserID().then((val) => setState(() {
          uidd = val;
          print(uidd);
          getTaskPlanner(uidd);
        }));
    connectivity=Connectivity();
    streamSubscription=connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        getTaskPlanner(uidd);
      }
    });
  }

  void checkServices() {
    list2.clear();
    if(myTasks==true){
      //today filter
      list3 = list1.where((d) {
        DateTime dt = DateTime.parse(d.dp_created_date.toString());

        if (DateFormat("yyyy-MM-dd").format(dt) == timeCheck && d.dpTaskType == "Self" && d.dp_given_by==profilename) {
          return true;
        }
        return false;
      },
      ).toList();
      //open filter
      list4= list1.where((d){
        if(d.dp_status.toString()=="1" && d.dpTaskType == "Self" && d.dp_given_by==profilename ){
          return true;
        }
        return false;
      }).toList();
      //progress filter
      list5=list1.where((d){
        if(d.dp_status.toString()=="2" && d.dpTaskType == "Self" && d.dp_given_by==profilename ){
          return true;
        }
        return false;
      }).toList();
      //closed filter
      list6= list1.where((d){
        if(d.dp_status.toString()=="3" && d.dpTaskType == "Self" && d.dp_given_by==profilename){
          return true;
        }
        return false;
      }).toList();

      todayT=list3.length.toString();
      openT=list4.length.toString();
      progressT=list5.length.toString();
      closedT=list6.length.toString();

      if(_color1==true){
        setState(() {
          list2=list3;
        });
      }else if(_color2==true){
        setState(() {
          list2=list4;
        });
      }else if(_color3==true){
        setState(() {
         list2=list5;
        });
      }else if(_color4==true){
        setState(() {
          list2=list6;
        });
      }
    }
     else if (teamTasks == true) {
       //today filter
      list3=  list1.where((d) {
        DateTime dt = DateTime.parse(d.dp_created_date.toString());
        if (DateFormat("yyyy-MM-dd").format(dt) == timeCheck && d.dpTaskType == "Team") {
          return true;
        }
        return false;
      }).toList();
      //open
      list4= list1.where((d){
        if(d.dp_status.toString()=="1" && d.dpTaskType == "Team" ){
          return true;
        }
        return false;
      }).toList();
      //progress
      list5 = list1.where((d){
        if(d.dp_status.toString()=="2" && d.dpTaskType == "Team" ){
          return true;
        }
        return false;
      }).toList();
      //closed
      list6 = list1.where((d){
        if(d.dp_status.toString()=="3" && d.dpTaskType == "Team" ){
          return true;
        }
        return false;
      }).toList();

      //
      todayT=list3.length.toString();
      openT=list4.length.toString();
      progressT=list5.length.toString();
      closedT=list6.length.toString();

       if(_color1 == true ){
         setState(() {
         list2=list3;
         });
       }else if(_color2==true){
         setState(() {
           list2=list4;
         });
       }else if(_color3==true){
         setState(() {
           list2=list5;
         });
       }else if(_color4==true){
         setState(() {
          list2=list6;
         });
       }

    } else if (projectTasks == true) {

       //today
        list3=  list11.where((d) {
          DateTime dt = DateTime.parse(d.dp_created_date.toString());
          if (DateFormat("yyyy-MM-dd").format(dt) == timeCheck &&  d.dpTaskType=="Project" ) {
            return true;
          }
          return false;
        }).toList();
        //open
        list4 = list11.where((d){
          if(d.dp_status.toString()=="1" && d.dpTaskType=="Project"  ){
            return true;
          }
          return false;
        }).toList();
        //progress
        list5 = list11.where((d){
          if(d.dp_status.toString()=="2" && d.dpTaskType=="Project" ){
            return true;
          }
          return false;
        }).toList();
        //closed
        list6 = list11.where((d){
          if(d.dp_status.toString()=="3" && d.dpTaskType=="Project"  ){
            return true;
          }
          return false;
        }).toList();
        //

        //
        todayT=list3.length.toString();
        openT=list4.length.toString();
        progressT=list5.length.toString();
        closedT=list6.length.toString();

       if(_color1 == true){
         setState(() {
          list2=list3;
         });
       }else if(_color2==true){
         setState(() {
           list2=list4;
         });
       }else if(_color3==true){
         setState(() {
           list2=list5;
         });
       }else if(_color4==true){
         setState(() {
           list2=list6;
         });
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        // ignore: missing_return
        var navigator = Navigator.of(context);
        // ignore: missing_return
        navigator.push(
          // ignore: missing_return
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          // ignore: missing_return
          // ModalRoute.withName('/'),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Task Management",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
//        leading: Icon(Icons.monetization_on,color: Colors.white,),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (myTasks == true) {
              // Add your onPressed code here!
              var navigator = Navigator.of(context);
              navigator.push(
                MaterialPageRoute(
                    builder: (BuildContext context) => NewMyTasks()),
//                          ModalRoute.withName('/'),
              );
            } else if (teamTasks == true) {
              var navigator = Navigator.of(context);
              navigator.push(
                MaterialPageRoute(
                    builder: (BuildContext context) => NewTeamTasks()),
//                          ModalRoute.withName('/'),
              );
            } else if (projectTasks == true) {
              var navigator = Navigator.of(context);
              navigator.push(
                MaterialPageRoute(
                    builder: (BuildContext context) => NewProjectTasks()),
//                          ModalRoute.withName('/'),
              );
            }
          },
          child: Icon(Icons.add),
          backgroundColor: lwtColor,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 60, right: 5, top: 6),
              child: StaggeredGridView.count(
                crossAxisCount: 6,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: myTasksM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: teamTasksM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: projectTasksM(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 45.0),
                  StaggeredTile.extent(2, 45.0),
                  StaggeredTile.extent(2, 45.0),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 60, right: 5, top: 60),
              child: StaggeredGridView.count(
                crossAxisCount: 8,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: dashboard1(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: dashboard2(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: dashboard3(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: dashboard4(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 60, right: 2, top: 140),
              child: _listDisplay ? taskListView() : Container(),
            ),
            CollapsingNavigationDrawer("3"),
            //ListView.builder(itemBuilder: null)
          ],
        ),
      ),
    );
  }

  Material dashboard1() {
    return Material(
      color: _color1 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color1 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _color1 = !_color1;
            checkServices();
            if (_color2 == true) {
              _color2 = !_color2;
              checkServices();
            } else if (_color3 == true) {
              _color3 = !_color3;
              checkServices();
            } else if (_color4 == true) {
              _color4 = !_color4;
              checkServices();
            } else if(_color1==false){
              _color2=!_color2;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        "Today".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0, fontFamily: "Roboto",
                          color: _color1 ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        todayT.toString(),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _color1 ? Colors.white : lwtColor),
                      ),
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

  Material dashboard2() {
    return Material(
      color: _color2 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color2 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _color2 = !_color2;
            checkServices();
            if (_color1 == true) {
              _color1 = !_color1;
              checkServices();
            } else if (_color3 == true) {
              _color3 = !_color3;
              checkServices();
            } else if (_color4 == true) {
              _color4 = !_color4;
              checkServices();
            } else if(_color2==false){
              _color3=!_color3;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        "Open".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0, fontFamily: "Roboto",
                          color: _color2 ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        openT.toString(),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _color2 ? Colors.white : lwtColor),
                      ),
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

  Material dashboard3() {
    return Material(
      color: _color3 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color3 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _color3 = !_color3;
            checkServices();
            if (_color1 == true) {
              _color1 = !_color1;
              checkServices();
            } else if (_color2 == true) {
              _color2 = !_color2;
              checkServices();
            } else if (_color4 == true) {
              _color4 = !_color4;
              checkServices();
            } else if(_color3==false){
              _color4=!_color4;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        "Progress".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0, fontFamily: "Roboto",
                          color: _color3 ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        progressT.toString(),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _color3 ? Colors.white : lwtColor),
                      ),
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

  Material dashboard4() {
    return Material(
      color: _color4 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color4 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _color4 = !_color4;
            checkServices();
            if (_color1 == true) {
              _color1 = !_color1;
              checkServices();
            } else if (_color3 == true) {
              _color3 = !_color3;
              checkServices();
            } else if (_color2 == true) {
              _color2 = !_color2;
              checkServices();
            } else if(_color4==false){
              _color1=!_color1;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        "Closed".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0, fontFamily: "Roboto",
                          color: _color4 ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        closedT.toString(),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _color4 ? Colors.white : lwtColor),
                      ),
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

  Material teamTasksM() {
    return Material(
      color: teamTasks ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: teamTasks ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            teamTasks = !teamTasks;
            checkServices();
            if (myTasks == true) {
              myTasks = !myTasks;
              checkServices();
            } else if (projectTasks == true) {
              projectTasks = !projectTasks;
              checkServices();
            } else if (teamTasks == false) {
              projectTasks = !projectTasks;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        "Team".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: "Roboto",
                          color: teamTasks ? Colors.white : lwtColor,
                        ),
                      ),
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

  Material projectTasksM() {
    return Material(
      color: projectTasks ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: projectTasks ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            projectTasks = !projectTasks;
            checkServices();
            if (myTasks == true) {
              myTasks = !myTasks;
              checkServices();
            } else if (teamTasks == true) {
              teamTasks = !teamTasks;
              checkServices();
            } else if (projectTasks == false) {
              myTasks = !myTasks;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        "Project".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: "Roboto",
                          color: projectTasks ? Colors.white : lwtColor,
                        ),
                      ),
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

  Material myTasksM() {
    return Material(
      color: myTasks ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: myTasks ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            myTasks = !myTasks;
            if (teamTasks == true) {
              teamTasks = !teamTasks;
              checkServices();
            } else if (projectTasks == true) {
              projectTasks = !projectTasks;
              checkServices();
            } else if (myTasks == false) {
              teamTasks = !teamTasks;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        "Self".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: "Roboto",
                          color: myTasks ? Colors.white : lwtColor,
                        ),
                      ),
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

   getTaskPlanner(String uiddd) async {
    setState(() => _isloading = true);
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {"parameter1": "GetAllTasksIncludingDownTeamById", "parameter2": uiddd.toString()},
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          list1 = (json.decode(response.data) as List).map((data) => new TaskListModel.fromJson(data)).toList();
          list11=list1;
          _isloading = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }
      checkServices();
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  taskListView() {
    return ListView.builder(
        itemCount: list2 == null ? 0 : list2.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: InkWell(
                child: Container(
                    /* decoration: BoxDecoration(border: Border.all(color: lwtColor,width: 1),
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(5.0), topRight: const Radius.circular(5.0),bottomLeft: const Radius.circular(5.0), bottomRight: const Radius.circular(5.0),
                        )),*/
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      "EDP_"+list2[index]?.dp_id.toString() ?? 'NA',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                        ),
                        Row(
                          children: <Widget>[
                            Text("Task Name      :   ",style: TextStyle(fontSize: 8,color: Colors.black),),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                            ),
                            Expanded(
                              child: Text(list2[index]?.dp_task ?? 'NA',
                                style: TextStyle(
                                    color: lwtColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                        ),
                        Row(
                          children: <Widget>[
                            Text("Task Details    :   ",style: TextStyle(fontSize: 8,color: Colors.black),),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Expanded(
                              child: Text(list2[index]?.dp_task_desc ?? '' + "NA.",
                                style: TextStyle(
                                  color: lwtColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                        ),
                        Row(
                          children: <Widget>[
                            Text("Task Created  :   ",style: TextStyle(fontSize: 8,color: Colors.black),),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Expanded(
                              child: Text(list2[index]?.dp_created_date.split(" ")[0].toString() ?? '' + "NA.",
                                style: TextStyle(
                                  color: lwtColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                        Row(
                          children: <Widget>[
                            Text("Assigned To    :  ",style: TextStyle(fontSize: 8,color: Colors.black),),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Expanded(
                              child: Text(list2[index]?.fullName ?? '' + "NA.",
                                  style: TextStyle(
                                    color: lwtColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                      ],
                    ),
                    trailing: _color4 ? IconButton(icon: Icon(Icons.visibility_off),onPressed: (){

                    },) : IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: lwtColor,
                        size: 25,
                      ),
                      onPressed: () {
                        if(myTasks==true){
                          if(_color1==true || _color2==true){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> TaskPlannerEdit(list2[index].dp_id.toString(),profilename)));
                          }else if(_color3==true){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> TaskPlannerEdit(list2[index].dp_id.toString(),profilename)));
                          }
                        }else if(teamTasks==true){
                          if(_color1==true || _color2==true){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> TaskPlannerEdit(list2[index].dp_id.toString(),profilename)));
                          }else if(_color3==true){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> TaskPlannerEdit(list2[index].dp_id.toString(),profilename)));
                          }
                        }else if(projectTasks==true){
                          if(_color1==true || _color2==true){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> TaskPlannerEdit(list2[index].dp_id.toString(),profilename)));
                          }else if(_color3==true){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> TaskPlannerEdit(list2[index].dp_id.toString(),profilename)));
                          }
                        }
                        /* var navigator = Navigator.of(context);
                            navigator.push(
                              MaterialPageRoute(builder: (BuildContext context) => EditSalesLead(listpending[index])),
//                          ModalRoute.withName('/'),
                            );*/
                      },
                    )
                  ),
                )),
              ));
        });
  }
}
