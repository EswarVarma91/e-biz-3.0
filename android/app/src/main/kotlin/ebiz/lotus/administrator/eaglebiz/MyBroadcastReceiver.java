package ebiz.lotus.administrator.eaglebiz;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.WindowManager;
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

public class MyBroadcastReceiver extends BroadcastReceiver {

    String android_id;
    int level, scale;
    float batteryPct;


    String localAddress = "http://10.100.1.129:8080/";
    String devAddress = "http://192.168.2.5:8383/";
    String testAddress = "http://192.168.2.3:8080/";
    String globalAddesss = "https://e-biz.in:9000/";
    LocationManager lcm;
    LocationListener listener;
    RequestQueue queue;
    Intent batteryStatus;
    LocationTrack locationTrack;

    String hrms_Service = globalAddesss + "att.service/hrms/attendance/save/location";
    String hrms_offline_Service = globalAddesss + "att.service/hrms/attendance/save/offline/location";

    @Override
    public void onReceive(Context context, Intent intent) {

        try{
//            dbManager = new DBManager(context);
            android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
            locationTrack = new LocationTrack(context);
            if (locationTrack.canGetLocation()) {
                double longitude = locationTrack.getLongitude();
                double latitude = locationTrack.getLatitude();
                IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
                batteryStatus = context.registerReceiver(null, intentFilter);
                level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
                scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, 0);
                batteryPct = Math.round((level / (float) scale) * 100);
                // Toast.makeText(context, "Longitude:" + Double.toString(longitude) + "\nLatitude:" + Double.toString(latitude), Toast.LENGTH_SHORT).show();
                if(latitude!=0.0) {
                    pushData(context, android_id, latitude, longitude, batteryPct);
                }
            } else {
                locationTrack.showSettingsAlert();
            }

        }catch(WindowManager.BadTokenException ex){

        }
    }

    private void pushData(Context context, String android_id, double latitude, double longitude, float battery) {
        try{

            queue = Volley.newRequestQueue(context);
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
                    jsonObject.put("latitude", String.valueOf(latitude));
                    jsonObject.put("longitude", String.valueOf(longitude));
                    jsonObject.put("deviceId", android_id);
                    jsonObject.put("battery",String.valueOf(battery));
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

        }catch(WindowManager.BadTokenException ex){

        }


    }
}