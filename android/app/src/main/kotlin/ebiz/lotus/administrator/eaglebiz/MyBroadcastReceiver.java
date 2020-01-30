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

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
                        //==================
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

                        //=============================

                    }else{
//                        Toast.makeText(context, "No Internet....", Toast.LENGTH_SHORT).show();
                        Log.d("Receiver","No Internet");


                        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
                        String currentDateandTime = sdf.format(new Date());

                        dbManager.open();
                        dbManager.insert(android_id,String.valueOf(latitude),String.valueOf(longitude),currentDateandTime);

                        listlocationData.addAll(dbManager.getAllLocationsData());

                        dbManager.close();




                    }
                }
            }
        }
    }
}