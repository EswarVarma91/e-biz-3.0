package ebiz.lotus.administrator.eaglebiz.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;

import java.util.ArrayList;
import java.util.List;

import ebiz.lotus.administrator.eaglebiz.model.LocationDataModel;
import ebiz.lotus.administrator.eaglebiz.model.LocationModel;


public class DBManager {

    private DatabaseHelper dbHelper;

    private Context context;

    private SQLiteDatabase database;


    public DBManager(Context c) {
        context = c;
    }

    public DBManager open() throws SQLException {
        dbHelper = new DatabaseHelper(context);
        database = dbHelper.getWritableDatabase();
        return this;
    }

    public void close() {
        dbHelper.close();
    }

    public void insert(String device_id, String lati,String longi,String createdDate) {
        ContentValues contentValue = new ContentValues();
        contentValue.put(DatabaseHelper._DEVICEID, device_id);
        contentValue.put(DatabaseHelper._LATI, lati);
        contentValue.put(DatabaseHelper._LONGI, longi);
        contentValue.put(DatabaseHelper._CREATED_DATE_TIME, createdDate);
        database.insert(DatabaseHelper.TABLE_NAME, null, contentValue);
    }

    public List<LocationModel> getAllLocationsData() {
        List<LocationModel> locationList = new ArrayList<LocationModel>();

        String selectQuery = "SELECT * FROM " + DatabaseHelper.TABLE_NAME;

        SQLiteDatabase db= this.dbHelper.getWritableDatabase();
        Cursor cursor= db.rawQuery(selectQuery,null);

        if(cursor.moveToFirst()){
            do{
                LocationModel locationDataModel= new LocationModel();
//                locationDataModel.setIdM(Integer.parseInt(cursor.getString(0)));
                locationDataModel.setDeviceId(cursor.getString(1));
                locationDataModel.setLatitude(cursor.getString(2));
                locationDataModel.setLongitude(cursor.getString(3));
                locationDataModel.setDate(cursor.getString(4));
                locationList.add(locationDataModel);
            }while (cursor.moveToNext());
        }
        return locationList;
    }



    public void delete(long _id) {
        database.delete(DatabaseHelper.TABLE_NAME, DatabaseHelper._ID + "=" + _id, null);
    }

    public void deleteAll()
    {
        database.delete(DatabaseHelper.TABLE_NAME,null,null);
        database.close();
    }

}
