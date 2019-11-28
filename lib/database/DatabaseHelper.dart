import 'dart:core';
import 'dart:io' as io;
import 'package:Ebiz/model/AttendanceGettingModel.dart';
import 'package:Ebiz/model/AttendanceModel.dart';
import 'package:Ebiz/model/EndAttendanceModel.dart';
import 'package:Ebiz/model/StartAttendanceModel.dart';
import 'package:Ebiz/model/WorkStatusModel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  var now = DateTime.now();
  static Database _db;
  static const String ID = 'id';
  static const String USER_ID = 'user_id';
  static const String START_TIME = 'starttime';
  static const String START_LAT = 'startlat';
  static const String START_LONG = 'startlong';
  static const String END_TIME = 'endtime';
  static const String END_LAT = 'endlat';
  static const String END_LONG = 'endlong';
  static const String DATE = 'date';
  static const String WORK_STATUS = 'work_status';
  static const String TABLE = 'attenTB';
  static const String DATABASE = 'EbizDb';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory directoryD = await getApplicationDocumentsDirectory();
    String path = join(directoryD.path, DATABASE);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE($ID INTEGER , $USER_ID TEXT, $START_TIME TEXT, $START_LAT TEXT, $START_LONG TEXT, $END_TIME TEXT, $END_LAT TEXT, $END_LONG TEXT, $DATE TEXT,$WORK_STATUS TEXT, PRIMARY KEY ($USER_ID, $DATE))');
  }

  Future<int> save(AttendanceModel am) async {
    try {
      String dateO = DateFormat("yyyy-MM-dd").format(now).toString();
      var dbClient = await db;
      var res = await dbClient.rawInsert(
          "INSERT into $TABLE ($USER_ID, $START_TIME, $START_LAT, $START_LONG, $END_TIME, $END_LAT, $END_LONG, $DATE) VALUES (?,?,?,?,?,?,?,?)",
          [
            am.user_id,
            am.starttime,
            am.startlat,
            am.startlong,
            am.endtime,
            am.endlat,
            am.endlong,
            dateO
          ]);
      if (res.toString() == "1") {
        _writeStart(am.starttime);
      }
      return res;
    } catch (Exception) {
      return null;
    }
  }

  ///to do need
  Future<int> updateStartandEnd(AttendanceGettingModel am) async {
    String dateO = DateFormat("yyyy-MM-dd").format(now).toString();
    String userId = am.user_id.toString();
    var dbClient = await db;
    print([am.user_id].toString());
    var res = await dbClient.rawUpdate(
        'UPDATE $TABLE SET  $START_TIME = ?, $END_TIME = ? WHERE $DATE= \'$dateO\' AND $USER_ID = \'$userId\'',
        [am.starttime, am.endtime]);
    if (res.toString() == "1") {
      _writeStart(am.starttime);
      _writeEnd(am.endtime);
    }
    return res;
  }

  Future<int> updateStart(StartAttendanceModel am) async {
    String dateO = DateFormat("yyyy-MM-dd").format(now).toString();
    String userId = am.user_id.toString();
    var dbClient = await db;
    var res = await dbClient.rawUpdate(
        'UPDATE $TABLE SET $START_TIME = ?, $START_LAT = ?, $START_LONG = ? WHERE $DATE= \'$dateO\' AND $USER_ID = \'$userId\'',
        [am.starttime, am.startlat, am.startlong]);
    if (res.toString() == "1") {
      _writeStart(am.starttime);
    }
    return res;
  }

  Future<int> updateEnd(EndAttendanceModel am) async {
    String dateO = DateFormat("yyyy-MM-dd").format(now).toString();
    String userId = am.user_id.toString();
    var dbClient = await db;
    var res = await dbClient.rawUpdate(
        'UPDATE $TABLE SET  $END_TIME = ?, $END_LAT = ?, $END_LONG = ? WHERE $DATE= \'$dateO\' AND $USER_ID = \'$userId\'',
        [am.endtime, am.endlat, am.endlong]);
    if (res.toString() == "1") {
      _writeEnd(am.endtime);
    }
    return res;
  }

  Future<int> updateWStatus(WorkStatusModel wm) async {
    String dateO = DateFormat("yyyy-MM-dd").format(now).toString();
    String userId = wm.user_id.toString();
    var dbClient = await db;
    var res = await dbClient.rawUpdate(
        'UPDATE $TABLE SET $WORK_STATUS = ? WHERE $DATE= \'$dateO\' AND $USER_ID = \'$userId\'',
        [wm.workstatus]);
    if (res.toString() == "1") {
      return res;
    }
    return res;
  }

  Future<List<AttendanceModel>> getCurrentDateTime() async {
    String dateO = DateFormat("yyyy-MM-dd").format(now).toString();
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        'SELECT $USER_ID, $START_TIME, $END_TIME, $WORK_STATUS, $DATE FROM $TABLE WHERE $DATE= \'$dateO\'');
    List<AttendanceModel> am = [];
    if (res.length > 0) {
      for (int i = 0; i < res.length; i++) {
        am.add(AttendanceModel.fromMap(res[i]));
      }
    }
    print(am.toString());
    return am;
  }

  Future<List<AttendanceModel>> getAllAttendance() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery('SELECT * FROM $TABLE');
    List<AttendanceModel> am = [];
    if (res.length > 0) {
      for (int i = 0; i < res.length; i++) {
        am.add(AttendanceModel.fromMap(res[i]));
      }
    }

    print(am.toString());
    return am;
  }

  Future<String> getStringCheckData() async {
    String dateO = DateFormat("yyyy-MM-dd").format(now).toString();
    var dbClient = await db;
    var res =
        await dbClient.rawQuery('SELECT * FROM $TABLE WHERE $DATE<$dateO');

    print(res.toString());
    return res.toString();
  }

  Future<int> delete(int id) async {
    String dateO = DateFormat("yyyy-MM-dd").format(now).toString();
    var dbClient = await db;
//        var result = await dbClient.rawDelete('DELETE FROM $TABLE WHERE $DATE NOT IN (SELECT * FROM $TABLE)');
    var result =
        await dbClient.rawDelete('DELETE FROM $TABLE WHERE $DATE>$dateO');
    //print(result);
    return result;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  void _writeStart(String timeStart) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("timeStart", timeStart);
  }

  void _writeEnd(String timeEnd) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("timeEnd", timeEnd);
  }
}
