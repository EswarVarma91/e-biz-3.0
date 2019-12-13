import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:Ebiz/functionality/taskPlanner/NewMyTasks.dart';
import 'package:Ebiz/functionality/taskPlanner/NewProjectTasks.dart';
import 'package:Ebiz/functionality/taskPlanner/NewTeamTasks.dart';
import 'package:Ebiz/functionality/taskPlanner/TaskPlannerEdit.dart';
import 'package:Ebiz/model/TaskListModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
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
  var todayT = '-', openT = '-', progressT = '-', closedT = '-';
  bool myTasks, teamTasks, projectTasks;
  bool forTeam, rlTeam, byTeam;
  String uidd;
  bool _isloading = false;
  List<TaskListModel> list1 = [];
  List<TaskListModel> list11 = [];
  List<TaskListModel> list22 = [];
  List<TaskListModel> list33 = [];
  List<TaskListModel> list2 = [];
  List<TaskListModel> list3 = [];
  List<TaskListModel> list4 = [];
  List<TaskListModel> list5 = [];
  List<TaskListModel> list6 = [];

  List<TaskListModel> teamFilter1 = [];
  List<TaskListModel> teamFilter2 = [];
  List<TaskListModel> teamFilter3 = [];
  List<TaskListModel> teamFilter4 = [];

  static Dio dio = Dio(Config.options);
  var now = DateTime.now();
  var timeCheck;
  bool _listDisplay = true;
  String profilename, fullname;

  Future<String> getUserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString("userId");
    return id;
  }

  void getProfileName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profilename = preferences.getString("profileName");
      fullname = preferences.getString("fullname");
      uidd = preferences.getString("userId");
      getTaskPlanner(uidd);
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
    forTeam = false;
    byTeam = true;
    rlTeam = false;
    getProfileName();
    timeCheck = DateFormat("yyyy-MM-dd").format(now);
    getTaskPlanner(uidd);
  }

  void checkServices() {
    todayT = "0";
    openT = "0";
    progressT = "0";
    closedT = "0";
    list2.clear();
    if (myTasks == true) {
      //today filter
      list3 = list11.where(
        (d) {
          DateTime dt = DateTime.parse(d.dp_created_date.toString());

          if (DateFormat("yyyy-MM-dd").format(dt) == timeCheck &&
              d.dpTaskType == "Self") {
            return true;
          }
          return false;
        },
      ).toList();
      //open filter
      list4 = list11.where((d) {
        if (d.dp_status.toString() == "1" && d.dpTaskType == "Self") {
          return true;
        }
        return false;
      }).toList();
      //progress filter
      list5 = list11.where((d) {
        if (d.dp_status.toString() == "2" && d.dpTaskType == "Self") {
          return true;
        }
        return false;
      }).toList();
      //closed filter
      list6 = list11.where((d) {
        if (d.dp_status.toString() == "3" && d.dpTaskType == "Self") {
          return true;
        }
        return false;
      }).toList();

      todayT = list3.length.toString();
      openT = list4.length.toString();
      progressT = list5.length.toString();
      closedT = list6.length.toString();

      if (_color1 == true) {
        setState(() {
          list2 = list3;
        });
      } else if (_color2 == true) {
        setState(() {
          list2 = list4;
        });
      } else if (_color3 == true) {
        setState(() {
          list2 = list5;
        });
      } else if (_color4 == true) {
        setState(() {
          list2 = list6;
        });
      }
    } else if (teamTasks == true) {
      if (forTeam == true) {
        //for team
        list2.clear();
        teamFilter1 = list33.where(
          (d) {
            DateTime dt = DateTime.parse(d.dp_created_date.toString());

            if (DateFormat("yyyy-MM-dd").format(dt) == timeCheck &&
                d.dpTaskType == "Team" &&
                d.dp_given_by == profilename) {
              return true;
            }
            return false;
          },
        ).toList();
        //open filter
        teamFilter2 = list33.where((d) {
          if (d.dp_status.toString() == "1" &&
              d.dpTaskType == "Team" &&
              d.dp_given_by == profilename) {
            return true;
          }
          return false;
        }).toList();
        //progress filter
        teamFilter3 = list33.where((d) {
          if (d.dp_status.toString() == "2" &&
              d.dpTaskType == "Team" &&
              d.dp_given_by == profilename) {
            return true;
          }
          return false;
        }).toList();
        //closed filter
        teamFilter4 = list33.where((d) {
          if (d.dp_status.toString() == "3" &&
              d.dpTaskType == "Team" &&
              d.dp_given_by == profilename) {
            return true;
          }
          return false;
        }).toList();

        todayT = teamFilter1.length.toString();
        openT = teamFilter2.length.toString();
        progressT = teamFilter3.length.toString();
        closedT = teamFilter4.length.toString();

        if (_color1 == true) {
          setState(() {
            list2 = teamFilter1;
          });
        } else if (_color2 == true) {
          setState(() {
            list2 = teamFilter2;
          });
        } else if (_color3 == true) {
          setState(() {
            list2 = teamFilter3;
          });
        } else if (_color4 == true) {
          setState(() {
            list2 = teamFilter4;
          });
        }
      } else if (byTeam == true) {
        //by team
        list2.clear();
        teamFilter1 = list33.where(
          (d) {
            DateTime dt = DateTime.parse(d.dp_created_date.toString());

            if (DateFormat("yyyy-MM-dd").format(dt) == timeCheck &&
                d.dpTaskType == "Self") {
              return true;
            }
            return false;
          },
        ).toList();
        //open filter
        teamFilter2 = list33.where((d) {
          if (d.dp_status.toString() == "1" && d.dpTaskType == "Self") {
            return true;
          }
          return false;
        }).toList();
        //progress filter
        teamFilter3 = list33.where((d) {
          if (d.dp_status.toString() == "2" && d.dpTaskType == "Self") {
            return true;
          }
          return false;
        }).toList();
        //closed filter
        teamFilter4 = list33.where((d) {
          if (d.dp_status.toString() == "3" && d.dpTaskType == "Self") {
            return true;
          }
          return false;
        }).toList();

        todayT = teamFilter1.length.toString();
        openT = teamFilter2.length.toString();
        progressT = teamFilter3.length.toString();
        closedT = teamFilter4.length.toString();

        if (_color1 == true) {
          setState(() {
            list2 = teamFilter1;
          });
        } else if (_color2 == true) {
          setState(() {
            list2 = teamFilter2;
          });
        } else if (_color3 == true) {
          setState(() {
            list2 = teamFilter3;
          });
        } else if (_color4 == true) {
          setState(() {
            list2 = teamFilter4;
          });
        }
      } else {
        //rl
        // list2.clear();
        // teamFilter1 = list33.where(
        //   (d) {
        //     DateTime dt = DateTime.parse(d.dp_created_date.toString());

        //     if (DateFormat("yyyy-MM-dd").format(dt) == timeCheck &&
        //         d.dpTaskType == "Team" &&
        //         d.dp_given_by != profilename ) {
        //       return true;
        //     }
        //     return false;
        //   },
        // ).toList();
        // //open filter
        // teamFilter2 = list33.where((d) {
        //   if (d.dp_status.toString() == "1" &&
        //       d.dpTaskType == "Team" &&
        //       d.dp_given_by != profilename ) {
        //     return true;
        //   }
        //   return false;
        // }).toList();
        // //progress filter
        // teamFilter3 = list33.where((d) {
        //   if (d.dp_status.toString() == "2" &&
        //       d.dpTaskType == "Team" &&
        //       d.dp_given_by != profilename) {
        //     return true;
        //   }
        //   return false;
        // }).toList();
        // //closed filter
        // teamFilter4 = list33.where((d) {
        //   if (d.dp_status.toString() == "3" &&
        //       d.dpTaskType == "Team" &&
        //       d.dp_given_by != profilename ) {
        //     return true;
        //   }
        //   return false;
        // }).toList();

        // todayT = teamFilter1.length.toString();
        // openT = teamFilter2.length.toString();
        // progressT = teamFilter3.length.toString();
        // closedT = teamFilter4.length.toString();

        // if (_color1 == true) {
        //   setState(() {
        //     list2 = teamFilter1;
        //   });
        // } else if (_color2 == true) {
        //   setState(() {
        //     list2 = teamFilter2;
        //   });
        // } else if (_color3 == true) {
        //   setState(() {
        //     list2 = teamFilter3;
        //   });
        // } else if (_color4 == true) {
        //   setState(() {
        //     list2 = teamFilter4;
        //   });
        // }
      }
    } else if (projectTasks == true) {
      //today
      list3 = list22.where((d) {
        DateTime dt = DateTime.parse(d.dp_created_date.toString());
        if (DateFormat("yyyy-MM-dd").format(dt) == timeCheck) {
          return true;
        }
        return false;
      }).toList();
      //open
      list4 = list22.where((d) {
        if (d.dp_status.toString() == "1") {
          return true;
        }
        return false;
      }).toList();
      //progress
      list5 = list22.where((d) {
        if (d.dp_status.toString() == "2") {
          return true;
        }
        return false;
      }).toList();
      //closed
      list6 = list22.where((d) {
        if (d.dp_status.toString() == "3") {
          return true;
        }
        return false;
      }).toList();
      //

      //
      todayT = list3.length.toString();
      openT = list4.length.toString();
      progressT = list5.length.toString();
      closedT = list6.length.toString();

      if (_color1 == true) {
        setState(() {
          list2 = list3;
        });
      } else if (_color2 == true) {
        setState(() {
          list2 = list4;
        });
      } else if (_color3 == true) {
        setState(() {
          list2 = list5;
        });
      } else if (_color4 == true) {
        setState(() {
          list2 = list6;
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
            RefreshIndicator(
              child: Container(
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
              onRefresh: () async {
                getTaskPlanner(uidd);
              },
            ),
            teamTasks
                ? RefreshIndicator(
                    child: Container(
                      margin: EdgeInsets.only(left: 60, right: 5, top: 60),
                      child: StaggeredGridView.count(
                        crossAxisCount: 6,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 1, top: 1),
                            child: assignbyTeam(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 1, top: 1),
                            child: assignforTeam(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 1, top: 1),
                            child: assingbyRL(),
                          ),
                        ],
                        staggeredTiles: [
                          StaggeredTile.extent(2, 45.0),
                          StaggeredTile.extent(2, 45.0),
                          StaggeredTile.extent(2, 45.0),
                        ],
                      ),
                    ),
                    onRefresh: () async {
                      getTaskPlanner(uidd);
                    },
                  )
                : Container(),
            RefreshIndicator(
              child: Container(
                margin: EdgeInsets.only(
                    left: 60, right: 5, top: teamTasks ? 110 : 60),
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
              onRefresh: () async {
                getTaskPlanner(uidd);
              },
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 60, right: 2, top: teamTasks ? 190 : 140),
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
            } else if (_color1 == false) {
              _color2 = !_color2;
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
            } else if (_color2 == false) {
              _color3 = !_color3;
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
            } else if (_color3 == false) {
              _color4 = !_color4;
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
            } else if (_color4 == false) {
              _color1 = !_color1;
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

  Material assingbyRL() {
    return Material(
      color: rlTeam ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: rlTeam ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            rlTeam = !rlTeam;
            checkServices();
            if (forTeam == true) {
              forTeam = !forTeam;
              checkServices();
            } else if (byTeam == true) {
              byTeam = !byTeam;
              checkServices();
            } else if (rlTeam == false) {
              byTeam = !byTeam;
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
                        "Assinged By RL",
                        style: TextStyle(
                          fontSize: 8.0,
                          fontFamily: "Roboto",
                          color: rlTeam ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(1.0),
                    //   child: Text(
                    //     "RL".toUpperCase(),
                    //     style: TextStyle(
                    //       fontSize: 12.0,
                    //       fontFamily: "Roboto",
                    //       color: rlTeam ? Colors.white : lwtColor,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material assignbyTeam() {
    return Material(
      color: byTeam ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: byTeam ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            byTeam = !byTeam;
            checkServices();
            if (forTeam == true) {
              forTeam = !forTeam;
              checkServices();
            } else if (rlTeam == true) {
              rlTeam = !rlTeam;
              checkServices();
            } else if (byTeam == false) {
              forTeam = !forTeam;
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
                        "Assinged By Team",
                        style: TextStyle(
                          fontSize: 8.0,
                          fontFamily: "Roboto",
                          color: byTeam ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(1.0),
                    //   child: Text(
                    //     "Team".toUpperCase(),
                    //     style: TextStyle(
                    //       fontSize: 12.0,
                    //       fontFamily: "Roboto",
                    //       color: byTeam ? Colors.white : lwtColor,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material assignforTeam() {
    return Material(
      color: forTeam ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: forTeam ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            forTeam = !forTeam;
            if (rlTeam == true) {
              rlTeam = !rlTeam;
              checkServices();
            } else if (byTeam == true) {
              byTeam = !byTeam;
              checkServices();
            } else if (forTeam == false) {
              rlTeam = !rlTeam;
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
                        "Assinged For Team",
                        style: TextStyle(
                          fontSize: 8.0,
                          fontFamily: "Roboto",
                          color: forTeam ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(1.0),
                    //   child: Text(
                    //     "Team".toUpperCase(),
                    //     style: TextStyle(
                    //       fontSize: 12.0,
                    //       fontFamily: "Roboto",
                    //       color: forTeam ? Colors.white : lwtColor,
                    //     ),
                    //   ),
                    // ),
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
    var response;
    try {
      response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["assignedTo"],
            "parameter1": "GetAllSelfTasks",
            "parameter2": uiddd.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          list11 = (json.decode(response.data) as List)
              .map((data) => new TaskListModel.fromJson(data))
              .toList();
          _isloading = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }

      response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["assignedTo"],
            "parameter1": "GetAllTeamTasks",
            "parameter2": uiddd.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          list33 = (json.decode(response.data) as List)
              .map((data) => new TaskListModel.fromJson(data))
              .toList();
          _isloading = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }
      response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "GetAllProjectsTasks",
            "parameter2": uiddd.toString(),
            "parameter3": profilename
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          list22 = (json.decode(response.data) as List)
              .map((data) => new TaskListModel.fromJson(data))
              .toList();
          print(list22.toString());
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
        throw Exception("Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  taskListView() {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0, top: 0),
      child: ListView.builder(
        itemCount: list2?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.only(left: 0, right: 0, top: 6),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Task Name",
                              style:
                                  TextStyle(fontSize: 7, color: Colors.black),
                            ),
                            Text(
                              list2[index]?.dp_task.toString() ?? "",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Reference No.",
                                style:
                                    TextStyle(fontSize: 7, color: Colors.black),
                              ),
                              Text(
                                "EDP_" + list2[index]?.dp_id.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Created Date",
                                style:
                                    TextStyle(fontSize: 7, color: Colors.black),
                              ),
                              Text(
                                displayDateFormat(list2[index]?.dp_created_date)
                                        .toString() ??
                                    "",
                                style: TextStyle(
                                    color: lwtColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Assigned By",
                                style:
                                    TextStyle(fontSize: 7, color: Colors.black),
                              ),
                              Text(
                                list2[index]?.assignedBy[0].toUpperCase() +
                                        list2[index].assignedBy.substring(1) ??
                                    "",
                                style: TextStyle(
                                    color: lwtColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Assigned To",
                                style:
                                    TextStyle(fontSize: 7, color: Colors.black),
                              ),
                              Text(
                                // displayDateFormat(list2[index]?.dp_created_date)
                                //         .toString() ??
                                list2[index]?.assignedTo ?? "",
                                style: TextStyle(
                                    color: lwtColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      myTasks
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Actual Start Date & Time",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      displayDateTimeFormat(
                                              list2[index]?.startDate) ??
                                          "",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Actual End Date & Time",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      displayDateTimeFormat(
                                              list2[index]?.endDate) ??
                                          "",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          teamTasks
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Task Type",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      list2[index]?.dpTaskType ?? "",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          _color4
                              ? Container()
                              : SizedBox(
                                  height: 30,
                                  width: 70,
                                  child: Material(
                                    elevation: 2.0,
                                    shadowColor: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: lwtColor,
                                    child: MaterialButton(
                                      height: 22.0,
                                      padding: EdgeInsets.all(3),
                                      child: Text(
                                        "View",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        onClickForStatus(list2[index]);
                                      },
                                    ),
                                  ),
                                )
                        ],
                      )
                    ],
                  ),
                ),
                color: Colors.white,
              ));
        },
      ),
    );
  }

  displayDateFormat(String elFromDate) {
    List<String> a = elFromDate.split("-");
    return a[2] + "-" + a[1] + "-" + a[0];
  }

  displayDateTimeFormat(String date) {
    if (date != null) {
      String newDate = date.toString();
      List<String> d = [];
      d = newDate.split(".");
      // print(d[0]);

      return d[0].toString().split(" ")[0].toString().split("-")[2].toString() +
          "-" +
          d[0].toString().split(" ")[0].toString().split("-")[1].toString() +
          "-" +
          d[0].toString().split(" ")[0].toString().split("-")[0].toString() +
          " " +
          d[0].toString().split(" ")[1].toString();
    } else {
      return "";
    }
    return "";
  }

  onClickForStatus(TaskListModel list2) {
    if (myTasks == true) {
      if (_color1 == true || _color2 == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TaskPlannerEdit(
                      list2.dp_task.toString(),
                      list2.dp_task_desc.toString(),
                      list2.dp_id.toString(),
                    )));
      } else if (_color3 == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TaskPlannerEdit(
                      list2.dp_task.toString(),
                      list2.dp_task_desc.toString(),
                      list2.dp_id.toString(),
                    )));
      }
    } else if (teamTasks == true) {
      if (_color1 == true || _color2 == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TaskPlannerEdit(
                      list2.dp_task.toString(),
                      list2.dp_task_desc.toString(),
                      list2.dp_id.toString(),
                    )));
      } else if (_color3 == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TaskPlannerEdit(
                      list2.dp_task.toString(),
                      list2.dp_task_desc.toString(),
                      list2.dp_id.toString(),
                    )));
      }
    } else if (projectTasks == true) {
      if (_color1 == true || _color2 == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TaskPlannerEdit(
                      list2.dp_task.toString(),
                      list2.dp_task_desc.toString(),
                      list2.dp_id.toString(),
                    )));
      } else if (_color3 == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TaskPlannerEdit(
                      list2.dp_task.toString(),
                      list2.dp_task_desc.toString(),
                      list2.dp_id.toString(),
                    )));
      }
    }
  }
}
