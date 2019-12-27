package ebiz.lotus.administrator.eaglebiz;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.telephony.gsm.GsmCellLocation;
import android.util.Log;
import android.widget.Toast;

import org.jetbrains.annotations.NotNull;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import im.delight.android.location.SimpleLocation;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class MyBroadcastReceiver extends BroadcastReceiver {
    MediaPlayer mp;
    private SimpleLocation simpleLocation;
    String android_id;
    double latitude=0.0,longitude=0.0;
    String test_service= "http://10.100.1.32:8080/att.service/hrms/attendance/save/location";
//    String hrms_Service = "http://192.168.2.5:8383/global.service/global/updateAnyGlobalDataForMobile"; //dev
 //  String hrms_Service=  "http://192.168.2.3:8080/global.service/global/updateAnyGlobalDataForMobile"; //test
 //  String hrms_Service = "http://www.e-biz.in:8083/global.service/global/updateAnyGlobalDataForMobile"; //global

    @Override
    public void onReceive(Context context, Intent intent) {
        mp=MediaPlayer.create(context,R.raw.alarm);
        mp.start();
        simpleLocation=new SimpleLocation(context);
        if(!simpleLocation.hasLocationEnabled()){
            SimpleLocation.openSettings(context);
        }else{
            latitude=simpleLocation.getLatitude();
            longitude=simpleLocation.getLongitude();
            android_id = Settings.Secure.getString(context.getContentResolver(),Settings.Secure.ANDROID_ID);

            Toast.makeText(context, "android : "+android_id, Toast.LENGTH_SHORT).show();
            Log.v("android_id : ",android_id);

            JSONObject jsonObject=new JSONObject();
            try {

                jsonObject.put("latitude",latitude);
                jsonObject.put("longitude",longitude);
                jsonObject.put("deviceId",android_id);


            } catch (JSONException e) {
                e.printStackTrace();
            }


            TelephonyManager telephonyManager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
            @SuppressLint("MissingPermission") GsmCellLocation cellLocation = (GsmCellLocation)telephonyManager.getCellLocation();

            int cid=cellLocation.getCid();
            int lac=cellLocation.getLac();
            int psc=cellLocation.getPsc();

            Toast.makeText(context, cellLocation.toString(), Toast.LENGTH_SHORT).show();
            Toast.makeText(context, "Gsm Cell ID : "+cid, Toast.LENGTH_SHORT).show();
            Toast.makeText(context, "Gsm Location Area Code : "+lac, Toast.LENGTH_SHORT).show();

            Log.d("Gsm Area Code : ",""+lac);
            Log.d("Gsm Cid : ",""+cid);

//

//            MediaType JSON = MediaType.parse("application/json; charset=utf-8");
//            RequestBody body = RequestBody.create(JSON, jsonObject.toString());
//
//            OkHttpClient client = new OkHttpClient();
//
//            Request request = new Request.Builder()
//                    .url(test_service)
//                    .post(body)
//                    .build();
//
//            Call call = client.newCall(request);
//
//            call.enqueue(new Callback() {
//                @Override
//                public void onFailure(@NotNull Call call, @NotNull IOException e) {
//                    Toast.makeText(context, e.toString(), Toast.LENGTH_SHORT).show();
//                    Log.d("error : ",e.toString());
//                }
//
//                @Override
//                public void onResponse(@NotNull Call call, @NotNull Response response) throws IOException {
//                    Toast.makeText(context, response.body().toString(), Toast.LENGTH_SHORT).show();
//                }
//            });


        }
    }
}
