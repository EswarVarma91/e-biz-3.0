import 'package:eaglebiz/activity/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>{
  String name='-',emailid='-',mobilenumber='-',department='-',designation='-',employCode="-";

   getAccountDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("fullname");
      employCode = preferences.getString("uEmpCode");
      emailid = preferences.getString("emailId");
      department = preferences.getString("department");
      designation = preferences.getString("designation");

    });
  }
  @override
  void initState() {
    super.initState();
    getAccountDetails();
  }

  bool _isEdit = false;
  final FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        if(_isEdit==false) {
          // ignore: missing_return
          var navigator = Navigator.of(context);
          // ignore: missing_return
          navigator.pushAndRemoveUntil(
            // ignore: missing_return
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            // ignore: missing_return
            ModalRoute.withName('/'),
          );
        }else{
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: new Text('Do you want to save changes.?'),
                  actions: <Widget>[
                    new CupertinoButton(
                      onPressed: () {
                        var navigator = Navigator.of(context);
                        // ignore: missing_return
                        navigator.push(
                          // ignore: missing_return
                          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                          // ignore: missing_return
                          // ModalRoute.withName('/'),
                        );
                      },
                      child: new Text('No'),
                    ),
                    new CupertinoButton(
                      onPressed: ()  {
                        _saveProfile();
                      },
                      child: new Text('Yes'),),
                  ],
                );
              });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Profile",style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color:Colors.white),
          actions: <Widget>[
           /* _isEdit ? Container() : IconButton(
              icon: Icon(Icons.edit,color: Colors.white,),
              onPressed: (){
                //Service Call
                setState(() {
                  _isEdit =!_isEdit;
                });
              },
            ),
          _isEdit ? IconButton(
            icon: Icon(Icons.check,color: Colors.white,size: 30,),
          onPressed: (){
            setState(() {
              _isEdit=!_isEdit;
            });
          },):Container(),*/
        ],),
          body:  Stack(
            children: <Widget>[
              Container(color: Colors.white,),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                color: Colors.white,
                child:  ListView(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 30,bottom: 30),
                            width: 160.0,
                            height: 160.0,
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              image:  DecorationImage(
                                image: ExactAssetImage(
                                    'assets/images/as.png'),
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: TextEditingController(text: name),
                            enabled: _isEdit ? true : false,
                            decoration: InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: TextEditingController(text: emailid),
                            enabled: _isEdit ? true : false,
                            decoration: InputDecoration(
                              labelText: "Email Id",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: TextEditingController(text: employCode.toString()),
                            enabled: _isEdit ? true : false,
                            decoration: (InputDecoration(
                              labelText: "Employee Code",
                              border: OutlineInputBorder(),
                            )),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: TextEditingController(text: department),
                            enabled: _isEdit ? true : false,
                            decoration: InputDecoration(
                              labelText: "Department",
                              border: OutlineInputBorder(),
                            ),

                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: TextEditingController(text: designation),
                            enabled: _isEdit ? true : false,
                              decoration: InputDecoration(
                                labelText: "Designation",
                                border: OutlineInputBorder(),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void _saveProfile() {
    var navigator = Navigator.of(context);
    // ignore: missing_return
    navigator.push(
      // ignore: missing_return
      MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      // ignore: missing_return
      // ModalRoute.withName('/'),
    );
  }
}
