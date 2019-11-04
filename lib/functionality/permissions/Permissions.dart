import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/activity/HomePage.dart';
import 'package:eaglebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:eaglebiz/functionality/permissions/NewLeave.dart';
import 'package:eaglebiz/functionality/permissions/NewPermission.dart';
import 'package:eaglebiz/model/LateEarlyComingModel.dart';
import 'package:eaglebiz/model/LeavesModel.dart';
import 'package:eaglebiz/model/PermissionModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';


class Permissions extends StatefulWidget {
  @override
  _PermissionsState createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  ProgressDialog pr;
  bool _color1,_color2,_color3,_color4;
  TextEditingController _controllerReason=TextEditingController();
  bool leaves,permissions,latecoming,earlygoing,lateearly;

  List<LeavesModel> leavesList=new List();
  List<LeavesModel> list2=new List();
  List<LeavesModel> list3=new List();
  List<LeavesModel> list4=new List();
  List<LeavesModel> list5=new List();
  List<LeavesModel> list6=new List();

  List<PermissionModel> permissionsList=new List();
  List<PermissionModel> list22=new List();
  List<PermissionModel> list33=new List();
  List<PermissionModel> list44=new List();
  List<PermissionModel> list55=new List();
  List<PermissionModel> list66=new List();

  List<LateEarlyComingModel> latecomingList=new List();
  List<LateEarlyComingModel> list222=new List();
  List<LateEarlyComingModel> list333=new List();
  List<LateEarlyComingModel> list444=new List();
  List<LateEarlyComingModel> list555=new List();
  List<LateEarlyComingModel> list666=new List();

  List<LateEarlyComingModel> earlygoingList=new List();
  List<LateEarlyComingModel> list2222=new List();
  List<LateEarlyComingModel> list3333=new List();
  List<LateEarlyComingModel> list4444=new List();
  List<LateEarlyComingModel> list5555=new List();
  List<LateEarlyComingModel> list6666=new List();



  String uuid,profilename,employCode;
  var _isEditButton=false;
  bool _isloading=false;
  static Dio dio = Dio(Config.options);
  String pendingCount="-",approvedCount="-",cancelledCount="-",rejectedCount="-";
  static  var now = DateTime.now();
  Future<String> getUserID() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String id=preferences.getString("userId");
    return id;
  }
  getAccountDetails() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    employCode = preferences.getString("uEmpCode");
    profilename = preferences.getString("profileName");
    print(employCode.toString()+"-"+profilename);
  }
  @override
  void initState() {
    super.initState();
    _color1 = true;
    _color2 = false;
    _color3 = false;
    _color4 = false;
    leaves=true;
    permissions=false;
    latecoming=false;
    earlygoing=false;
    lateearly=false;
    getAccountDetails();
    getUserID().then((val)=>setState((){
      uuid=val;
      getDataLeaves_Permissions();
    }));

  }

  void checkServices() {
    if(leaves==true){
      lateearly=false;
      //pending
      list3 =  leavesList.where((d) {
        if (d.el_status.toString() == "1") {
          return true;
        }
        return false;
      }).toList();
      //approved
      list4 =  leavesList.where((d) {
        if (d.el_status.toString() == "2") {
          return true;
        }
        return false;
      }).toList();
      //cancelled
      list5 =  leavesList.where((d) {
        if (d.el_status.toString() == "0") {
          return true;
        }
        return false;
      }).toList();

      //rejected
      list6 =  leavesList.where((d) {
        if (d.el_status.toString() == "3") {
          return true;
        }
        return false;
      }).toList();

      //
      setState(() {
        pendingCount=list3?.length.toString()??"-";
        approvedCount=list4?.length.toString()??"-";
        cancelledCount=list5?.length.toString()??"-";
        rejectedCount=list6?.length.toString()??"-";
      });

      if(_color1==true){
        setState(() {
          _isEditButton=true;
          list2=list3;
        });
      }else if(_color2==true){
        setState(() {
          _isEditButton=false;
          list2=list4;
        });
      }else if(_color3==true){
        setState(() {
          _isEditButton=false;
          list2=list5;
        });
      }else if(_color4==true){
        setState(() {
          _isEditButton=false;
          list2=list6;
        });
      }
    }else if(permissions==true){
      lateearly=false;

      //pending
      list33 =  permissionsList.where((d) {
        if (d.per_status.toString() == "1" ) {
          return true;
        }
        return false;
      }).toList();
      //approved
      list44 =  permissionsList.where((d) {
        if (d.per_status.toString() == "2") {
          return true;
        }
        return false;
      }).toList();
      //cancelled
      list55 =  permissionsList.where((d) {
        if (d.per_status.toString() == "0") {
          return true;
        }
        return false;
      }).toList();

      //rejected
      list66 =  permissionsList.where((d) {
        if (d.per_status.toString() == "3") {
          return true;
        }
        return false;
      }).toList();

      //
      setState(() {
        pendingCount=list33?.length.toString()??"-";
        approvedCount=list44?.length.toString()??"-";
        cancelledCount=list55?.length.toString()??"-";
        rejectedCount=list66?.length.toString()??"-";
      });
      if(_color1==true){
        setState(() {
          _isEditButton=true;
          list22=list33;
        });
      }else if(_color2==true){
        setState(() {
          _isEditButton=false;
          list22=list44;
        });
      }else if(_color3==true){
        setState(() {
          _isEditButton=false;
          list22=list55;
        });
      }else if(_color4==true){
        setState(() {
          _isEditButton=false;
          list22=list66;
        });
      }
    }else if(latecoming==true){
      lateearly=true;
      list333 =  latecomingList.where((d) {
        if (d.att_id == "-" ) {
          return true;
        }
        return false;
      }).toList();
      list444 =  latecomingList.where((d) {
        if (d.att_id !="-"  && d.hr_approval!="1" && d.hr_approval!="2" && d.tl_approval!="1" && d.tl_approval!="2") {
          return true;
        }
        return false;
      }).toList();

      list555 =  latecomingList.where((d) {
        if ( d.hr_approval=="2") {
          return true;
        }
        return false;
      }).toList();

      list666 =  latecomingList.where((d) {
        if ( d.hr_approval=="1" ) {
          return true;
        }
        return false;
      }).toList();

      setState(() {
        pendingCount=list333?.length.toString()??"-";
        approvedCount=list444?.length.toString()??"-";
        cancelledCount=list555?.length.toString()??"-";
        rejectedCount=list666?.length.toString()??"-";
      });

      if(_color1==true){
        setState(() {
          _isEditButton=true;
          list222=list333;
        });
      } else if(_color2==true){
        setState(() {
          _isEditButton=false;
          list222=list444;
        });
      } else if(_color3==true){
        setState(() {
          _isEditButton=false;
          list222=list555;
        });
      }else if(_color4==true){
        setState(() {
          _isEditButton=false;
          list222=list666;
        });
      }
    }else if(earlygoing==true){
      lateearly=true;
      latecoming=false;
      list3333 =  earlygoingList.where((d) {
        if (d.att_id == "-"  && d.hr_approval!="1" && d.hr_approval!="2" && d.tl_approval!="1" && d.tl_approval!="2") {
          return true;
        }
        return false;
      }).toList();

      list4444 =  earlygoingList.where((d) {
        if (d.att_id !="-" && d.hr_approval!="1" && d.hr_approval!="2" && d.tl_approval!="1" && d.tl_approval!="2" && d.att_work_status!="Absent") {
          return true;
        }
        return false;
      }).toList();

      list5555 =  earlygoingList.where((d) {
        if (d.hr_approval=="2") {
          return true;
        }
        return false;
      }).toList();

      list6666 =  earlygoingList.where((d) {
        if (d.hr_approval=="1") {
          return true;
        }
        return false;
      }).toList();

      setState(() {
        pendingCount=list3333?.length.toString()??"-";
        approvedCount=list4444?.length.toString()??"-";
        cancelledCount=list5555?.length.toString()??"-";
        rejectedCount=list6666?.length.toString()??"-";
      });
      if(_color1==true){
        setState(() {
          _isEditButton=true;
          list2222=list3333;
        });
      } else if(_color2==true){
        setState(() {
          _isEditButton=false;
          list2222=list4444;
        });
      } else if(_color3==true){
        setState(() {
          _isEditButton=false;
          list2222=list5555;
        });
      }else if(_color4==true){
        setState(() {
          _isEditButton=false;
          list2222=list6666;
        });
      }
    }
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
        navigator.push(
          // ignore: missing_return
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          // ignore: missing_return
          // ModalRoute.withName('/'),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Leaves & Permission",style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color:Colors.white),
//        leading: Icon(Icons.monetization_on,color: Colors.white,),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(leaves==true){
              var navigator = Navigator.of(context);
              navigator.push(
                MaterialPageRoute(builder: (BuildContext context) => NewLeave()),
//                          ModalRoute.withName('/'),
              );
            }else if(permissions==true){
              var navigator = Navigator.of(context);
              navigator.push(
                MaterialPageRoute(builder: (BuildContext context) => NewPermissions()),
//                          ModalRoute.withName('/'),
              );
            }
            // Add your onPressed code here!
          },
          child: Icon(Icons.add),
          backgroundColor: lwtColor,
        ),
        body: Stack(
          children: <Widget>[
            Container(color: Colors.white,),
            Container(
              margin: EdgeInsets.only(left: 60,right: 5,top: 6),
              child: StaggeredGridView.count(crossAxisCount: 4,crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  leavesM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  permissionsM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  latecomingM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  earlygoingM(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 45.0),
                  StaggeredTile.extent(2, 45.0),
                  StaggeredTile.extent(2, 45.0),
                  StaggeredTile.extent(2, 45.0),
                ],),
            ),
            Container(
              margin: EdgeInsets.only(left: 60,right: 5,top: 115),
              child: StaggeredGridView.count(crossAxisCount: 8,crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  dashboard1(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  dashboard2(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  dashboard3(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  dashboard4(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 85.0),
                  StaggeredTile.extent(2, 85.0),
                  StaggeredTile.extent(2, 85.0),
                  StaggeredTile.extent(2, 85.0),
                ],),
            ),
            leaves ? Container(
              margin: EdgeInsets.only(left: 60, right: 2, top: 210),
              child:  leavesListView(),
            ):Container(),
            permissions ? Container(
              margin: EdgeInsets.only(left: 60, right: 2, top: 210),
              child:  permissionsListView(),
            ):Container(),
            latecoming ? Container(
              margin: EdgeInsets.only(left: 60, right: 2, top: 210),
              child:  latecomingListView(),
            ):Container(),
            earlygoing ? Container(
              margin: EdgeInsets.only(left: 60, right: 2, top: 210),
              child:  earlygoingListView(),
            ):Container(),

            CollapsingNavigationDrawer("4"),
            //ListView.builder(itemBuilder: null)
          ],
        ),
      ),
    );
  }


  Material dashboard1( ) {
    return Material(
      color: _color1 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color1 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
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
                      child:Text("Pending".toUpperCase(),style:TextStyle(
                        fontSize: 10.0,fontFamily: "Roboto",
                        color: _color1 ?  Colors.white : lwtColor,
                        //Color(0xFF272D34),
                      ),),
                    ),

                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text(pendingCount,style:TextStyle(
                          fontSize: 30.0,fontFamily: "Roboto",
                          color: _color1 ?  Colors.white : lwtColor
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

  Material dashboard2( ) {
    return Material(
      color: _color2 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color2 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
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
                      child:Text(lateearly ? "Applied".toUpperCase(): "Approved".toUpperCase(),style:TextStyle(
                        fontSize: 10.0,fontFamily: "Roboto",
                        color: _color2 ? Colors.white : lwtColor,
                      ),),
                    ),

                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text(approvedCount,style:TextStyle(
                        fontSize: 30.0,fontFamily: "Roboto",
                        color: _color2 ?  Colors.white : lwtColor,
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
  Material dashboard3( ) {
    return Material(
      color: _color3 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color3 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
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
                      child:Text(lateearly ? "Rejected".toUpperCase() :"Cancelled".toUpperCase(),style:TextStyle(
                        fontSize: 10.0,fontFamily: "Roboto",
                        color: _color3 ? Colors.white : lwtColor,
                      ),),
                    ),

                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text(cancelledCount,style:TextStyle(
                        fontSize: 30.0,fontFamily: "Roboto",
                        color: _color3 ?  Colors.white : lwtColor,
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
  Material dashboard4( ) {
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
                      padding: EdgeInsets.all(2.0),
                      child:Text(lateearly ? "Approved".toUpperCase() :"Rejected".toUpperCase(),style:TextStyle(
                        fontSize: 10.0,fontFamily: "Roboto",
                        color: _color4 ? Colors.white : lwtColor,
                      ),),
                    ),

                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text(rejectedCount,style:TextStyle(
                        fontSize: 30.0,fontFamily: "Roboto",
                        color: _color4 ?  Colors.white : lwtColor,
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

  Material leavesM() {
    return Material(
      color: leaves ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: leaves ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            leaves = !leaves;
            checkServices();
            if(permissions==true){
              permissions=!permissions;
              checkServices();
            }else if(latecoming==true){
              latecoming=!latecoming;
              checkServices();
            }else if(earlygoing==true){
              earlygoing=!earlygoing;
              checkServices();
            }else if(leaves==false){
              permissions=!permissions;
              checkServices();
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
                      child:Text("Leaves".toUpperCase(),style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: leaves ? Colors.white : lwtColor,
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

  Material permissionsM() {
    return Material(
      color: permissions ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: permissions ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            permissions = !permissions;
            checkServices();
            if(latecoming==true){
              latecoming=!latecoming;
              checkServices();
            }else if(earlygoing==true){
              earlygoing=!earlygoing;
              checkServices();
            }else if(leaves==true){
              leaves=!leaves;
              checkServices();
            }else if(permissions==false){
              latecoming=!latecoming;
              checkServices();
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
                      child:Text("Permissions".toUpperCase(),style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: permissions ? Colors.white : lwtColor,
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



  Material latecomingM() {
    return Material(
      color: latecoming ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: latecoming ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            latecoming = !latecoming;
            checkServices();
            if(earlygoing==true){
              earlygoing=!earlygoing;
              checkServices();
            }else if(leaves==true){
              leaves=!leaves;
              checkServices();
            }else if(permissions==true){
              permissions=!permissions;
              checkServices();
            }else if(latecoming==false){
              earlygoing=!earlygoing;
              checkServices();
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
                      child:Text("Late Coming".toUpperCase(),style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: latecoming ? Colors.white : lwtColor,
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
  Material earlygoingM() {
    return Material(
      color: earlygoing ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: earlygoing ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            earlygoing = !earlygoing;
            checkServices();
            if(leaves==true){
              leaves=!leaves;
              checkServices();
            }else if(permissions==true){
              permissions=!permissions;
              checkServices();
            }else if(latecoming==true){
              latecoming=!latecoming;
              checkServices();
            }else if(earlygoing==false){
              leaves=!leaves;
              checkServices();
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
                      child:Text("Early Going".toUpperCase(),style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: earlygoing ? Colors.white : lwtColor,
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

  leavesListView() {
    return ListView.builder(
        itemCount: list2 == null ? 0 : list2.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: InkWell(
                child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(checkApprovalStatus(list2[index].el_approvedby) ,style: TextStyle(color: lwtColor),),
                            ),
                            ListTile(
                              leading: Container(
                                padding: EdgeInsets.only(right: 14.0,top: 1.0),
                                decoration: BoxDecoration(
                                    border:
                                    Border(right: BorderSide(width: 1.0, color: Colors.grey))),
                                width: 50,
                                child:Column(
                                children: <Widget>[
                                  Text("No. Days: ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                  Text(checkNoDays(list2[index]?.el_noofdays.toString()).toString() ?? 'NA' ,
                                    style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                              ),

                              title: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("From Date  :  ",style: TextStyle(fontSize: 10,color: Colors.black),),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                        ),
                                        Text(displayDateFormat(list2[index]?.el_from_date) ?? 'NA',
                                          style: TextStyle(
                                            color: lwtColor,
                                            fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("To Date       :  ",style: TextStyle(fontSize: 10,color: Colors.black),),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                        ),
                                        Text(displayDateFormat(list2[index]?.el_to_date) ?? 'NA',
                                          style: TextStyle(
                                            color: lwtColor,
                                            fontSize: 10,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ) ,
                              trailing: _isEditButton ? IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  cancelLeavesAlertDialog(list2[index],1);
                                },
                              ): IconButton(icon:Icon(Icons.visibility_off),onPressed: (){
                                //
                              },),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ));
        });
  }

  permissionsListView() {
    return ListView.builder(
        itemCount: list22 == null ? 0 : list22.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: InkWell(
                child: Container(
                  /* decoration: BoxDecoration(border: Border.all(color: lwtColor,width: 1),
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(5.0), topRight: const Radius.circular(5.0),bottomLeft: const Radius.circular(5.0), bottomRight: const Radius.circular(5.0),
                        )),*/
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: <Widget>[
                          Text(list22[index]?.per_approved_by??"" ,style: TextStyle(color: lwtColor),),
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.only(right: 20.0),
                              decoration: BoxDecoration(
                                  border:
                                  Border(right: BorderSide(width: 1.0, color: Colors.grey))),
                              width: 50,
                              child: Column(
                                children: <Widget>[
                                  Text(getDateMethod(list22[index]?.per_date??"Na","1"),style: TextStyle(color: lwtColor,fontSize: 25,fontWeight: FontWeight.bold),),
                                  Text(getDateMethod(list22[index]?.per_date??"Na","2"),style: TextStyle(fontSize: 8,),),
                                  Text(getDateMethod(list22[index]?.per_date??"Na","3"),style: TextStyle(fontSize: 8,)),
                                ],
                              ),
                            ),
                            title: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Text("From Time  : ",style: TextStyle(color: Colors.black,fontSize: 10),),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4),
                                    ),
                                    Text(
                                      list22[index]?.per_from_time ?? 'NA',
                                      style: TextStyle(
                                          color: lwtColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("To Time       : ",style: TextStyle(color: Colors.black,fontSize: 10),),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                      ),
                                      Text(
                                        list22[index]?.per_to_time ?? 'NA',
                                        style: TextStyle(
                                          color: lwtColor,
                                          fontSize: 10, fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            trailing: _isEditButton ? IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                cancelPermissionsAlertDialog(list22[index],2);
                              },
                            ): IconButton(icon:Icon(Icons.visibility_off),onPressed: (){
                              //
                            },),
                          ),
                        ],
                      ),
                    )),
              ));
        });
  }
  latecomingListView() {
    return ListView.builder(
        itemCount: list222 == null ? 0 : list222.length,
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("In Time    :   ",style: TextStyle(color:Colors.black,fontSize: 8),),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                ),
                                Text(list222[index]?.att_tour_in_time.toString() ?? 'NA',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                            ),
                            Row(
                              children: <Widget>[
                                Text("Status      :   ",style: TextStyle(color:Colors.black,fontSize: 8),),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                ),
                                Text(list222[index]?.att_work_status.toString() ?? 'NA',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),Padding(
                              padding: EdgeInsets.only(top: 4),
                            ),
                            Row(
                              children: <Widget>[
                                Text("Date        :   ",style: TextStyle(color:Colors.black,fontSize: 8),),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                ),
                                Text(displayDateFormat(list222[index]?.att_date.toString()) ?? 'NA',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                           /* Text(_CheckApprovalStatus(list222[index])?? 'NA',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),*/
                          ],
                        ),
                        trailing: _isEditButton ? IconButton(
                              icon: Icon(
                                Icons.check,
                                color: lwtColor,
                              ),
                              onPressed: () {
                                  if(list222[index].att_id=="-") {
                                    roundedAlertBox(list222[index], 1);
//                                    LateComingReuestServiceCall(list222[index], 1);
                                    }else {
                                    Fluttertoast.showToast(msg: "Already Applied");
                                    }
                              },
                            ): IconButton(icon:Icon(Icons.visibility_off),onPressed: (){
                          //
                        },),

                      ),
                    )),
              ));
        });
  }

  earlygoingListView() {
    return ListView.builder(
        itemCount: list2222 == null ? 0 : list2222.length,
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Out Time    :   ",style: TextStyle(color:Colors.black,fontSize: 8),),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                ),
                                Text(list2222[index]?.att_out_time.toString() ?? "",
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                            ),
                            Row(
                              children: <Widget>[
                                Text("Status         :   ",style: TextStyle(color:Colors.black,fontSize: 8),),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                ),
                                Text(list2222[index]?.att_work_status.toString() ?? 'NA',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),Padding(
                              padding: EdgeInsets.only(top: 4),
                            ),
                            Row(
                              children: <Widget>[
                                Text("Date           :   ",style: TextStyle(color:Colors.black,fontSize: 8),),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                ),
                                Text(displayDateFormat(list2222[index]?.att_date.toString()) ?? 'NA',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: _isEditButton ? IconButton(
                          icon: Icon(
                            Icons.check,
                            color: lwtColor,
                          ),
                          onPressed: () {
                            if(list2222[index].att_id=="-") {
                              roundedAlertBox(list2222[index], 2);
//                              LateComingReuestServiceCall(list222[index], 2);
                            }else {
                              Fluttertoast.showToast(msg: "Already Applied");
                            }
                          },
                        ):IconButton(icon:Icon(Icons.visibility_off),onPressed: (){
                      //
                    },),
                      ),
                    )),
              ));
        });
  }

   getDataLeaves_Permissions() async {
    setState(() {
      _isloading=true;
    });
    Map<String, String> queryParameters = {
      "id": uuid
    };
    try {
      var leavesEmp = await dio.post(ServicesApi.getData,
//          queryParameters: {"id": uuid},
          data: {
            "parameter1": "GetEmpLeaves",
            "parameter2": uuid.toString()
          },
          options: Options(contentType: ContentType.parse('application/json'),)
      );
      if (leavesEmp.statusCode == 200 || leavesEmp.statusCode == 201) {
        setState(() {
          leavesList = (json.decode(leavesEmp.data) as List).map((data) => new LeavesModel.fromJson(data)).toList();
        });
        checkServices();
      }

      //=============================================================

      var permissionsEmp = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "GetAllPermissionByUId",
            "parameter2": uuid.toString()
          },
          options: Options(contentType: ContentType.parse('application/json'),
          ));
      if (permissionsEmp.statusCode == 200 || permissionsEmp.statusCode == 201) {
        setState(() {
          permissionsList = (json.decode(permissionsEmp.data) as List).map((data) => new PermissionModel.fromJson(data)).toList();
        });
        checkServices();
      }

      //==========================================================
      var latecomingEmp = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "getUserLateComingByMonth",
            "parameter2":  employCode.toString()
          },
          options: Options(contentType: ContentType.parse('application/json'),
          ));
      if (latecomingEmp.statusCode == 200 || latecomingEmp.statusCode == 201) {
        setState(() {
          latecomingList =
              (json.decode(latecomingEmp.data) as List).map((data) => new LateEarlyComingModel.fromJson(data)).toList();
//          print(latecomingList.toString());
          _isloading = false;
        });
        checkServices();
      }
      //======================================
      var earlygoingEmp = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "getUserEarlyGoingByMonth",
            "parameter2":  employCode.toString()
          },
          options: Options(contentType: ContentType.parse('application/json'),
          ));
      if (earlygoingEmp.statusCode == 200 || earlygoingEmp.statusCode == 201) {
        setState(() {
          earlygoingList =
              (json.decode(earlygoingEmp.data) as List).map((data) => new LateEarlyComingModel.fromJson(data)).toList();
//          print(earlygoingList.toString());
          _isloading = false;
        });
        checkServices();
      }
    }on DioError catch(exception){
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


  void cancelRequestServiceCall(String leavepermissionId,String leaveType,String noofDays, int i) async {
    pr.show();
    var response;
    try{
      if(i==1) {
        response = await dio.post(ServicesApi.cancelLeave,
            data: {
              "leaveId": leavepermissionId,
              "leaveType": leaveType,
              "modifiedBy": profilename,
              "noOfDays": noofDays,
              "statusId": 0,
              "userId": uuid
            },
            options: Options(contentType: ContentType.parse('application/json'),
            ));
      }else if(i==2){
        response = await dio.post(ServicesApi.cancelPermission,
            data: {
              "modifiedBy": profilename,
              "permissionId": leavepermissionId,
              "remarks": "string",
              "statusId": 0,
            },
            options: Options(contentType: ContentType.parse('application/json'),
            ));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        getDataLeaves_Permissions();
        pr.hide();
        Navigator.pop(context);
      }
    }on DioError catch(exception){
      pr.hide();
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        pr.hide();
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        pr.hide();
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        pr.hide();
        return null;
      }
    }
  }

   LateComingReuestServiceCall(LateEarlyComingModel lateearlycomingList,int i, String reason) async{
    pr.show();

    var response;
    try{
      if(i==1) {
        print( "late : "+lateearlycomingList.att_date.toString());
        response = await dio.put(ServicesApi.lateComing,
            data: {
              "actionMode": "LateComingReqest",
              "date": lateearlycomingList.att_date.toString(),
              "empCode": employCode.toString(),
              "leaveAvailed": "Late Coming",
              "leaves": [
                {
                  "leaveCount": "string",
                  "leaveType": "string"
                }
              ],
              "modifiedBy": profilename.toString(),
              "paidCount": "0",
              "remarks": reason.toString(),
              "userId": "string",
              "workStauts": "string"
            },
            options: Options(contentType: ContentType.parse('application/json'),
            ));

        } else if(i==2){
        print("early : "+ lateearlycomingList.att_date.toString());
        response = await dio.put(ServicesApi.lateComing,
            data: {
              "actionMode": "LateComingReqest",
              "date": lateearlycomingList.att_date.toString(),
              "empCode": employCode.toString(),
              "leaveAvailed": "Early going",
              "leaves": [
                {
                  "leaveCount": "string",
                  "leaveType": "string"
                }
              ],
              "modifiedBy": profilename.toString(),
              "paidCount": "0",
              "remarks": "string",
              "userId": "string",
              "workStauts": "string"
            },
            options: Options(contentType: ContentType.parse('application/json'),
            ));
      }

      print(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {

        getDataLeaves_Permissions();
        pr.hide();
      }
    }on DioError catch(exception){
      pr.hide();
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        pr.hide();
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        pr.hide();
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  // _CheckApprovalStatus(LateEarlyComingModel list222) {
  //   if(list222.att_request_id=="-"){
  //     return 'Apply';
  //   }else {
  //     return 'Already Applied';
  //   }
  // }

   getDateMethod(String created_date,String selectType) {
    List<String> timeStamp=[];
      timeStamp = created_date.split(" ");
      var timeStampSplit = timeStamp[0].toString();
      List<String> dateSplit;
      dateSplit = timeStampSplit.split("-");
      if (selectType == "1") {
        return dateSplit[2].toString();
      } else if (selectType == "2") {
        return dateSplit[1].toString();
      } else if (selectType == "3") {
        return dateSplit[0].toString();
      }
  }

  String checkApprovalStatus(String res) {
    if(res=="0"){
     return "";
    }else{
      return res.substring(0,1).toUpperCase()+res.substring(1).toString();
    }
  }


    roundedAlertBox(LateEarlyComingModel lateearlycomingmodel, int i){
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 4.0),
              content: Container(
                width: 250.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Reason",
                          style: TextStyle(fontSize: 25.0,color: lwtColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextFormField(
                        maxLength: 50,
                        controller: _controllerReason,
                        decoration: InputDecoration(
                          hintText: "Write your Reason",
                          border: InputBorder.none,
                        ),
                        maxLines: 5,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        if(_controllerReason.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please write your reason");
                        }else {
                          Navigator.pop(context);
                          LateComingReuestServiceCall(lateearlycomingmodel, i,_controllerReason.text);

                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          color: lwtColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24.0),
                              bottomRight: Radius.circular(24.0)),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white,fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
  }

  void cancelLeavesAlertDialog(LeavesModel leavesModel, int i) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text('Do you want to cancel your Leave?'),
            content: Container(
              padding: EdgeInsets.only(top: 10,left: 10,right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("From Date      :     ",style: TextStyle(fontSize: 10),),
                        Text(displayDateFormat(leavesModel.el_from_date),style:  TextStyle(color: lwtColor,fontSize: 12,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("To Date           :     ",style: TextStyle(fontSize: 10),),
                        Text(displayDateFormat(leavesModel.el_to_date),style:  TextStyle(color: lwtColor,fontSize: 12,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 4),),
                    Row(
                      children: <Widget>[
                        Text("Reason           :     ",style: TextStyle(fontSize: 10),),
                        Expanded(child: Text(leavesModel.el_reason,style:  TextStyle(color: lwtColor,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              CupertinoButton(
                onPressed: ()  {
                  cancelRequestServiceCall(leavesModel.el_id.toString(),leavesModel.leave_type,leavesModel.el_noofdays.toString(),i);
                },
                child: new Text('Yes'),),
               CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('No'),
              ),

            ],
          );
        });
  }
   cancelPermissionsAlertDialog(PermissionModel permissionModel, int i) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text('Do you want to cancel your Permission?'),
            content: Container(
              padding: EdgeInsets.only(top: 10,left: 10,right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("From Time      :     ",style: TextStyle(fontSize: 10),),
                        Text(permissionModel.per_from_time,style:  TextStyle(color: lwtColor,fontSize: 12,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("To Time           :     ",style: TextStyle(fontSize: 10),),
                        Text(permissionModel.per_to_time,style:  TextStyle(color: lwtColor,fontSize: 12,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 4),),
                    Row(
                      children: <Widget>[
                        Text("Reason             :     ",style: TextStyle(fontSize: 10),),
                        Expanded(
                            child: Text(permissionModel.per_purpose,
                                style:  TextStyle(color: lwtColor,fontSize: 12,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,softWrap: true,overflow: TextOverflow.fade,),
                            ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              CupertinoButton(
                onPressed: ()  {
                  cancelRequestServiceCall(permissionModel.per_id.toString(),"","",i);
                },
                child: new Text('Yes'),),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('No'),
              ),

            ],
          );
        });
  }

   displayDateFormat(String el_from_date) {
    List<String> a=el_from_date.split("-");
    return a[2]+"-"+a[1]+"-"+a[0];
  }

  checkNoDays(String noodDays) {
    List data=noodDays.split(".");
//    return (int.parse(data[0].toString())+int.parse(1.toString())).toString();
  return data[0].toString();
  }

}
