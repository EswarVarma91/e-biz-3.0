package ebiz.lotus.administrator.eaglebiz

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        AppCenter.start(application, "f56ca720-90e4-4964-92a4-10c291e68a86", Analytics::class.java, Crashes::class.java)
        startAlert()
    }

    fun startAlert(){
        val intent = Intent(this,MyBroadcastReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(this.applicationContext,234,intent,0)
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

        alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis(),5*60*1000,pendingIntent)
    }

    // simpleLocation = new SimpleLocation(context);
    //     if (!simpleLocation.hasLocationEnabled()) {
    //         SimpleLocation.openSettings(context);
    //     } else {
            
    //     }
}
