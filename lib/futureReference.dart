// //static  var now = DateTime.now(); DateFormat("yyyy-MM-dd hh:mm:ss").format(now)

// DATA={
//   "notification":
// {
//   "body": "this is a body",
//   "title": "this is a title"
//   },
//   "priority": "high",
// "data":
// {
//   "click_action": "FLUTTER_NOTIFICATION_CLICK",
//   "id": "1",
//   "status": "done"
//   },
// "to": "<FCM TOKEN>"
// }


// curl https://fcm.googleapis.com/fcm/send -H "Content-Type:application/json" -X POST -d "$DATA" -H "Authorization: key=<FCM SERVER KEY>"


// package ebiz.lotus.administrator.eaglebiz

// import android.content.BroadcastReceiver
// import android.content.Context
// import android.content.Intent
// import android.location.LocationManager
// import android.media.MediaPlayer
// import android.provider.Settings
// import android.widget.Toast
// import com.android.volley.Request
// import com.android.volley.Response
// import com.android.volley.toolbox.JsonObjectRequest
// import com.android.volley.toolbox.Volley
// import org.json.JSONObject


// class MyBroadcastReceiver : BroadcastReceiver() {
//     private lateinit var  mp: MediaPlayer
//     var android_id: String? = null
//     var locationManager:LocationManager? =null
//     var gps: GPSTracker? = null
//     var latitude: Double?=0.0
//     var longitude:Double?=0.0

//     var hrms_Service = "http://192.168.2.5:8383/global.service/global/updateAnyGlobalDataForMobile" //dev
// //  var hrms_Service=  "http://192.168.2.3:8080/global.service/global/updateAnyGlobalDataForMobile"; //test
// //  var hrms_Service = "http://www.e-biz.in:8083/global.service/global/updateAnyGlobalDataForMobile"; //global

//     override fun onReceive(context: Context, intent: Intent) {
//         mp = MediaPlayer.create(context, R.raw.alarm)
//         mp.start()

//         if(gps?.canGetLocation()!!){
//             latitude = gps!!.getLatitude()
//             longitude = gps!!.getLongitude()
//             android_id = Settings.Secure.getString(context.getContentResolver(),Settings.Secure.ANDROID_ID)
//             Toast.makeText(context,"lati "+latitude+"\n"+"longi "+longitude+"\n android id "+android_id,Toast.LENGTH_LONG).show()
//         }else{
//             gps?.showSettingsAlert()
//         }

//        val queue= Volley.newRequestQueue(context)
//        val jsonObj= JSONObject()
//        jsonObj.put("parameter1","insertUserLocations")
//        jsonObj.put("android_id",android_id)
//        jsonObj.put("lati",latitude)
//        jsonObj.put("longi",longitude)
//
//        val req = JsonObjectRequest(Request.Method.POST,hrms_Service,jsonObj, Response.Listener
//        {
//
//        },
//                Response.ErrorListener
//                {
//
//                })
//
// //        queue.add(req)
//     }
// }