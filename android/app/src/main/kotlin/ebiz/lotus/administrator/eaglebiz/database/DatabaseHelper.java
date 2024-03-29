package ebiz.lotus.administrator.eaglebiz.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

public class DatabaseHelper extends SQLiteOpenHelper {

    // Table Name
    public static final String TABLE_NAME = "elocation";

    // Table columns
    public static final String _ID = "_id";
    public static final String _DEVICEID = "device_id";
    public static final String _LATI = "lati";
    public static final String _LONGI = "longi";
    public static final String _BATTERY = "battery";
    public static final String _CREATED_DATE_TIME = "createdDateTime";
    // Database Information
    static final String DB_NAME = "ebiztrack.DB";

    // database version
    static final int DB_VERSION = 1;

    // Creating table query
    private static final String CREATE_TABLE = "CREATE TABLE " + TABLE_NAME + "("
            + _ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
            + _DEVICEID + " TEXT, "
            + _LATI + " TEXT, "
            + _LONGI + " TEXT, "
            + _BATTERY + " TEXT, "
            + _CREATED_DATE_TIME + " TEXT" + ")";


    public DatabaseHelper(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(CREATE_TABLE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
        onCreate(db);
    }
}
