package ebiz.lotus.administrator.eaglebiz;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.provider.Settings;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import im.delight.android.location.SimpleLocation;

public class MyBroadcastReceiver extends BroadcastReceiver {
    MediaPlayer mp;
    private SimpleLocation simpleLocation;
    String android_id;
    double latitude=0.0,longitude=0.0;
    String hrms_Service = "http://192.168.2.5:8383/global.service/global/updateAnyGlobalDataForMobile"; //dev
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

//            JSONObject jsonObject=new JSONObject();
//            try {
//                jsonObject.put("parameter1","");
//                jsonObject.put("parameter3",latitude);
//                jsonObject.put("parameter4",longitude);
//                jsonObject.put("parameter5",android_id);
//
//
//            } catch (JSONException e) {
//                e.printStackTrace();
//            }
//
//
//            RequestQueue que= Volley.newRequestQueue(context);
//            JsonObjectRequest req= new JsonObjectRequest(Request.Method.POST,hrms_Service,jsonObject,
//                    new Response.Listener<JSONObject>(){
//
//                        @Override
//                        public void onResponse(JSONObject response) {
//
//                        }
//                    },new Response.ErrorListener(){
//
//                        @Override
//                        public void onErrorResponse(VolleyError error) {
//
//                        }
//                    });
//
//            que.add(req);

        }
    }
}
