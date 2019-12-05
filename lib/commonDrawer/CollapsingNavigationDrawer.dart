import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/activity/Login.dart';
import 'package:Ebiz/commonDrawer/CollapsingListTile.dart';
import 'package:Ebiz/functionality/approvals/Approvals.dart';
import 'package:Ebiz/functionality/hotel/HotelRequestList.dart';
import 'package:Ebiz/functionality/location/MapsActivity.dart';
import 'package:Ebiz/functionality/permissions/Permissions.dart';
import 'package:Ebiz/functionality/salesLead/SalesLead.dart';
import 'package:Ebiz/functionality/taskPlanner/TaskPlanner.dart';
import 'package:Ebiz/functionality/travel/TravelRequestList.dart';
import 'package:Ebiz/model/NavigationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

// ignore: must_be_immutable
class CollapsingNavigationDrawer extends StatefulWidget {
  var result;
  CollapsingNavigationDrawer(this.result);

  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState(this.result);
  }
}

class CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  var result;
  CollapsingNavigationDrawerState(this.result);
  double maxWidth = 210;
  double minWidth = 55;
  bool isCollapsed = false;
  int currentSelectedIndex = 0;
  var downteam, profilename, hrCnt, salesCnt, travelCnt;

  List<NavigationModel> listMain = [];

  List<NavigationModel> navigationItems = [
    NavigationModel(title: "Home", icon: Icons.home),
    NavigationModel(title: "Sales Lead", icon: Icons.monetization_on),
    NavigationModel(title: "Tasks", icon: Icons.assignment),
    NavigationModel(title: "L & P", icon: Icons.event_busy),
    NavigationModel(title: "Approvals", icon: Icons.assignment_turned_in),
    NavigationModel(title: "Travel Request", icon: Icons.card_travel),
    NavigationModel(title: "Hotel Request", icon: Icons.hotel),
  ];

  List<NavigationModel> navigationItemsPermissions = [
    NavigationModel(title: "L & P", icon: Icons.event_busy),
    NavigationModel(title: "Home", icon: Icons.home),
    NavigationModel(title: "Sales Lead", icon: Icons.monetization_on),
    NavigationModel(title: "Tasks", icon: Icons.assignment),
    NavigationModel(title: "Approvals", icon: Icons.assignment_turned_in),
    NavigationModel(title: "Travel Request", icon: Icons.card_travel),
    NavigationModel(title: "Hotel Request", icon: Icons.hotel),
  ];

  List<NavigationModel> navigationItemsSales = [
    NavigationModel(title: "Sales Lead", icon: Icons.monetization_on),
    NavigationModel(title: "Home", icon: Icons.home),
    NavigationModel(title: "Tasks", icon: Icons.assignment),
    NavigationModel(title: "L & P", icon: Icons.event_busy),
    NavigationModel(title: "Approvals", icon: Icons.assignment_turned_in),
    NavigationModel(title: "Travel Request", icon: Icons.card_travel),
    NavigationModel(title: "Hotel Request", icon: Icons.hotel),
  ];

  List<NavigationModel> navigationItemsTask = [
    NavigationModel(title: "Tasks", icon: Icons.assignment),
    NavigationModel(title: "Home", icon: Icons.home),
    NavigationModel(title: "Sales Lead", icon: Icons.monetization_on),
    NavigationModel(title: "L & P", icon: Icons.event_busy),
    NavigationModel(title: "Approvals", icon: Icons.assignment_turned_in),
    NavigationModel(title: "Travel Request", icon: Icons.card_travel),
    NavigationModel(title: "Hotel Request", icon: Icons.hotel),
  ];

  List<NavigationModel> navigationItemsTravel = [
    NavigationModel(title: "Travel Request", icon: Icons.card_travel),
    NavigationModel(title: "Home", icon: Icons.home),
    NavigationModel(title: "Sales Lead", icon: Icons.monetization_on),
    NavigationModel(title: "Tasks", icon: Icons.assignment),
    NavigationModel(title: "L & P", icon: Icons.event_busy),
    NavigationModel(title: "Approvals", icon: Icons.assignment_turned_in),
    NavigationModel(title: "Hotel Request", icon: Icons.hotel),
  ];

  List<NavigationModel> navigationItemsApprovals = [
    NavigationModel(title: "Approvals", icon: Icons.assignment_turned_in),
    NavigationModel(title: "Home", icon: Icons.home),
    NavigationModel(title: "Sales Lead", icon: Icons.monetization_on),
    NavigationModel(title: "Tasks", icon: Icons.assignment),
    NavigationModel(title: "L & P", icon: Icons.event_busy),
    NavigationModel(title: "Travel Request", icon: Icons.card_travel),
    NavigationModel(title: "Hotel Request", icon: Icons.hotel),
  ];

  List<NavigationModel> navigationItemsHotels = [
    NavigationModel(title: "Hotel Request", icon: Icons.hotel),
    NavigationModel(title: "Home", icon: Icons.home),
    NavigationModel(title: "Sales Lead", icon: Icons.monetization_on),
    NavigationModel(title: "Tasks", icon: Icons.assignment),
    NavigationModel(title: "L & P", icon: Icons.event_busy),
    NavigationModel(title: "Approvals", icon: Icons.assignment_turned_in),
    NavigationModel(title: "Travel Request", icon: Icons.card_travel),
  ];

  List<NavigationModel> navigationItemslocation = [
    NavigationModel(title: "Tracking", icon: Icons.my_location),
    NavigationModel(title: "Home", icon: Icons.home),
    NavigationModel(title: "Sales Lead", icon: Icons.monetization_on),
    NavigationModel(title: "Tasks", icon: Icons.assignment),
    NavigationModel(title: "L & P", icon: Icons.event_busy),
    NavigationModel(title: "Approvals", icon: Icons.assignment_turned_in),
    NavigationModel(title: "Travel Request", icon: Icons.card_travel),
    NavigationModel(title: "Hotel Request", icon: Icons.hotel),
  ];

  getFullName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      downteam = preferences.getString("downTeamId");
      profilename = preferences.getString("profileName");
      hrCnt = preferences.getString("hrCnt");
      travelCnt = preferences.getString("travelCnt");
      salesCnt = preferences.getString("salesCnt");

      if (downteam == "null" || downteam == null) {
        if (result.toString() == "1") {
          navigationItems.removeWhere((a) => a.title == "Approvals");
          listMain = navigationItems;
        } else if (result.toString() == "2") {
          navigationItemsSales.removeWhere((a) => a.title == "Approvals");
          listMain = navigationItemsSales;
        } else if (result.toString() == "3") {
          navigationItemsTask.removeWhere((a) => a.title == "Approvals");
          listMain = navigationItemsTask;
        } else if (result.toString() == "4") {
          navigationItemsPermissions.removeWhere((a) => a.title == "Approvals");
          listMain = navigationItemsPermissions;
        } else if (result.toString() == "7") {
          navigationItemsTravel.removeWhere((a) => a.title == "Approvals");
          listMain = navigationItemsTravel;
        } else if (result.toString() == "8") {
          navigationItemsHotels.removeWhere((a) => a.title == "Approvals");
          listMain = navigationItemsHotels;
        }
      } else if (salesCnt == 1) {
        if (result.toString() == "1") {
          listMain = navigationItems;
        } else if (result.toString() == "2") {
          listMain = navigationItemsSales;
        } else if (result.toString() == "3") {
          listMain = navigationItemsTask;
        } else if (result.toString() == "4") {
          listMain = navigationItemsPermissions;
        } else if (result.toString() == "5") {
          listMain = navigationItemsApprovals;
        } else if (result.toString() == "7") {
          listMain = navigationItemsTravel;
        } else if (result.toString() == "8") {
          listMain = navigationItemsHotels;
        }
      } else if (downteam != null || downteam != "null") {
        if (result.toString() == "1") {
          listMain = navigationItems;
        } else if (result.toString() == "2") {
          listMain = navigationItemsSales;
        } else if (result.toString() == "3") {
          listMain = navigationItemsTask;
        } else if (result.toString() == "4") {
          listMain = navigationItemsPermissions;
        } else if (result.toString() == "5") {
          listMain = navigationItemsApprovals;
        } else if (result.toString() == "7") {
          listMain = navigationItemsTravel;
        } else if (result.toString() == "8") {
          listMain = navigationItemsHotels;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getFullName();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 40.0,
      child: Container(
        width: minWidth,
        color: Color(0xFF272D34),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = counter;
                      });
                      if (listMain[counter].title == "Home") {
                        var navigator = Navigator.of(context);
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()),
                          ModalRoute.withName('/'),
                        );
                      } else if (listMain[counter].title == "Sales Lead") {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => SalesLead()),
                        );
                      } else if (listMain[counter].title == "Tasks") {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => TaskPlanner()),
                        );
                      } else if (listMain[counter].title == "L & P") {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => Permissions()),
                        );
                      } else if (listMain[counter].title == "Tasks") {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => TaskPlanner()),
                        );
                      } else if (listMain[counter].title == "Approvals") {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => Approvals()),
                        );
                      } else if (listMain[counter].title == "Location") {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MapsActivity()),
                        );
                      } else if (listMain[counter].title == "Travel Request") {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TravelRequestList()),
                        );
                      } else if (listMain[counter].title == "Hotel Request") {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HotelRequestList()),
                        );
                      }
                    },
                    isSelected: currentSelectedIndex == counter,
                    icon: listMain[counter].icon,
                    title: listMain[counter].title,
                  );
                },
                itemCount: listMain.length,
              ),
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: lwtColor,
              iconSize: 38,
              onPressed: () {
                _logout();
              },
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  _logout() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text('Do you want to Logout?'),
            actions: <Widget>[
              new CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('No'),
              ),
              new CupertinoButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.clear();
                  var navigator = Navigator.of(context);
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
                    ModalRoute.withName('/'),
                  );
                },
                child: new Text('Yes'),
              ),
            ],
          );
        });
  }
}
