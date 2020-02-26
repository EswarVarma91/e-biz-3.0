package ebiz.lotus.administrator.eaglebiz;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

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
import java.util.Date;
import java.util.Locale;

import im.delight.android.location.SimpleLocation;

public class Broadcastnetwork extends BroadcastReceiver {
    String android_id,textType;
    double latitude = 0.0, longitude = 0.0;
    private SimpleLocation simpleLocation;

    String localAddress = "http://10.100.1.129:8080/";
    String devAddress = "http://192.168.2.5:8383/";
    String testAddress = "http://192.168.2.3:8080/";
    String globalAddesss = "https://e-biz.in:9000/";

    String insertMobileSession = globalAddesss + "hrms.service/encryption/insertMobileSession"; // global
    @Override
    public void onReceive(Context context, Intent intent) {

        android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        simpleLocation = new SimpleLocation(context);
        if (!simpleLocation.hasLocationEnabled()) {
            // simpleLocation.openSettings(context);
        } else {
            latitude = simpleLocation.getLatitude();
            longitude = simpleLocation.getLongitude();
//            android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);

            if (android_id == null || android_id == "null" || android_id.isEmpty()) {
            } else {
                if (latitude == 0.0) {
                    try{
                        if(LocationManager.PROVIDERS_CHANGED_ACTION.equals(intent.getAction())){
                            LocationManager lcm = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
                            boolean isGpsEnabled = lcm.isProviderEnabled(LocationManager.GPS_PROVIDER);
                            boolean isNetworkEnabled = lcm.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
                            if(isGpsEnabled){
//                                Toast.makeText(context, "GPS ON", Toast.LENGTH_SHORT).show();
                                mobileSession("gpsCheck",1,context);
                            }else{
//                                Toast.makeText(context, "GPS OFF", Toast.LENGTH_SHORT).show();
                                mobileSession("gpsCheck",0,context);
                            }
                        }
//                        ConnectivityManager conMgr = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
//                        if(conMgr.getActiveNetworkInfo()!=null && conMgr.getActiveNetworkInfo().isAvailable() && conMgr.getActiveNetworkInfo().isConnected()) {
//                            Toast.makeText(context, "NET_ON", Toast.LENGTH_SHORT).show();
//                            mobileSession("netCheck",1,context);
//                        }else{
//                            Toast.makeText(context, "NET_OFF", Toast.LENGTH_SHORT).show();
//                            mobileSession("netCheck",0,context);
//                        }
                    }catch(NullPointerException e){

                    }catch(Exception e){

                    }
                } else {
                    try{
                        if(LocationManager.PROVIDERS_CHANGED_ACTION.equals(intent.getAction())){
                            LocationManager lcm = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
                            boolean isGpsEnabled = lcm.isProviderEnabled(LocationManager.GPS_PROVIDER);
//                            boolean isNetworkEnabled = lcm.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
                            if(isGpsEnabled){
                                Toast.makeText(context, "GPS ON", Toast.LENGTH_SHORT).show();
                                mobileSession("gpsCheck",1,context);
                            }else{
                                Toast.makeText(context, "GPS OFF", Toast.LENGTH_SHORT).show();
                                mobileSession("gpsCheck",0,context);
                            }
//                            if(isNetworkEnabled){
//                                Toast.makeText(context, "NET ON", Toast.LENGTH_SHORT).show();
//                                mobileSession("netCheck",1,context);
//                            }else{
//                                Toast.makeText(context, "NET ON", Toast.LENGTH_SHORT).show();
//                                mobileSession("netCheck",0,context);
//                            }
                        }
                    }catch(NullPointerException e){

                    }catch(Exception e){

                    }
                }
            }
        }

    }

    void mobileSession(String data, int res, Context context){

        SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
        String currentDateandTime = sdf.format(new Date());

        if(data.equals("gpsCheck")){
            if(res==1){
                textType = "GPS_ON";
            }else if(res==0){
                textType = "GPS_OFF";
            }
        }
//        else if (data.equals("netCheck")){
//            if(res==1){
//                textType = "NET_ON";
//            }else if(res==0){
//                textType = "NET_OFF";
//            }
//        }

        RequestQueue queue = Volley.newRequestQueue(context);
        final StringRequest reqQueue = new StringRequest(Request.Method.POST, insertMobileSession,
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
                    jsonObject.put("type",textType);
                    jsonObject.put("dateTime",currentDateandTime);
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
}
