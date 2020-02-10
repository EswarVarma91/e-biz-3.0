import 'dart:core';
import 'dart:io' as io;
import 'package:Ebiz/model/AttendanceGettingModel.dart';
import 'package:Ebiz/model/AttendanceModel.dart';
import 'package:Ebiz/model/EndAttendanceModel.dart';
import 'package:Ebiz/model/HotelRequestModel.dart';
import 'package:Ebiz/model/StartAttendanceModel.dart';
import 'package:Ebiz/model/WorkStatusModel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HotelTable {
  var now = DateTime.now();
  static Database _db;
  static const String ID = 'hotel_id';
  static const String UID = 'u_id';
  static const String HOTEL_PACKAGE_ID = 'hotel_package_id';
  static const String HOTEL_REF_NO = 'hotel_ref_no';
  static const String HOTEL_LOCATION = 'hotel_location';
  static const String HOTEL_CHECK_IN = 'hotel_check_in';
  static const String HOTEL_CHECK_OUT = 'hotel_check_out';
  static const String HOTEL_PURPOSE = 'hotel_purpose';
  static const String HOTEL_RATING = 'hotel_rating';
  static const String REF_ID = 'ref_id';
  static const String REF_TYPE = 'ref_type';
  static const String HOTEL_STATUS = 'hotel_status';
  static const String HOTEL_CREATED_BY = 'hotel_created_by';
  static const String HOTEL_CREATED_DATE = 'hotel_created_date';
  static const String PROJ_OANO = 'proj_oano';
  static const String TRAVELLER_NAME = 'travellerName';
  static const String TABLE = 'hotel_booking_info';
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
        'CREATE TABLE $TABLE($ID INTEGER , $HOTEL_REF_NO TEXT, $PROJ_OANO TEXT, $TRAVELLER_NAME TEXT, $HOTEL_LOCATION TEXT, $HOTEL_CHECK_IN TEXT, $HOTEL_CHECK_OUT TEXT, $HOTEL_PURPOSE TEXT, $HOTEL_RATING REAL)');
  }

  Future<int> save(String hotel_ref_no,String proj_oano,String travellerName,String ) async {
    try {
      var dbClient = await db;
      var res ;
      // = await dbClient.rawInsert(
      //     "INSERT into $TABLE ($HOTEL_REF_NO, $PROJ_OANO, $TRAVELLER_NAME, $HOTEL_LOCATION, $HOTEL_CHECK_IN, $HOTEL_CHECK_OUT, $HOTEL_PURPOSE, $HOTEL_RATING) VALUES (?,?,?,?,?,?,?,?)",
      //     [
      //       hrm.hotel_ref_no,
      //       hrm.proj_oano,hrm.travellerName,hrm.hotel_location,hrm.hotel_check_in,hrm.hotel_check_out,hrm.hotel_purpose,hrm.hotel_rating
      //     ]);
      return res;
    } catch (Exception) {
      return null;
    }
  }

  Future<List<HotelRequestModel>> getAllHotelRequests() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery('SELECT * FROM $TABLE');
    List<HotelRequestModel> am = [];
    if (res.length > 0) {
      for (int i = 0; i < res.length; i++) {
        am.add(HotelRequestModel.fromMap(res[i]));
      }
    }
    return am;
  }


  Future<int> deleteAll() async {
    var dbClient = await db;
    var result =
        await dbClient.rawDelete('DELETE FROM $TABLE');
    return result;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}
