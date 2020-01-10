package ebiz.lotus.administrator.eaglebiz;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.MediaPlayer;
import android.provider.Settings;
import android.telephony.CellInfo;
import android.telephony.TelephonyManager;
import android.telephony.gsm.GsmCellLocation;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.NetworkError;
import com.android.volley.NoConnectionError;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.ServerError;
import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.jetbrains.annotations.NotNull;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManagerFactory;

import im.delight.android.location.SimpleLocation;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.RequestBody;

public class MyBroadcastReceiver extends BroadcastReceiver {
    MediaPlayer mp;
    private SimpleLocation simpleLocation;
    String android_id;
    double latitude , longitude ;
    int cid, lac, mcc, mnc;
//    String hrms_Service = "http://192.168.2.5:8383/att.service/hrms/attendance/save/location"; //dev
//    String hrms_Service= "http://192.168.2.3:8080/att.service/hrms/attendance/save/location"; //test
      String hrms_Service = "https://e-biz.in:9000/att.service/hrms/attendance/save/location"; //global

    @Override
    public void onReceive(Context context, Intent intent) {
        mp = MediaPlayer.create(context, R.raw.alarm);
        mp.reset();
        mp.start();
        new NukeSSLCerts().nuke();
//        HttpsTrustManager.allowAllSSL();
        simpleLocation = new SimpleLocation(context);
        if (!simpleLocation.hasLocationEnabled()) {
            SimpleLocation.openSettings(context);
        } else {
            latitude = simpleLocation.getLatitude();
            longitude = simpleLocation.getLongitude();
            android_id = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
            Log.v("android_id : ", android_id);
//            TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
//            @SuppressLint("MissingPermission") GsmCellLocation cellLocation = (GsmCellLocation) telephonyManager.getCellLocation();
//            String networkOperator = telephonyManager.getNetworkOperator();
//
//            cid=cellLocation.getCid();
//            lac=cellLocation.getLac();
//            if(!TextUtils.isEmpty(networkOperator)){
//                 mcc= Integer.parseInt(networkOperator.substring(0,3));
//                 mnc = Integer.parseInt(networkOperator.substring(3));
//            }
//            Log.d("eskNetwork Operator : ",networkOperator);
//            Log.d("Mcc : ",String.valueOf(mcc));
//            Log.d("Mnc : ",String.valueOf(mnc));
//            Log.d("Lac : ",""+lac);
//            Log.d("Cid : ",""+cid);
//             RequestQueue queue = Volley.newRequestQueue(context);
//             final StringRequest reqQueue = new StringRequest(Request.Method.POST, ""+hrms_Service, new Response.Listener<String>() {
//                 @Override
//                 public void onResponse(String response) {
// //                    Toast.makeText(context, response, Toast.LENGTH_SHORT).show();
//                     Log.d("eskoResponse : ",response);
//                 }
//             }, new Response.ErrorListener() {
//                 @Override
//                 public void onErrorResponse(VolleyError volleyError) {
//                     String message = null;
//                     Log.d("eskoError : ",volleyError.toString());
//                     if (volleyError instanceof NetworkError) {
// //                        message = "1 Cannot connect to Internet...Please check your connection!";
//                     } else if (volleyError instanceof ServerError) {
//                         if (volleyError.networkResponse.statusCode == 417) {
//                             message = "Invalid credentials. Please try again...";
//                         }
//                         else
//                         if (volleyError.networkResponse.statusCode == 500) {
//                             message = "Server could not be found. Please check.";
//                         } else {
//                             message = "The server could not be found. Please try again after some time!!";
//                         }
//                     } else if (volleyError instanceof AuthFailureError) {
//                         message = "Cannot connect to Internet...Please check your connection!";
//                     } else if (volleyError instanceof ParseError) {
//                         message = "Parsing error! Please try again after some time!!";
//                     } else if (volleyError instanceof NoConnectionError) {
//                         message = "Cannot connect to Internet...Please check your connection!";
//                     } else if (volleyError instanceof TimeoutError) {
//                         message = "Connection TimeOut! Please check your internet connection.";
//                     }
//                     Toast.makeText(context, "Error: " + message, Toast.LENGTH_LONG).show();
//                 }
//             }) {
//                 @Override
//                 public byte[] getBody() throws AuthFailureError {
//                     try {
//                         JSONObject jsonObject = new JSONObject();
//                         jsonObject.put("latitude", latitude);
//                         jsonObject.put("longitude",longitude);
//                         jsonObject.put("deviceId",android_id);
//                         return jsonObject.toString().getBytes("utf-8");
//                     } catch (Exception ex) {
//                         Toast.makeText(context, "Some error occurred. Please try again", Toast.LENGTH_LONG).show();
//                     }
//                     return super.getBody();
//                 }
//                 @Override
//                 public String getBodyContentType() {
//                     return "application/json";
//                 }
//             };
//             reqQueue.setRetryPolicy(new DefaultRetryPolicy(5*DefaultRetryPolicy.DEFAULT_TIMEOUT_MS, 0, 0));
//             reqQueue.setRetryPolicy(new DefaultRetryPolicy(0, 0, 0));
//             queue.add(reqQueue);
        }
    }
}



