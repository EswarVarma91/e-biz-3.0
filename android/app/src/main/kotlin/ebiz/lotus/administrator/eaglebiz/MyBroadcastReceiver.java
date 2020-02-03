package ebiz.lotus.administrator.eaglebiz;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
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
import ebiz.lotus.administrator.eaglebiz.model.LocationDataModel;
import im.delight.android.location.SimpleLocation;

public class MyBroadcastReceiver extends BroadcastReceiver {
    private SimpleLocation simpleLocation;
    String android_id;
    double latitude = 0.0, longitude = 0.0;
    DBManager dbManager;
    List<LocationDataModel> listlocationData =new ArrayList<>();
    String hrms_Service = "https://e-biz.in:9000/att.service/hrms/attendance/save/location"; // global

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void onReceive(Context context, Intent intent) {
        dbManager = new DBManager(context);
        simpleLocation = new SimpleLocation(context);
        if (!simpleLocation.hasLocationEnabled()) {
//            context.SimpleLocation.openSettings(context);
        } else {
            latitude = simpleLocation.getLatitude();
            longitude = simpleLocation.getLongitude();
            android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);

            if (android_id == null || android_id == "null" || android_id.isEmpty()) {
            } else {
                if (latitude == 0.0) {
                } else {

                    ConnectivityManager conMgr = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);

                    if(conMgr.getActiveNetworkInfo()!=null && conMgr.getActiveNetworkInfo().isAvailable() && conMgr.getActiveNetworkInfo().isConnected()) {

//                        Toast.makeText(context, "Yes Internet", Toast.LENGTH_SHORT).show();
                        Log.d("Receiver","Yes Internet");
                        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
                        String currentDateandTime = sdf.format(new Date());

                        dbManager.open();
                        listlocationData.addAll(dbManager.getAllLocationsData());
                        dbManager.close();
                        //==================
                       pushData(context,android_id,latitude,longitude,currentDateandTime);

//                       for(int i=0; i<listlocationData.size();i++){
//                           int finalValue = listlocationData.size()-1;
//                           String aid = listlocationData.get(i).getDevice_idM();
//                           double alati = Double.parseDouble(listlocationData.get(i).getLatiM());
//                           double alongi = Double.parseDouble(listlocationData.get(i).getLongiM());
//                           String acreatedDate = listlocationData.get(i).getCreadted_dateM();
//
//                           pushData(context,aid,alati,alongi,acreatedDate);
//
//                           if(finalValue == i){
//                               dbManager.open();
//                               dbManager.deleteAll();
//                               dbManager.close();
//                               listlocationData.clear();
////                               listlocationData.size();
//                           }else{
//
//                           }
//                       }
                        //=============================

                    }else{
//                        Toast.makeText(context, "No Internet....", Toast.LENGTH_SHORT).show();
                        Log.d("Receiver","No Internet");


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
//                                    dbManager.insert(android_id,String.valueOf(latitude),String.valueOf(longitude),currentDateandTime);
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
    private void pushData(Context context, String android_id, double latitude, double longitude,String createdDate) {
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
//                    jsonObject.put("createdDate", createdDate);
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
        reqQueue.setRetryPolicy(new DefaultRetryPolicy(0, 0, 0));
        queue.add(reqQueue);
    }
}