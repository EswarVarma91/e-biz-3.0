import 'package:flutter/material.dart';

class TravelSelection extends StatefulWidget {
  String mode,res;
  TravelSelection(this.mode, this.res);

  @override
  _TravelSelectionState createState() => _TravelSelectionState(this.mode,this.res);
}

class _TravelSelectionState extends State<TravelSelection> {
  String mode,res;
  _TravelSelectionState(this.mode,this.res);
  List<String> listModeData = ['Flight', 'Train', 'Bus'];
  List<String> listModeTypeData = ['Domestic', 'International'];
  List<String> listTrainClassData = [
    '1AC',
    '2AC',
    '3AC',
    'CC',
    'Sleeper',
    '2S',
    'FC',
    'EC'
  ];
  List<String> listBusClassData = ['Sleeper', 'Semi-Sleeper', 'Non-AC'];
  List<String> listFlightClassData = ['Business', 'Economy'];
  List<String> list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(checkMode(mode)),
      ),
      body: Container(),
    );
  }

  checkMode(String mode) {
    if (mode == "1") {
      return "Traveller Name";
    } else if (mode == "2") {
      list = listModeData;
      return "Select Mode";
    } else if (mode == "3") {
      list = listModeTypeData;
      return "Mode Type";
    } else if (mode == "4") {
      if(res=="Flight"){
        list=listFlightClassData;
      }else if(res=="Train"){

      }else if(res=="Bus")
      
      return "Class";
    }
  }
}
