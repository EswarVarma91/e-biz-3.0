package ebiz.lotus.administrator.eaglebiz;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.BatteryManager;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.Nullable;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONObject;

public class MyService extends Service {
    LocationTrack locationTrack;
    LocationManager lcm;
    LocationListener listener;
    RequestQueue queue;
    Intent batteryStatus;
    String android_id;
    int level, scale;
    float batteryPct;

    String localAddress = "http://10.100.1.129:8080/";
    String devAddress = "http://192.168.2.5:8383/";
    String testAddress = "http://192.168.2.3:8080/";
    String globalAddesss = "https://e-biz.in:9000/";

    String hrms_Service = globalAddesss + "att.service/hrms/attendance/save/location";
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        android_id = Settings.Secure.getString(getContentResolver(), Settings.Secure.ANDROID_ID);
        locationTrack = new LocationTrack(getApplicationContext());

        if (locationTrack.canGetLocation()) {

            double longitude = locationTrack.getLongitude();
            double latitude = locationTrack.getLatitude();
            IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
            batteryStatus = registerReceiver(null, intentFilter);
            level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
            scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, 0);
            batteryPct = Math.round((level / (float) scale) * 100);

            // Toast.makeText(context, "Longitude:" + Double.toString(longitude) + "\nLatitude:" + Double.toString(latitude), Toast.LENGTH_SHORT).show();
            if(latitude!=0.0) {
                pushData(getApplicationContext(), android_id, latitude, longitude, batteryPct);
            }
        } else {
            locationTrack.showSettingsAlert();
        }

        return START_STICKY;
    }


    private void pushData(Context context, String android_id, double latitude, double longitude, float battery) {
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


    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }
}
