import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/taskPlanner/Members.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/SalesPendingModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchDownTeam extends StatefulWidget {
  @override
  _SearchDownTeamState createState() => _SearchDownTeamState();
}

class _SearchDownTeamState extends State<SearchDownTeam> {

  var choosePerson ="Select Member";
  int pending=0,completed=1;
  bool _color1,_color2;
  String uidd,resourceId;
  bool _listDisplay=true,_dashboards=false;
  List<SalesPendingModel> listpending,listcompleted = [];
  String pendingCount='-',completedCount='-';
  static Dio dio = Dio(Config.options);


  void checkServices() {
    if (_color1 == true) {
      pendingListM(resourceId);
    } else if (_color2 == true) {
      completedListM(resourceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sales Lead By DownTeam",style: TextStyle(color: Colors.white),),
      iconTheme: IconThemeData(color:Colors.white),),
      body: Stack(
        children: <Widget>[
          Container(color: Colors.white,),
          Container(
            margin: EdgeInsets.only(left: 2,right: 2,top: 5),child: ListTile(
            title: TextFormField(
              enabled: false,
              controller: TextEditingController(text: choosePerson[0].toUpperCase()+choosePerson.substring(1)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.chrome_reader_mode),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            trailing: IconButton(icon: Icon(Icons.search,color: lwtColor,),
              onPressed: (){
                _navigateMemeberMethod(context);
              },),
          ),),
          _dashboards ? Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 80),
            child: StaggeredGridView.count(crossAxisCount: 4,crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 2,left: 2),
                  child:  dashboard1(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 2,top: 2),
                  child:  dashboard2(),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 70.0),
                StaggeredTile.extent(2, 70.0),
              ],),
          ):Container(),
          Container(
            margin: EdgeInsets.only(left: 10,right: 2,top: 160),
            child: _listDisplay ? pendingListView() : completedListView() ,
          ),
          //ListView.builder(itemBuilder: null)
        ],
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
        onTap: (){
          setState(() {
            _color1 = !_color1;
            if(_color1==true){
              _color2=!_color2;
              _listDisplay=!_listDisplay;
              checkServices();
            }else if(_color1==false){
              _color2=!_color2;
              _listDisplay=!_listDisplay;
              checkServices();
            }
          });

        },
        child: Center(
          child:Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child:Text("Pending",style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: _color1 ?  Colors.white : lwtColor,
                        //Color(0xFF272D34),
                      ),),
                    ),

                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text(pendingCount,style:TextStyle(
                          fontSize: 20.0,fontFamily: "Roboto",
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

  Material dashboard2() {
    return Material(
      color: _color2 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color2 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            _color2 = !_color2;
            if(_color2==true){
              _color1=!_color1;
              _listDisplay=!_listDisplay;
              checkServices();
            }else if(_color2==false){
              _color1=!_color1;
              _listDisplay=!_listDisplay;
              checkServices();
            }
          });
        },
        child: Center(
          child:Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child:Text("Completed",style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: _color2 ? Colors.white : lwtColor,
                      ),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text(completedCount,style:TextStyle(
                        fontSize: 20.0,fontFamily: "Roboto",
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


  pendingListM(String resourceId) async {
    try {
      var response = await dio.post(ServicesApi.Pending_Url,
          data: {"actionMode": "GetSaleRequestListByUserId", "refId": resourceId.toString()},
          options: Options(contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          listpending = (json.decode(response.data) as List)
              .map((data) => new SalesPendingModel.fromJson(data))
              .toList();
          pendingCount=listpending?.length.toString()??'-';

          completedListM(resourceId);
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }
    }on DioError catch (exception) {
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

  //  Service Call of Completed List
  completedListM(String resourceId) async {
    try {
      var response = await dio.post(ServicesApi.Pending_Url,
          data: {
            "actionMode": "GetClosedSaleRequestByUId",
            "refId": resourceId.toString()
          },
          options: Options(contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          listcompleted = (json.decode(response.data) as List)
              .map((data) => new SalesPendingModel.fromJson(data))
              .toList();
          completedCount=listcompleted?.length.toString()??'-';

        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }
    }on DioError catch (exception) {
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

  pendingListView() {
    return ListView.builder(
        itemCount: listpending ==null ? 0: listpending.length,
        itemBuilder: (BuildContext context,int index){
          return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 6.0),
              child: InkWell(
                child: Container(
                  /* decoration: BoxDecoration(border: Border.all(color: lwtColor,width: 1),
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(5.0), topRight: const Radius.circular(5.0),bottomLeft: const Radius.circular(5.0), bottomRight: const Radius.circular(5.0),
                        )),*/
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(listpending[index]?.srNo ?? 'NA',
                              style: TextStyle(
                                  color: lwtColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 6),),
                            Row(
                              children: <Widget>[
                                Icon(Icons.person,size: 12,color: lwtColor,),
//                                Text("Name                :     ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(left: 8,),),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(listpending[index]?.srCustomerName ?? 'NA',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 2),),
                            Row(
                              children: <Widget>[
                                Icon(Icons.email,size: 12,color: lwtColor,),
//                                Text("Email                :     ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(left: 8),),
                                Text(listpending[index]?.srContactEmail ?? ''+"NA.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 2),),
                            Row(
                              children: <Widget>[
                                Icon(Icons.phone_android,size: 12,color: lwtColor,),
//                                Text("Number           :      ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(left: 8),),
                                Text(listpending[index]?.srPhoneNo ?? ''+"NA.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 2),),
                            Row(
                              children: <Widget>[
                                Icon(Icons.group_add,size: 12,color: lwtColor,),
//                                Text("Referred By     :      ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(left: 8),),
                                Expanded(
                                  child: Text(listpending[index]?.referredByFullName ?? ''+"NA.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 2),),
                            Row(
                              children: <Widget>[
                                Icon(Icons.assignment,size: 12,color: lwtColor,),
//                                Text("Referred By     :      ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(left: 8),),
                                Expanded(
                                  child: Text(listpending[index]?.srRequirement ?? ''+"NA.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
//                        trailing: IconButton(
//                          icon: Icon(
//                            Icons.edit,
//                            color: lwtColor,
//                            size: 25,
//                          ),
//                          onPressed: (){
//                            var navigator = Navigator.of(context);
//                            navigator.push(
//                              MaterialPageRoute(builder: (BuildContext context) => EditSalesLead(listpending[index])),
////                          ModalRoute.withName('/'),
//                            );
//                          },
//                        ),
                      ),
                    )
                ),
              )
          );
        });
  }

  completedListView() {
    return ListView.builder(
        itemCount: listcompleted ==null ? 0: listcompleted.length,
        itemBuilder: (BuildContext context,int index){
          return Card(
              elevation: 10.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0,vertical: 4.0),
              child: InkWell(
                child: Container(
                  /*decoration: BoxDecoration(border: Border.all(color: lwtColor,width: 1),
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(5.0), topRight: const Radius.circular(5.0),bottomLeft: const Radius.circular(5.0), bottomRight: const Radius.circular(5.0),
                    )),*/
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(listpending[index]?.srNo ?? 'NA',
                              style: TextStyle(
                                  color: lwtColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 6),),
                            Row(
                              children: <Widget>[
                                Text("Name                :     ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(top: 2),),
                                Text(listpending[index]?.srCustomerName ?? 'NA',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 2),),
                            Row(
                              children: <Widget>[
                                Text("Email                :     ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(top: 2),),
                                Text(listpending[index]?.srContactEmail ?? ''+"NA.",
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 2),),
                            Row(
                              children: <Widget>[
                                Text("Number           :      ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(top: 2),),
                                Text(listpending[index]?.srPhoneNo ?? ''+"NA.",
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 2),),
                            Row(
                              children: <Widget>[
                                Text("Referred By     :     ",style: TextStyle(color: Colors.black,fontSize: 8),),
                                Padding(padding: EdgeInsets.only(top: 2),),
                                Expanded(
                                  child: Text(listpending[index]?.referredByFullName ?? ''+"NA.",
                                    style: TextStyle(
                                        color: lwtColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
//                        trailing: IconButton(
//                          icon: Icon(
//                            Icons.keyboard_arrow_right,
//                            color: lwtColor,
//                            size: 25,
//                          ),
//                          onPressed: (){
//                            var navigator = Navigator.of(context);
//                            navigator.push(
//                              MaterialPageRoute(builder: (BuildContext context) => PreviewSalesLead(listcompleted[index])),
////                          ModalRoute.withName('/'),
//                            );
//                          },
//                        ),
                      ),
                    )
                ),
              )
          );
        });
  }

  void _navigateMemeberMethod(BuildContext context) async {
    var data= await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Members(choosePerson)));
    var string=data.split(" USR_");
    setState(() {
      choosePerson = string[0];
      resourceId=string[1];
    });
    pendingListM(resourceId);
   _dashboards = true;
   _color1=true;
   _color2=false;

  }

}
