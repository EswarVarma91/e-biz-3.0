package ebiz.lotus.administrator.eaglebiz;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.os.BatteryManager;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.RequiresApi;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.gson.Gson;

import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import ebiz.lotus.administrator.eaglebiz.database.DBManager;
import ebiz.lotus.administrator.eaglebiz.model.LocationModel;
import im.delight.android.location.SimpleLocation;

public class MyBroadcastReceiver extends BroadcastReceiver {
    private SimpleLocation simpleLocation;
    String android_id;
    double latitude = 0.0, longitude = 0.0;
    DBManager dbManager;
    int level,scale;
    String textType;
    float batteryPct;
    List<LocationModel> listlocationData =new ArrayList<>();


    String localAddress = "http://10.100.1.129:8080/";
    String devAddress = "http://192.168.2.5:8383/";
    String testAddress = "http://192.168.2.3:8080/";
    String globalAddesss = "https://e-biz.in:9000/";

    String hrms_Service = globalAddesss +  "att.service/hrms/attendance/save/location";
    String hrms_offline_Service = globalAddesss + "att.service/hrms/attendance/save/offline/location";

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void onReceive(Context context, Intent intent) {
        dbManager = new DBManager(context);
        android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);

//        simpleLocation = new SimpleLocation(context);
//        if (!simpleLocation.hasLocationEnabled()) {
//            // simpleLocation.openSettings(context);
//        } else {
//            latitude = simpleLocation.getLatitude();
//            longitude = simpleLocation.getLongitude();
//            android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
//
//            if (android_id == null || android_id == "null" || android_id.isEmpty()) {
//            } else {
//                if (latitude == 0.0) {
//                    try{
//                        if(LocationManager.PROVIDERS_CHANGED_ACTION.equals(intent.getAction())){
//                            LocationManager lcm = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
//                            boolean isGpsEnabled = lcm.isProviderEnabled(LocationManager.GPS_PROVIDER);
//                            boolean isNetworkEnabled = lcm.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
//                            if(isGpsEnabled){
//                                Toast.makeText(context, "GPS ON", Toast.LENGTH_SHORT).show();
//                                mobileSession("gpsCheck",1,context);
//                            }else{
//                                Toast.makeText(context, "GPS OFF", Toast.LENGTH_SHORT).show();
//                                mobileSession("gpsCheck",0,context);
//                            }
////                            if(isNetworkEnabled){
////                                Toast.makeText(context, "NET ON", Toast.LENGTH_SHORT).show();
////                                mobileSession("netCheck",1,context);
////                            }else{
////                                Toast.makeText(context, "NET ON", Toast.LENGTH_SHORT).show();
////                                mobileSession("netCheck",0,context);
////                            }
//                        }
//                    }catch(NullPointerException e){
//
//                    }catch(Exception e){
//
//                    }
//                } else {
//                    try{
//                        if(LocationManager.PROVIDERS_CHANGED_ACTION.equals(intent.getAction())){
//                            LocationManager lcm = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
//                            boolean isGpsEnabled = lcm.isProviderEnabled(LocationManager.GPS_PROVIDER);
//                            boolean isNetworkEnabled = lcm.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
//                            if(isGpsEnabled){
//                                Toast.makeText(context, "GPS ON", Toast.LENGTH_SHORT).show();
//                                mobileSession("gpsCheck",1,context);
//                            }else{
//                                Toast.makeText(context, "GPS OFF", Toast.LENGTH_SHORT).show();
//                                mobileSession("gpsCheck",0,context);
//                            }
////                            if(isNetworkEnabled){
////                                Toast.makeText(context, "NET ON", Toast.LENGTH_SHORT).show();
////                                mobileSession("netCheck",1,context);
////                            }else{
////                                Toast.makeText(context, "NET ON", Toast.LENGTH_SHORT).show();
////                                mobileSession("netCheck",0,context);
////                            }
//                        }
//                    }catch(NullPointerException e){
//
//                    }catch(Exception e){
//
//                    }
//                }
//            }
//        }
        simpleLocation = new SimpleLocation(context);
        if (!simpleLocation.hasLocationEnabled()) {
            // simpleLocation.openSettings(context);
        } else {
            latitude = simpleLocation.getLatitude();
            longitude = simpleLocation.getLongitude();
            android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);

            if (android_id == null || android_id == "null" || android_id.isEmpty()) {
            } else {
                if (latitude == 0.0) {
                } else {

                    IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
                    Intent batteryStatus = context.registerReceiver(null,intentFilter);


                    level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL,0);
                    scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE,0);
                    batteryPct= Math.round((level / (float) scale ) * 100);
                    ConnectivityManager conMgr = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
                    if(conMgr.getActiveNetworkInfo()!=null && conMgr.getActiveNetworkInfo().isAvailable() && conMgr.getActiveNetworkInfo().isConnected()) {
//                        Log.d("Receiver","Yes Internet");
                        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
                        String currentDateandTime = sdf.format(new Date());
                        dbManager.open();
                        listlocationData.addAll(dbManager.getAllLocationsData());
                        dbManager.close();
                        pushData(context,android_id,latitude,longitude,String.valueOf(batteryPct));

                        if(listlocationData.size()!=0){
                            pushDataOffline(context,listlocationData);
                        }
                    }else{
//                        Toast.makeText(context, "No Internet....", Toast.LENGTH_SHORT).show();
//                        Log.d("Receiver","No Internet");
                        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
                        String currentDateandTime = sdf.format(new Date());
                        dbManager.open();

                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                            LocalTime time1= LocalTime.now();

                            LocalTime time2= LocalTime.of(8,50,0,0);
                            LocalTime time3= LocalTime.of(19,0,0,0);

                            DateFormat dateFormat= new SimpleDateFormat("HH:mm:ss");

                            java.util.Date date = new java.util.Date();
                            String formattedDate = dateFormat.format(date);

                            String[] parts = formattedDate.split(":");
                            Calendar cal = Calendar.getInstance();
                            cal.set(Calendar.HOUR_OF_DAY,Integer.parseInt(parts[0]));
                            cal.set(Calendar.MINUTE,Integer.parseInt(parts[1]));
                            cal.set(Calendar.SECOND,Integer.parseInt(parts[2]));

                            if(cal.get(Calendar.DAY_OF_WEEK)!= Calendar.SUNDAY){
                                if((time1.isBefore(time2)|| time1.equals(time2)) && (time1.isBefore(time3)|| time1.equals(time3))
                                        || (time1.isAfter(time2) || time1.equals(time2))  && (time1.isAfter(time3) || time1.equals(time3))){

                                }else{
                                    dbManager.insert(android_id,String.valueOf(latitude),String.valueOf(longitude),String.valueOf(batteryPct),currentDateandTime);
                                }
                            }else{

                            }
                        }
                        dbManager.close();
                    }
                }
            }
        }
    }

    private void pushDataOffline(Context context, List<LocationModel> listlocationData) {
        RequestQueue queue = Volley.newRequestQueue(context);
        String json= new Gson().toJson(listlocationData);
//        Log.d("esko",json);

        final StringRequest reqQueue = new StringRequest(Request.Method.POST, hrms_offline_Service,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        Log.d("eskoResponse : ", response);
                        dbManager.open();
                        dbManager.deleteAll();
                        dbManager.close();
                        listlocationData.clear();

                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                Log.d("eskoError : ", volleyError.toString());
            }
        }) {
            @Override
            public byte[] getBody() throws AuthFailureError {
                try {
                    return json.getBytes("utf-8");
                } catch (Exception ex) {

                }
                return super.getBody();
            }

            @Override
            public String getBodyContentType() {
                return "application/json";
            }
        };
        reqQueue.setRetryPolicy(new DefaultRetryPolicy(5 * DefaultRetryPolicy.DEFAULT_TIMEOUT_MS, 0, 0));
        queue.add(reqQueue);

    }

    private void pushData(Context context, String android_id, double latitude, double longitude, String battery) {
        RequestQueue queue = Volley.newRequestQueue(context);
        final StringRequest reqQueue = new StringRequest(Request.Method.POST, hrms_Service,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        Log.d("eskoResponse : ", response);

                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                Log.d("eskoError : ", volleyError.toString());
            }
        }) {
            @Override
            public byte[] getBody() throws AuthFailureError {
                try {
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("latitude", latitude);
                    jsonObject.put("longitude", longitude);
                    jsonObject.put("deviceId", android_id);
                    jsonObject.put("battery",battery);
                    return jsonObject.toString().getBytes("utf-8");
                } catch (Exception ex) {

                }
                return super.getBody();
            }
            @Override
            public String getBodyContentType() {
                return "application/json";
            }
        };
        reqQueue.setRetryPolicy(new DefaultRetryPolicy(5 * DefaultRetryPolicy.DEFAULT_TIMEOUT_MS, 0, 0));
        queue.add(reqQueue);
    }
//    void mobileSession(String data, int res, Context context){
//
//        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
//        String currentDateandTime = sdf.format(new Date());
//
//        if(data.equals("gpsCheck")){
//            if(res==1){
//                textType = "GPS-ON";
//            }else if(res==0){
//                textType = "GPS-OFF";
//            }
//        }
////        else if (data.equals("netCheck")){
////            if(res==1){
////                textType = "NET-ON";
////            }else if(res==0){
////                textType = "NET-ON";
////            }
////        }
//
//        //=============
//
//        RequestQueue queue = Volley.newRequestQueue(context);
//        final StringRequest reqQueue = new StringRequest(Request.Method.POST, insertMobileSession,
//                new Response.Listener<String>() {
//                    @Override
//                    public void onResponse(String response) {
//                        Log.d("eskoResponse : ", response);
//
//                    }
//                }, new Response.ErrorListener() {
//            @Override
//            public void onErrorResponse(VolleyError volleyError) {
//                Log.d("eskoError : ", volleyError.toString());
//            }
//        }) {
//            @Override
//            public byte[] getBody() throws AuthFailureError {
//                try {
//                    JSONObject jsonObject = new JSONObject();
//                    jsonObject.put("latitude", latitude);
//                    jsonObject.put("longitude", longitude);
//                    jsonObject.put("deviceId", android_id);
//                    jsonObject.put("type",textType);
//                    jsonObject.put("dateTime",currentDateandTime);
//                    return jsonObject.toString().getBytes("utf-8");
//                } catch (Exception ex) {
//
//                }
//                return super.getBody();
//            }
//
//            @Override
//            public String getBodyContentType() {
//                return "application/json";
//            }
//        };
//        reqQueue.setRetryPolicy(new DefaultRetryPolicy(5 * DefaultRetryPolicy.DEFAULT_TIMEOUT_MS, 0, 0));
//        queue.add(reqQueue);
//
//        //==========
//
//
//
//    }
}