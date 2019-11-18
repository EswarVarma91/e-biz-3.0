import 'package:eaglebiz/functionality/salesLead/ReferedBy.dart';
import 'package:eaglebiz/functionality/taskPlanner/Members.dart';
import 'package:eaglebiz/functionality/travel/TravelSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTravelRequest extends StatefulWidget {
  @override
  _AddTravelRequestState createState() => _AddTravelRequestState();
}

class _AddTravelRequestState extends State<AddTravelRequest> {
  TextEditingController _controllerFrom1 = TextEditingController();
  TextEditingController _controllerTo1 = TextEditingController();
  TextEditingController _controllerResponse1 = TextEditingController();

  String TtravelName,
      Tmode,
      TmodeType,
      Tfrom,TfromId,
      Tto,TtoId,
      Tclass,
      TcomplaintNo,
      TrarrivalDateTime,
      TcomaplaintTicketNo,
      TravelNameId;
  bool _isItflight = false;
  int y, m, d, hh, mm, ss;
  String toA, toB, toC;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = new DateTime.now();
    y = now.year;
    m = now.month;
    d = now.day;
    hh = now.hour;
    mm = now.minute;
    ss = now.second;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add travel request',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 0, top: 5),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TtravelName),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Traveller Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ReferedBy("Traveller Name")));
                if (data != null) {
                  setState(() {
                    TtravelName = data.split(" USR_")[0].toString();
                    TravelNameId = data.split(" USR_")[1].toString();
                  });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: Tmode),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Mode",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TravelSelection("2", "")));
                if (data != null) {
                  setState(() {
                    Tmode = data.toString();
                  });
                  if (data.toString() == "Flight") {
                    setState(() {
                      _isItflight = true;
                    });
                  } else {
                    setState(() {
                      _isItflight = false;
                    });
                  }
                }
              },
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TmodeType),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Mode Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TravelSelection("3", "")));
                if (data != null) {
                  setState(() {
                    TmodeType = data.toString();
                  });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: Tclass),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Class",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                if (Tmode != null) {
                  var data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              TravelSelection("4", Tmode)));
                  if (data != null) {
                    setState(() {
                      Tclass = data.toString();
                    });
                  }
                } else {
                  Fluttertoast.showToast(msg: "Please select mode.");
                }
              },
            ),
            _isItflight
                ? ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: Tfrom),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "From",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.add),
                    onTap: () async {
                      var data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TravelSelection("5", Tmode)));
                      if (data != null) {
                        setState(() {
                          Tfrom = data.split(" U_")[0].toString();
                          TfromId= data.split(" U_")[1].toString();
                        });
                      }
                    },
                  )
                : ListTile(
                    title: TextFormField(
                      controller: _controllerFrom1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "From",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
            _isItflight
                ? ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: Tto),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "To",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.add),
                    onTap: () async {
                      var data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TravelSelection("6", Tmode)));
                      if (data != null) {
                        setState(() {
                          Tto = data.split(" U_")[0].toString();
                          TtoId= data.split(" U_")[1].toString();
                        });
                      }
                    },
                  )
                : ListTile(
                    title: TextFormField(
                      controller: _controllerTo1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "To",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TrarrivalDateTime),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Journey Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(y, m, d, hh, mm),
                    maxTime: DateTime(y + 1, m, d, hh, mm), onChanged: (date) {
                  changeDateF(date);
                }, onConfirm: (date) {
                  changeDateF(date);
                }, locale: LocaleType.en);
              },
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TcomaplaintTicketNo),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "OA/Complaint Ticket No.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TravelSelection("7", "")));
                if (data != null) {
                  setState(() {
                    TcomaplaintTicketNo = data.toString();
                  });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                controller: _controllerResponse1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Response",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeDateF(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(".");
    // print(d[0]);
    setState(() {
      TrarrivalDateTime = d[0].toString();
    });
  }
}
