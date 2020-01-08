import 'package:Ebiz/activity/Departments.dart';
import 'package:Ebiz/functionality/salesLead/ReferedBy.dart';
import 'package:Ebiz/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ChooseMapByType extends StatefulWidget {
  @override
  _ChooseMapByTypeState createState() => _ChooseMapByTypeState();
}

class _ChooseMapByTypeState extends State<ChooseMapByType> {
  bool _isSelectedD, _isSelectedU;

  TextEditingController _controllerUser = new TextEditingController();
  TextEditingController _controllerDepartment = new TextEditingController();

  String result = "1", userName, userId;

  @override
  void initState() {
    super.initState();
    _isSelectedD = true;
    _isSelectedU = false;
  }

  checkSeletion() {
    if (_isSelectedD == true) {
      result = "1";
    } else {
      result = "2";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.check),
            onPressed: () async {
              Navigator.pop(context, result + " USR_" + userId+ " U_"+userName);
            },
          )
        ],
        title: Text(
          "Filter",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: StaggeredGridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    top: 10,
                  ),
                  child: byDepartment(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    top: 10,
                  ),
                  child: byUser(),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 100.0),
                StaggeredTile.extent(2, 100.0),
              ],
            ),
          ),
          _isSelectedD
              ? Container(
                  margin: EdgeInsets.only(left: 0, right: 2, top: 130),
                  child: departmentView(),
                )
              : Container(),
          _isSelectedU
              ? Container(
                  margin: EdgeInsets.only(left: 0, right: 2, top: 130),
                  child: userView(),
                )
              : Container(),
        ],
      ),
    );
  }

  Material byDepartment() {
    return Material(
      color: _isSelectedD ? lwtColor : Colors.white,
      elevation: 14.0,
      shadowColor: _isSelectedD ? lwtColor : Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          userName = "";
          userId = "";
          setState(() {
            _isSelectedD = !_isSelectedD;
            checkSeletion();
            if (_isSelectedD == true) {
              _isSelectedU = !_isSelectedU;
              checkSeletion();
            } else if (_isSelectedD == false) {
              _isSelectedU = !_isSelectedU;
              checkSeletion();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Department",
                        style: TextStyle(
                          fontSize: _isSelectedD ? 20.0 : 12.0,
                          color: _isSelectedD ? Colors.white : lwtColor,
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

  Material byUser() {
    return Material(
      color: _isSelectedU ? lwtColor : Colors.white,
      elevation: 14.0,
      shadowColor: _isSelectedU ? lwtColor : Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          userName = "";
          userId = "";
          setState(() {
            _isSelectedU = !_isSelectedU;
            checkSeletion();
            if (_isSelectedU == true) {
              _isSelectedD = !_isSelectedD;
              checkSeletion();
            } else if (_isSelectedU == false) {
              _isSelectedD = !_isSelectedD;
              checkSeletion();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Users",
                        style: TextStyle(
                          fontSize: _isSelectedU ? 20.0 : 12.0,
                          color: _isSelectedU ? Colors.white : lwtColor,
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

  departmentView() {
    return Container(
      child: ListTile(
        onTap: () {
          selectDU(context, "1");
        },
        title: TextFormField(
          enabled: false,
          controller: TextEditingController(text: userName),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.chrome_reader_mode),
            labelText: "Department",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  userView() {
    return Container(
      child: ListTile(
        onTap: () {
          selectDU(context, "2");
        },
        title: TextFormField(
          enabled: false,
          controller: TextEditingController(text: userName),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.chrome_reader_mode),
            labelText: "Users",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  void selectDU(BuildContext context, String result) async {
    if (result == "1") {
      var data = await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Departments()));

      userName = data.split("USR_")[0];
      userId = data.split("USR_")[1];
      print(data + " " + userName + " " + userId);
    } else if (result == "2") {
      var data = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ReferedBy("Users")));

      userName = data.split("USR_")[0];
      userId = data.split("USR_")[1];
      print(data + " " + userName + " " + userId);
    }
  }
}
